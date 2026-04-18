# ai-project-template

Opinionated template that wires **Claude Code**, **GitHub Copilot**, and **VS Code** into any project with a single source of truth for MCP servers, skills, and secrets.

Drop this into a new repo (template) or a repo you already have (install script).

## What you get

| File | Purpose |
|---|---|
| `.env.example` + `.envrc` | Secrets template + direnv auto-load |
| `.mcp.json` | MCP servers for Claude Code |
| `.vscode/mcp.json` | MCP servers for VS Code + Copilot |
| `.github/copilot/*.json` | MCP servers for Copilot CLI |
| `.github/copilot-instructions.md` | Copilot entry pointing at AGENTS.md |
| `CLAUDE.md` | Claude Code entry pointing at AGENTS.md |
| `AGENTS.md` | Single doc read by all AI assistants |
| `README.md` | Bootstrap + architecture for contributors |
| `.skills` | [skillkit](https://github.com/rohitg00/skillkit) manifest for external skills |
| `.gitignore` | Ignores `.env`, `.claude/skills/`, etc. |

All MCP configs reference credentials via `${env:VAR}`. Real values live in `.env`, loaded automatically by [direnv](https://direnv.net/).

## Usage

### New project — GitHub template

This repo is marked as a GitHub **Template**. Click **Use this template** on GitHub, or run:

```bash
gh repo create my-new-project --template tiagoborges/ai-project-template --private --clone
cd my-new-project
./install.sh
```

### Existing project — one-liner

```bash
curl -sSL https://raw.githubusercontent.com/tiagoborges/ai-project-template/main/install.sh | bash
```

Or clone and run manually:

```bash
git clone https://github.com/tiagoborges/ai-project-template.git
./ai-project-template/install.sh /path/to/your/project
```

The script will:

1. Prompt for project slug, production URL, staging URL
2. Copy templated files into your project (skipping anything that already exists)
3. Substitute placeholders (`{{PROJECT_SLUG}}`, `{{PROD_URL}}`, etc.)
4. Merge entries into your existing `.gitignore`
5. Initialize a [skillkit](https://github.com/rohitg00/skillkit) manifest and optionally add `pbakaus/impeccable`

## Placeholders

| Token | Example | Where it's used |
|---|---|---|
| `{{PROJECT_SLUG}}` | `sailzen` | MCP server names, Copilot config filenames |
| `{{PROJECT_UPPER}}` | `SAILZEN` | Env var prefixes (e.g. `SAILZEN_WP_USER`) |
| `{{PROD_URL}}` | `example.com` | Production WP MCP URL |
| `{{STAGE_URL}}` | `stage.example.com` | Staging WP MCP URL |

## Bootstrap on a machine (prerequisites)

```bash
# direnv (auto-load .env on cd)
brew install direnv              # or: apt install direnv / pacman -S direnv
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc   # or bash
source ~/.zshrc

# skillkit is used via npx — no install needed
```

## Customizing

The template defaults assume a WordPress project (two WP MCP servers — prod & stage — plus Hostinger API). Edit `template/.mcp.json`, `template/.vscode/mcp.json`, and the Copilot JSON files to match your stack before running the install script, or edit them in the target project afterward.
