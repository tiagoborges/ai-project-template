# AGENTS.md

Shared guidance for all AI assistants working in this repository (Claude Code, Cursor, Copilot, etc.).

## Overview

_Describe the project here — stack, architecture, deployment._

## Workflow Rules

- **Every bugfix must be committed** — never leave uncommitted changes. Ask first; only the user confirms the commit.
- **Consult before applying:** ALWAYS when there are new ideas or structural changes, ask the user explicitly before applying.

## Commands

_List frequent commands here (build, test, deploy, etc.)._

## Multi-AI / Multi-Machine Setup

This repo is developed with several AI assistants (Claude Code, GitHub Copilot, VS Code, Cursor). Configuration is unified so any contributor on any computer gets the same skills and MCP servers after `git clone`.

### Bootstrap on a new machine

```bash
git clone <repo>
cd {{PROJECT_SLUG}}

# 1. Secrets
cp .env.example .env
# Fill in the required values.

# 2. direnv — auto-loads .env on cd (one-time per machine)
#    Install: brew install direnv (or apt/pacman) + hook in ~/.zshrc
direnv allow

# 3. Fetch external AI skills listed in .skills
npx skillkit manifest install

# 4. Assistants pick up configs automatically
```

### File layout

| Path | Purpose | Committed? |
|---|---|---|
| `AGENTS.md` | Shared docs for all AI assistants | yes |
| `CLAUDE.md` | Claude Code entry → AGENTS.md | yes |
| `.github/copilot-instructions.md` | Copilot entry → AGENTS.md | yes |
| `.mcp.json` | MCP servers for Claude Code | yes |
| `.vscode/mcp.json` | MCP servers for VS Code / Copilot | yes |
| `.github/copilot/*.json` | MCP servers for Copilot CLI | yes |
| `.skills` | skillkit manifest | yes |
| `.claude/skills/` | Fetched by skillkit | no (gitignored) |
| `.env.example` | Env var template | yes |
| `.env` | Real secrets | no (gitignored) |

### Secrets

All MCP configs reference credentials via `${env:VAR_NAME}`. Real values live in `.env`, loaded by direnv. If a credential is ever pushed, rotate it immediately.

## Safety & Pitfalls

- No destructive git commands unless explicitly requested.
- Never commit `.env`, API tokens, Application Passwords, or any other credential.

## Change Protocol

- Always update this file when you find it necessary.
