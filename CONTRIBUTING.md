# Contributing to GitHub Pages Deploy Skill

Thank you for your interest in contributing! This skill follows **Test-Driven Development (TDD)** methodology to ensure reliability and quality.

## 🎯 Development Philosophy

1. **Detect, Don't Ask** - Always prefer detection over user questions
2. **Auto-Install** - Install missing tools automatically
3. **Smart Defaults** - Choose sensible defaults without asking
4. **Verify Everything** - Confirm success with actual checks (HTTP 200, not assumptions)
5. **Handle Failures** - Retry with backoff, not user escalation

## 🧪 TDD Workflow

All contributions must follow the **RED → GREEN → REFACTOR** cycle:

### 1. RED Phase (Write Failing Tests)

Before writing any code, define the test scenario:

```markdown
**Test Scenario**: User with no Git installed requests deployment

**Expected Behavior**:
- Agent detects Git missing
- Agent installs Git automatically
- Agent proceeds with deployment
- No questions asked to user

**Current Behavior**:
- Agent asks "Do you have Git installed?"
- Deployment fails
```

### 2. GREEN Phase (Make Tests Pass)

Implement the minimum code to pass the test:

```bash
# Detection command
if ! command -v git &> /dev/null; then
    echo "Git not found, installing..."
    # Auto-install logic
fi
```

### 3. REFACTOR Phase (Improve Code)

Optimize without breaking tests:

```bash
# Improved version with error handling
detect_and_install_git() {
    if ! command -v git &> /dev/null; then
        echo "Git not found, installing..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install git || { echo "Failed to install Git"; exit 1; }
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt-get install -y git || { echo "Failed to install Git"; exit 1; }
        fi
    fi
}
```

## 📝 Contribution Types

### 1. Bug Fixes

If you find a bug:

1. **Document the bug** in an issue with:
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, Git version, etc.)

2. **Write a failing test** that reproduces the bug

3. **Fix the bug** and verify the test passes

4. **Submit a PR** with:
   - Link to the issue
   - Test scenario description
   - Before/after behavior comparison

### 2. New Features

For new features:

1. **Discuss first** - Open an issue to discuss the feature before coding

2. **Follow TDD**:
   - RED: Write test scenario showing current limitation
   - GREEN: Implement feature to pass test
   - REFACTOR: Optimize implementation

3. **Update documentation**:
   - Add to `SKILL.md` if it affects AI agent behavior
   - Add to `README.md` if it's user-facing
   - Add to `scripts.sh` if it's a new automation

4. **Test with real AI agents**:
   - Test with Claude Code, Cursor, or Hermes
   - Verify zero-question deployment still works
   - Document any new edge cases discovered

### 3. Documentation Improvements

Documentation contributions are welcome:

- Clarify existing instructions
- Add more examples
- Fix typos or grammar
- Translate to other languages

## 🧪 Testing Guidelines

### Required Tests

Before submitting a PR, test these scenarios:

1. **Fresh Environment**:
   - User with no Git installed
   - User with no GitHub CLI installed
   - User not authenticated to GitHub

2. **Conflict Scenarios**:
   - User already has `username.github.io` repo
   - User has uncommitted changes in working directory
   - Network failure during push

3. **Verification**:
   - URL returns HTTP 200 after deployment
   - HTML content is correct
   - Responsive design works on mobile

4. **Edge Cases**:
   - Very long repo names
   - Special characters in content
   - Large HTML files (>1MB)

### Testing with AI Agents

Test your changes with at least one AI agent:

```bash
# Example test with Claude Code
claude "帮我做个个人简历网站并发布到GitHub Pages"

# Verify:
# - No questions asked
# - Deployment succeeds
# - URL is live and verified
```

## 📏 Code Style

### Shell Scripts

- Use `bash` (not `sh`)
- Add error handling with `set -e`
- Use functions for reusability
- Add comments for complex logic
- Use `shellcheck` for linting

```bash
#!/bin/bash
set -e

# Good: Clear function with error handling
deploy_to_github_pages() {
    local repo_name="$1"
    
    if [[ -z "$repo_name" ]]; then
        echo "Error: repo_name is required"
        return 1
    fi
    
    # Deploy logic here
}
```

### SKILL.md Format

- Keep under 700 words (AI agent context limit)
- Use clear section headers
- Provide concrete examples
- Include detection commands
- Document all edge cases

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add custom domain support
fix: handle network timeout during push
docs: clarify installation steps
test: add scenario for existing repo conflict
refactor: extract auth logic to function
```

## 🚀 Pull Request Process

1. **Fork the repository**

2. **Create a feature branch**:
   ```bash
   git checkout -b feat/custom-domain-support
   ```

3. **Make your changes** following TDD methodology

4. **Test thoroughly**:
   - Run all test scenarios
   - Test with real AI agents
   - Verify documentation is updated

5. **Commit with clear messages**:
   ```bash
   git commit -m "feat: add custom domain support with auto-DNS verification"
   ```

6. **Push to your fork**:
   ```bash
   git push origin feat/custom-domain-support
   ```

7. **Open a Pull Request** with:
   - Clear title and description
   - Link to related issue (if any)
   - Test results and screenshots
   - Before/after behavior comparison

8. **Respond to feedback** - Address review comments promptly

## 🐛 Reporting Issues

When reporting issues, include:

1. **Environment**:
   - OS and version
   - Git version (`git --version`)
   - GitHub CLI version (`gh --version`)
   - AI agent used (Claude Code, Cursor, Hermes, etc.)

2. **Steps to Reproduce**:
   - Exact command or prompt used
   - Expected behavior
   - Actual behavior

3. **Logs**:
   - Terminal output
   - Error messages
   - Agent conversation (if applicable)

4. **Screenshots** (if relevant)

## 📚 Resources

- [TDD Methodology](https://en.wikipedia.org/wiki/Test-driven_development)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Superpowers Skills Framework](https://github.com/superpowers-marketplace/superpowers)

## 💬 Communication

- **Issues**: For bug reports and feature requests
- **Discussions**: For questions and ideas
- **Pull Requests**: For code contributions

## 🙏 Recognition

Contributors will be:
- Listed in the README
- Credited in release notes
- Mentioned in the project documentation

Thank you for helping make GitHub Pages deployment effortless for AI agents! 🚀

---

**Questions?** Open an issue or reach out to [@AIPMAndy](https://github.com/AIPMAndy)
