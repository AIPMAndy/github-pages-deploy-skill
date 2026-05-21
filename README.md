# GitHub Pages Deploy Skill

**Zero-config deployment of static websites to GitHub Pages with full automation.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This skill enables AI agents (Claude Code, Cursor, etc.) to automatically deploy static websites to GitHub Pages with zero user configuration. It follows Test-Driven Development principles and has been validated through comprehensive pressure testing.

## Features

- 🚀 **Zero Configuration** - Automatically detects and installs Git, GitHub CLI
- 🔐 **Smart Authentication** - Uses browser OAuth (no SSH key setup needed)
- 🎯 **Intelligent Conflict Handling** - Auto-creates project repos when main repo exists
- ✅ **End-to-End Verification** - Polls URL until HTTP 200 confirmed
- 🔄 **Retry Logic** - Automatic retry on push failures
- 📱 **Responsive Design** - Generated sites use Tailwind CSS

## Quick Start

### For AI Agents

When a user requests:
- "部署一个网站到GitHub Pages"
- "一键部署XX网页"
- "帮我做个网站并发布"

This skill automatically triggers and executes the complete deployment pipeline.

### Installation

```bash
# Clone to your skills directory
cd ~/.openclaw/skills/  # or ~/.claude/skills/ for Claude Code
git clone https://github.com/AIPMAndy/github-pages-deploy-skill.git github-pages-deploy
```

### Manual Usage

See `scripts.sh` for standalone automation scripts.

## Workflow

```
User Request → Detect Environment → Auto-Install Tools → Setup Auth 
→ Create Repo → Generate HTML → Push & Deploy → Verify URL → Return Live Link
```

## Testing

This skill was developed using TDD methodology:

- **RED Phase**: Baseline tests showed agents asking 4+ questions with zero progress
- **GREEN Phase**: With skill, agents achieve zero questions and 100% deployment success
- **REFACTOR Phase**: 5 pressure scenarios tested, all passed

### Test Results

| Metric | Without Skill | With Skill |
|--------|--------------|------------|
| Questions Asked | 4+ | 0 |
| Deployment Success | 0% | 100% |
| User Interaction | Multi-round | Zero |
| URL Verification | None | HTTP 200 confirmed |

## Core Principles

1. **Detect, Don't Ask** - Run detection commands instead of asking users
2. **Auto-Install** - Install missing tools automatically
3. **Smart Defaults** - Choose `username.github.io` automatically
4. **Verify Everything** - Poll URL until confirmed live
5. **Handle Failures** - Retry with backoff, not user escalation

## Files

- `SKILL.md` - Main skill documentation (673 words)
- `scripts.sh` - Automation scripts and HTML templates
- `CREATION-SUMMARY.md` - TDD development process

## Development

This skill was created following the TDD methodology from [superpowers:writing-skills](https://github.com/superpowers-marketplace/superpowers):

1. RED: Write failing tests (baseline agent behavior)
2. GREEN: Write minimal skill to pass tests
3. REFACTOR: Close loopholes, compress content

## Requirements

- Git
- GitHub CLI (`gh`)
- GitHub account
- macOS/Linux/Windows

All tools are auto-installed if missing.

## License

MIT License - see LICENSE file for details

## Contributing

Contributions welcome! Please:

1. Follow TDD methodology
2. Test with real agents before submitting
3. Keep skill concise (<700 words)
4. Document all rationalizations found

## Author

Created by Andy ([@AIPMAndy](https://github.com/AIPMAndy))

## Acknowledgments

- Inspired by the [Superpowers Skills](https://github.com/superpowers-marketplace/superpowers) framework
- TDD methodology from `superpowers:writing-skills`

---

**Status**: Production-ready, TDD-validated ✅
