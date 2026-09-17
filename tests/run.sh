#!/usr/bin/env bash
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$DIR/lib.sh"

for f in "$DIR"/test_*.sh; do
	# shellcheck disable=SC1090
	source "$f"
done

test_names=$(declare -F | awk '{print $3}' | grep '^test_' | sort)

for t in $test_names; do
	CURRENT_TEST="$t"
	setup_env
	"$t"
	teardown_env
done

echo
echo "Passed: $PASS  Failed: $FAIL"
[ "$FAIL" -eq 0 ]
