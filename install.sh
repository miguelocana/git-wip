#!/usr/bin/env bash
set -euo pipefail

git config --global alias.wip "!f() { git add -u; if [ \"\$#\" -gt 0 ]; then git add -- \"\$@\"; fi; git commit -m 'wip'; }; f"
git config --global alias.unwip "!f() { if [ \"\$(git log -1 --pretty=%s)\" = 'wip' ]; then git reset --soft HEAD^; else echo 'HEAD is not wip, aborting'; fi; }; f"

echo "Installed: git wip / git unwip (alias.wip, alias.unwip in global ~/.gitconfig)"
