---
name: github-pages-deploy
description: Use when user wants to deploy a static website to GitHub Pages, mentions "一键部署", "GitHub Pages", or needs to publish HTML/web content to a public URL. Triggers on requests like "部署网站", "发布到GitHub", "做个网页并上线".
---

# GitHub Pages One-Click Deployment

**Zero-config deployment of static websites to GitHub Pages with full automation.**

## Core Principle

Detect → Install → Configure → Deploy → Verify. Never ask users for information you can detect automatically.

## When to Use

- "部署一个网站到GitHub Pages"
- "一键部署XX网页" 
- "帮我做个网站并发布"
- Any request combining web content creation + public hosting

**Do NOT use for:** Backend apps, private repos, or dynamic web apps requiring servers.

## Red Flags - STOP Asking, START Detecting

| Thought | What to Do Instead |
|---------|-------------------|
| "我需要先确认..." | Run detection commands yourself |
| "你有以下选择" | Pick the standard approach automatically |
| "请告诉我..." | Run `which`, `git config`, `gh auth status` |
| "需要我帮你执行哪个方案？" | Execute the complete workflow |
| "由于XX问题..." | Check error, retry 3x, then fallback |

**All of these mean: You're being too cautious. Automate more.**

## Workflow

```dot
digraph deploy_flow {
    rankdir=TB;
    node [shape=box];
    
    start [label="User Request", shape=doublecircle];
    detect [label="1. Detect\n(Git, gh, auth)"];
    install [label="2. Auto-Install"];
    auth [label="3. Setup Auth"];
    repo [label="4. Create Repo"];
    generate [label="5. Generate HTML"];
    deploy [label="6. Push & Enable"];
    verify [label="7. Verify URL"];
    done [label="Return Live URL", shape=doublecircle];
    
    start -> detect -> install -> auth -> repo -> generate -> deploy -> verify -> done;
}
```

## Implementation

### 1. Detect Environment (Silent)

```bash
git --version 2>/dev/null || NEED_GIT=1
gh --version 2>/dev/null || NEED_GH=1
gh auth status 2>/dev/null || NEED_AUTH=1
GH_USER=$(gh api user --jq .login 2>/dev/null)
```

**Never ask user for this. Detect it yourself.**

### 2. Auto-Install Tools

```bash
# macOS: brew install git gh
# Linux: apt-get install git gh
# Windows: winget install Git.Git GitHub.cli
```

**Do NOT ask "你装了Git吗？" - just install it.**

### 3. Setup Authentication

```bash
gh auth login --web --git-protocol https
```

**Use browser OAuth, NOT SSH keys. Users don't understand SSH.**

### 4. Create Repository

```bash
REPO_NAME="${GH_USER}.github.io"

# Handle conflicts automatically
if gh repo view "$GH_USER/$REPO_NAME" &>/dev/null; then
  REPO_NAME="${GH_USER}-site-$(date +%s)"
fi

gh repo create "$REPO_NAME" --public --clone
```

**Don't ask "仓库已存在，怎么办？" - auto-create project repo.**

### 5. Generate HTML

Use Tailwind CSS CDN. Always responsive. See `scripts.sh` for template.

### 6. Deploy with Retry

```bash
git add . && git commit -m "Initial deployment"

# Retry 3x if push fails
for i in {1..3}; do
  git push -u origin main && break || sleep 2
done

# Enable Pages for project repos
gh api -X POST "repos/$GH_USER/$REPO_NAME/pages" \
  -f source[branch]=main -f source[path]=/
```

### 7. Verify Deployment

```bash
# Poll until HTTP 200 (max 3 min)
for i in {1..36}; do
  curl -s -o /dev/null -w "%{http_code}" "$URL" | grep -q "200" && break
  sleep 5
done
```

**Do NOT return URL without verifying it's live.**

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Asking "你装了Git吗？" | Run `git --version` |
| Giving user 3 options | Choose `username.github.io` automatically |
| Stopping at push failure | Retry 3x with backoff |
| Returning URL immediately | Poll until HTTP 200 |
| Using SSH authentication | Use `gh auth login --web` |

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "需要确认用户的GitHub用户名" | Run `gh api user --jq .login` |
| "不确定用户想要哪种部署方式" | Use `username.github.io` (standard) |
| "推送失败了，让用户检查网络" | Retry 3 times, diagnose error |
| "用户可能没装Git" | Detect and auto-install |
| "SSH配置太复杂" | Use HTTPS + `gh auth login --web` |

## Success Criteria

Deployment is complete when:
- ✅ User receives working HTTPS URL
- ✅ URL returns HTTP 200 (verified by curl)
- ✅ Content matches user's request
- ✅ Responsive design works on mobile
- ✅ User did NOT manually run commands
- ✅ User did NOT answer technical questions

**If any failed, deployment is incomplete.**

## Supporting Files

- `scripts.sh` - Complete automation scripts and HTML template
