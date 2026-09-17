test_uninstall_removes_aliases() {
	git config --global --unset alias.wip
	git config --global --unset alias.unwip
	assert_failure "git wip should no longer exist" git config --global --get alias.wip
	assert_failure "git unwip should no longer exist" git config --global --get alias.unwip
}
