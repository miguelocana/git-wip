#!/usr/bin/env bash
set -euo pipefail

WIP_ALIAS=$(cat <<'EOF'
!f() {
	tree=$(git write-tree)
	git add -u
	if [ "$#" -gt 0 ]; then git add -- "$@"; fi
	if ! git commit -m wip -m "Wip-Index: $tree"; then
		return 1
	fi
	git update-ref "refs/wip/$tree" "$tree"
}; f
EOF
)

UNWIP_ALIAS=$(cat <<'EOF'
!f() {
	subject=$(git log -1 --pretty=%s 2>/dev/null)
	if [ "$subject" != wip ]; then
		echo 'HEAD is not wip, aborting'
		return 1
	fi
	tree=$(git log -1 --format='%(trailers:key=Wip-Index,valueonly)')
	if [ -z "$tree" ]; then
		echo 'no Wip-Index trailer found, aborting'
		return 1
	fi
	if ! git reset --soft HEAD^; then
		return 1
	fi
	git read-tree "$tree"
	git update-ref -d "refs/wip/$tree"
	echo "Restored:"
	git status --short
}; f
EOF
)

git config --global alias.wip "$WIP_ALIAS"
git config --global alias.unwip "$UNWIP_ALIAS"

echo "Installed: git wip / git unwip (alias.wip, alias.unwip in global ~/.gitconfig)"
