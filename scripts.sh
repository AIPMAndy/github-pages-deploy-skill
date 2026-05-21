#!/bin/bash
# GitHub Pages Deployment Automation Scripts

# 1. Environment Detection
detect_environment() {
    git --version 2>/dev/null || NEED_GIT=1
    gh --version 2>/dev/null || NEED_GH=1
    gh auth status 2>/dev/null || NEED_AUTH=1
    GH_USER=$(gh api user --jq .login 2>/dev/null)
}

# 2. Auto-Install Missing Tools
install_tools() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        [[ $NEED_GIT ]] && brew install git
        [[ $NEED_GH ]] && brew install gh
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        [[ $NEED_GIT ]] && sudo apt-get update && sudo apt-get install -y git
        [[ $NEED_GH ]] && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
            && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
            && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
            && sudo apt update && sudo apt install gh -y
    fi
}

# 3. Setup Authentication
setup_auth() {
    if [[ $NEED_AUTH ]]; then
        echo "需要授权GitHub访问，浏览器将打开进行授权..."
        gh auth login --web --git-protocol https
    fi
    GH_USER=$(gh api user --jq .login)
}

# 4. Create Repository
create_repo() {
    local REPO_NAME="${GH_USER}.github.io"

    if gh repo view "$GH_USER/$REPO_NAME" &>/dev/null; then
        REPO_NAME="${GH_USER}-site-$(date +%s)"
        echo "主仓库已存在，使用项目仓库: $REPO_NAME"
    fi

    gh repo create "$REPO_NAME" --public --clone
    cd "$REPO_NAME"
    echo "$REPO_NAME"
}

# 5. Deploy with Retry
deploy_with_retry() {
    git add .
    git commit -m "Initial deployment"

    for i in {1..3}; do
        git push -u origin main && break || sleep 2
    done

    # Enable Pages for project repos
    if [[ "$REPO_NAME" != "${GH_USER}.github.io" ]]; then
        gh api -X POST "repos/$GH_USER/$REPO_NAME/pages" \
            -f source[branch]=main -f source[path]=/
    fi
}

# 6. Verify Deployment
verify_deployment() {
    local REPO_NAME=$1
    local GH_USER=$2

    if [[ "$REPO_NAME" == "${GH_USER}.github.io" ]]; then
        URL="https://${GH_USER}.github.io"
    else
        URL="https://${GH_USER}.github.io/${REPO_NAME}"
    fi

    echo "等待GitHub Pages部署..."
    for i in {1..36}; do
        if curl -s -o /dev/null -w "%{http_code}" "$URL" | grep -q "200"; then
            echo "✅ 部署成功！"
            echo "🔗 访问地址: $URL"
            return 0
        fi
        sleep 5
    done

    echo "⚠️ 部署可能需要更长时间，请稍后访问: $URL"
}

# HTML Template with Tailwind CSS
generate_html() {
    local TITLE=$1
    local CONTENT=$2

    cat > index.html <<EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${TITLE}</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen flex items-center justify-center p-4">
    <div class="bg-white rounded-2xl shadow-2xl p-8 max-w-2xl w-full">
        ${CONTENT}
    </div>
</body>
</html>
EOF
}
