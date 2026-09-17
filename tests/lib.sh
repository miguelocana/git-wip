#!/usr/bin/env bash
set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PASS=0
FAIL=0
CURRENT_TEST=""

fail() {
	echo "  FAIL: $CURRENT_TEST: $1"
	FAIL=$((FAIL + 1))
}

ok() {
	PASS=$((PASS + 1))
}

assert_eq() {
	local actual="$1" expected="$2" msg="${3:-values differ}"
	if [ "$actual" != "$expected" ]; then
		fail "$msg (expected [$expected], got [$actual])"
		return 1
	fi
	ok
}

assert_contains() {
	local haystack="$1" needle="$2" msg="${3:-missing substring}"
	case "$haystack" in
	*"$needle"*)
		ok
		;;
	*)
		fail "$msg (expected to find [$needle] in [$haystack])"
		return 1
		;;
	esac
}

assert_success() {
	local msg="$1"
	shift
	if "$@" >/tmp/git-wip-test-out 2>&1; then
		ok
	else
		fail "$msg: expected success, got: $(cat /tmp/git-wip-test-out)"
		return 1
	fi
}

assert_failure() {
	local msg="$1"
	shift
	if "$@" >/dev/null 2>&1; then
		fail "$msg: expected failure, command succeeded"
		return 1
	fi
	ok
}

setup_env() {
	TEST_HOME="$(mktemp -d)"
	TEST_REPO="$(mktemp -d)"
	export HOME="$TEST_HOME"
	bash "$ROOT_DIR/install.sh" >/dev/null
	cd "$TEST_REPO"
	git init -q
	git config user.email test@example.com
	git config user.name "Test"
}

teardown_env() {
	cd "$ROOT_DIR"
	rm -rf "$TEST_HOME" "$TEST_REPO"
}
