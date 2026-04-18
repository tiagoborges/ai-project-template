# {{PROJECT_SLUG}}

_Short project description._

- **Architecture & commands:** see [`AGENTS.md`](./AGENTS.md)
- **Claude Code entry:** [`CLAUDE.md`](./CLAUDE.md)
- **Copilot entry:** [`.github/copilot-instructions.md`](./.github/copilot-instructions.md)

## Quick start on a new machine

```bash
git clone <repo>
cd {{PROJECT_SLUG}}

cp .env.example .env          # fill in real values
direnv allow                  # auto-load .env on cd (needs direnv installed)
npx skillkit manifest install # fetch external AI skills from .skills
code .                        # or: claude
```

## How it works

### Where each assistant reads from

| Assistant | MCP servers | Skills | Instructions |
|---|---|---|---|
| **Claude Code** | `.mcp.json` | `.claude/skills/` (from skillkit) | `CLAUDE.md` → `AGENTS.md` |
| **VS Code + Copilot** | `.vscode/mcp.json` | `.github/skills/` (if present) | `.github/copilot-instructions.md` → `AGENTS.md` |
| **Copilot CLI** | `.github/copilot/*.json` | `.github/skills/` (if present) | `.github/copilot-instructions.md` |

All three MCP config files reference credentials via `${env:…}` — real values live in `.env` (gitignored), loaded by direnv.

### Adding skills or MCPs

- **New MCP server:** add to all three of `.mcp.json`, `.vscode/mcp.json`, `.github/copilot/*.json`. Reference credentials via `${env:…}` and add the variable to `.env.example`.
- **New external skill source:** `npx skillkit manifest add owner/repo` → commit `.skills`. Teammates sync with `npx skillkit manifest install`.
- **Update fetched skills:** re-run `npx skillkit manifest install`.

See [`AGENTS.md`](./AGENTS.md) for project architecture, commands, and coding conventions.
