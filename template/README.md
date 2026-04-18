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

# Fetch external AI skills (pick the agents you use)
npx skillkit install pbakaus/impeccable \
  --agent claude-code --agent github-copilot --all --yes
# add --agent pi for Pi Code

code .                        # or: claude / pi
```

## How it works

### Where each assistant reads from

| Assistant | MCP servers | Skills | Instructions |
|---|---|---|---|
| **Claude Code** | `.mcp.json` | `.claude/skills/` (skillkit) | `CLAUDE.md` → `AGENTS.md` |
| **VS Code + Copilot** | `.vscode/mcp.json` | `.github/skills/` (skillkit) | `.github/copilot-instructions.md` → `AGENTS.md` |
| **Copilot CLI** | `.github/copilot/*.json` | `.github/skills/` (skillkit) | `.github/copilot-instructions.md` |
| **Pi Code** | _not supported ([by design](https://mariozechner.at/posts/2025-11-02-what-if-you-dont-need-mcp/))_ | `.pi/skills/` (skillkit) | `AGENTS.md` / `CLAUDE.md` |

All three MCP config files reference credentials via `${env:…}` — real values live in `.env` (gitignored), loaded by direnv.

### Adding skills or MCPs

- **New MCP server:** add to all three of `.mcp.json`, `.vscode/mcp.json`, `.github/copilot/*.json`. Reference credentials via `${env:…}` and add the variable to `.env.example`. (Pi Code ignores MCP by design.)
- **New external skill source:** `npx skillkit manifest add owner/repo` → commit `.skills`. Teammates sync with `npx skillkit install owner/repo --agent claude-code --agent github-copilot --all --yes` (add `--agent pi` for Pi Code).
- **Update fetched skills:** re-run the same `skillkit install` command.

See [`AGENTS.md`](./AGENTS.md) for project architecture, commands, and coding conventions.
