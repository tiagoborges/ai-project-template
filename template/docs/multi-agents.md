# Multi-AI / Multi-Machine Setup

This repo is developed with several AI assistants (Claude Code, GitHub Copilot, Pi) across multiple machines. Configuration is unified so any contributor on any computer gets the same skills and MCP servers after `git clone`.

## File Layout

| Path | Purpose | Committed? |
|---|---|---|
| `AGENTS.md` | Shared docs for all AI assistants | ✅ |
| `CLAUDE.md` | Claude Code entry → AGENTS.md | ✅ |
| `.github/copilot-instructions.md` | Copilot entry → AGENTS.md | ✅ |
| `.mcp.json` | MCP servers for Claude Code | ✅ |
| `.vscode/mcp.json` | MCP servers for VS Code / Copilot | ✅ |
| `.github/copilot/*.json` | MCP servers for Copilot CLI | ✅ |
| `skills-lock.json` | npx skills lockfile — tracks installed skills | ✅ |
| `.agents/skills/` | Canonical skills dir (GitHub Copilot reads here) | ❌ gitignored |
| `.claude/skills/` | Symlinks → `.agents/skills/` (Claude Code) | ❌ gitignored |
| `.pi/skills/` | Symlinks → `.agents/skills/` (Pi) | ❌ gitignored |
| `.env.example` | Env var template | ✅ |
| `.env` | Real secrets | ❌ gitignored |

## Bootstrap on a New Machine

```bash
git clone <repo>
cd {{PROJECT_SLUG}}

# 1. Secrets
cp .env.example .env
# Fill in the required values.

# 2. direnv — auto-loads .env on cd (one-time per machine)
#    Install: brew install direnv (or apt/pacman) + hook in ~/.zshrc
direnv allow

# 3. Install AI skills (use --agent flags, NOT --all)
npx skills add pbakaus/impeccable \
  --agent "Claude Code" --agent "GitHub Copilot" --agent "Pi" -y

# 4. Assistants pick up configs automatically
#    - Claude Code    → reads .mcp.json + .claude/skills/ + CLAUDE.md
#    - VS Code Copilot → reads .vscode/mcp.json + .agents/skills/
#    - Copilot CLI     → reads .github/copilot/*.json + .agents/skills/
#    - Pi             → reads .pi/skills/
```

## Secrets

All MCP configs reference credentials via `${env:VAR_NAME}`. Real values live in `.env`, loaded by direnv. If a credential is ever committed by accident, **rotate it immediately** (GitHub treats any pushed secret as public).

- Never commit `.env`, API tokens, Application Passwords, or any credential.
- Never put secrets inside `.claude/settings.local.json`. Reference env vars from `.env` instead.

## MCP Servers

All three config files (`.mcp.json`, `.vscode/mcp.json`, `.github/copilot/*.json`) declare the same servers. Keep them in sync when adding or modifying a server.

> **Pi Code note:** Pi reads `AGENTS.md` and skills from `.pi/skills/`, but [does not support MCP by design](https://mariozechner.at/posts/2025-11-02-what-if-you-dont-need-mcp/). MCP configs apply to Claude Code, VS Code Copilot, and Copilot CLI only.

## Skills

Skills are managed by [`npx skills`](https://skills.sh) (vercel-labs/skills). Canonical files live in `.agents/skills/`; agent-specific dirs (`.claude/skills/`, `.pi/skills/`) are symlinks to it. None are committed — `skills-lock.json` tracks what's installed.

```bash
# Add a new skill (use --agent flags, NOT --all)
npx skills add owner/repo --agent "Claude Code" --agent "GitHub Copilot" --agent "Pi" -y

# Update all installed skills
npx skills update -y

# List installed skills
npx skills list
```
