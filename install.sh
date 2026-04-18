#!/usr/bin/env bash
# install.sh — scaffold AI tooling into current (or target) project
#
# Usage (from anywhere):
#   curl -sSL https://raw.githubusercontent.com/tiagoborges/ai-project-template/main/install.sh | bash
#
# Usage (if the template repo is already cloned):
#   ./install.sh [target-dir]

set -euo pipefail

TEMPLATE_URL="https://github.com/tiagoborges/ai-project-template.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
TARGET_DIR="${1:-$(pwd)}"

# If we were piped from curl, clone the template to a temp dir first.
if [[ ! -d "$SCRIPT_DIR/template" ]]; then
  TMP=$(mktemp -d)
  trap "rm -rf $TMP" EXIT
  echo "→ fetching template…"
  git clone --depth 1 "$TEMPLATE_URL" "$TMP/ai-project-template" >/dev/null 2>&1
  SCRIPT_DIR="$TMP/ai-project-template"
fi

TEMPLATE_DIR="$SCRIPT_DIR/template"

# ─── Prompts ────────────────────────────────────────────────────────────
echo ""
echo "Scaffolding AI tooling into: $TARGET_DIR"
read -rp "Continue? [y/N] " ok
[[ "$ok" =~ ^[yY]$ ]] || { echo "aborted"; exit 0; }

default_slug="$(basename "$TARGET_DIR" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-')"
read -rp "Project slug (lowercase, dashes) [$default_slug]: " PROJECT_SLUG
PROJECT_SLUG="${PROJECT_SLUG:-$default_slug}"
PROJECT_UPPER="$(echo "$PROJECT_SLUG" | tr '[:lower:]-' '[:upper:]_')"

read -rp "Production host (e.g. example.com) [none]: " PROD_URL
read -rp "Staging host (e.g. stage.example.com) [none]: " STAGE_URL

# ─── Copy with substitution ─────────────────────────────────────────────
sed_subst() {
  sed \
    -e "s|{{PROJECT_SLUG}}|$PROJECT_SLUG|g" \
    -e "s|{{PROJECT_UPPER}}|$PROJECT_UPPER|g" \
    -e "s|{{PROD_URL}}|$PROD_URL|g" \
    -e "s|{{STAGE_URL}}|$STAGE_URL|g"
}

cp_templated() {
  local rel="$1" src="$TEMPLATE_DIR/$1" dst="$TARGET_DIR/$1"
  # Replace {{PROJECT_SLUG}} in the path itself (for filename templating)
  dst="${dst//\{\{PROJECT_SLUG\}\}/$PROJECT_SLUG}"
  rel="${rel//\{\{PROJECT_SLUG\}\}/$PROJECT_SLUG}"

  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" ]]; then
    echo "  ✗ skipped (exists): $rel"
  else
    sed_subst < "$src" > "$dst"
    echo "  ✓ created: $rel"
  fi
}

echo ""
echo "→ creating files"
(
  cd "$TEMPLATE_DIR"
  find . -type f -not -name '_gitignore' | while read -r f; do
    cp_templated "${f#./}"
  done
)

# ─── Merge .gitignore ───────────────────────────────────────────────────
marker="# ─── AI tooling (ai-project-template) ───"
if [[ -f "$TARGET_DIR/.gitignore" ]]; then
  if grep -qF "$marker" "$TARGET_DIR/.gitignore"; then
    echo "  ✗ skipped (already merged): .gitignore"
  else
    {
      echo ""
      echo "$marker"
      cat "$TEMPLATE_DIR/_gitignore"
    } >> "$TARGET_DIR/.gitignore"
    echo "  ✓ merged:  .gitignore"
  fi
else
  {
    echo "$marker"
    cat "$TEMPLATE_DIR/_gitignore"
  } > "$TARGET_DIR/.gitignore"
  echo "  ✓ created: .gitignore"
fi

# ─── skillkit manifest ──────────────────────────────────────────────────
echo ""
echo "→ Which AI agents will use this project? (skills will be installed for each)"
read -rp "  Claude Code?    [Y/n] " agent_claude
read -rp "  GitHub Copilot? [Y/n] " agent_copilot
read -rp "  Pi Code?        [y/N] " agent_pi

AGENTS=()
[[ ! "$agent_claude"  =~ ^[nN]$ ]] && AGENTS+=(--agent claude-code)
[[ ! "$agent_copilot" =~ ^[nN]$ ]] && AGENTS+=(--agent github-copilot)
[[   "$agent_pi"      =~ ^[yY]$ ]] && AGENTS+=(--agent pi)

if [[ ${#AGENTS[@]} -eq 0 ]]; then
  echo "  ✗ no agents selected — skipping skill install"
else
  if [[ -f "$TARGET_DIR/.skills" ]] && grep -q '^skills:' "$TARGET_DIR/.skills"; then
    echo "→ .skills already present — skipping skillkit init"
  else
    echo "→ initializing skillkit manifest"
    (cd "$TARGET_DIR" && npx -y skillkit manifest init)
  fi

  read -rp "Add pbakaus/impeccable (UI design skills)? [Y/n] " add_imp
  if [[ ! "$add_imp" =~ ^[nN]$ ]]; then
    (cd "$TARGET_DIR" && npx -y skillkit manifest add pbakaus/impeccable)
    echo "→ installing impeccable skills for: ${AGENTS[*]}"
    (cd "$TARGET_DIR" && npx -y skillkit install pbakaus/impeccable "${AGENTS[@]}" --all --yes)
  fi
fi

# ─── Done ───────────────────────────────────────────────────────────────
cat <<EOF

✓ Done.

Next steps:
  1. cp .env.example .env   # fill in real values
  2. direnv allow           # install direnv first if needed
  3. Review AGENTS.md and README.md, adapt to your project
  4. git add . && git commit -m "ai setup"

To re-install skills later (e.g. after pulling manifest changes):
  npx skillkit install <source> --agent claude-code --agent github-copilot --all --yes
  # add --agent pi if using Pi Code

EOF
