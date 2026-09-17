test_install_sets_aliases() {
	local wip unwip
	wip=$(git config --global --get alias.wip)
	unwip=$(git config --global --get alias.unwip)
	assert_contains "$wip" "git write-tree" "alias.wip should be set"
	assert_contains "$unwip" "git read-tree" "alias.unwip should be set"
}

test_install_idempotent() {
	assert_success "reinstall should succeed" bash "$ROOT_DIR/install.sh"
	local count
	count=$(git config --global --get-all alias.wip | grep -c '^!f() {$')
	assert_eq "$count" "1" "alias.wip should have a single definition after reinstall, not appended"
}

test_install_does_not_touch_user_config() {
	git config --global user.name "Someone Else"
	git config --global user.email "someone@example.com"
	bash "$ROOT_DIR/install.sh" >/dev/null
	assert_eq "$(git config --global user.name)" "Someone Else" "install should not touch user.name"
	assert_eq "$(git config --global user.email)" "someone@example.com" "install should not touch user.email"
}
