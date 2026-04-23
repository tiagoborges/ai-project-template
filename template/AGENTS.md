# AGENTS.md

Shared guidance for all AI assistants working in this repository (Claude Code, GitHub Copilot, Pi Code, Cursor, etc.).

> **Pi Code note:** Pi reads `AGENTS.md` / `CLAUDE.md` and skills from `.pi/skills/`, but [does not support MCP by design](https://mariozechner.at/posts/2025-11-02-what-if-you-dont-need-mcp/). MCP servers (`.mcp.json`, `.vscode/mcp.json`, `.github/copilot/*.json`) are used by Claude Code, VS Code, and Copilot CLI only.

## Overview

_Describe the project here — stack, architecture, deployment._

## Workflow Rules

- **Every bugfix must be committed** — never leave uncommitted changes. Ask first; only the user confirms the commit.
- **Consult before applying:** ALWAYS when there are new ideas or structural changes, ask the user explicitly before applying.

## Commands

_List frequent commands here (build, test, deploy, etc.)._

## Multi-AI / Multi-Machine Setup

> See [`docs/multi-agents.md`](./docs/multi-agents.md) for file layout, bootstrap steps, MCP servers, secrets policy, and skills management.

## Safety & Pitfalls

- No destructive git commands unless explicitly requested.
- Never commit `.env`, API tokens, Application Passwords, or any other credential.

## Change Protocol

- Always update this file when you find it necessary.
