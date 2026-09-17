test_wip_nothing_to_commit_fails_no_leak() {
	echo base >a.txt
	git add a.txt
	git commit -q -m init
	assert_failure "wip with nothing staged should fail" git wip
	assert_eq "$(git for-each-ref refs/wip/)" "" "no stray refs/wip ref should remain after a failed wip"
}

test_unwip_head_not_wip_aborts() {
	echo base >a.txt
	git add a.txt
	git commit -q -m "not wip"
	assert_failure "unwip should abort when HEAD subject isn't wip" git unwip
	assert_eq "$(git log -1 --pretty=%s)" "not wip" "HEAD should be untouched"
}

test_unwip_first_commit_fails_cleanly() {
	echo base >a.txt
	git add a.txt
	git wip
	assert_failure "unwip on the repo's first commit should fail (no HEAD^)" git unwip
	assert_eq "$(git log -1 --pretty=%s)" "wip" "the wip commit should remain, recoverable by hand"
}

test_unwip_missing_trailer_aborts() {
	echo base >a.txt
	git add a.txt
	git commit -q -m init
	echo mod >a.txt
	git add a.txt
	git commit -q -m wip # manual commit literally titled "wip", no Wip-Index trailer
	assert_failure "unwip should abort when the wip commit has no Wip-Index trailer" git unwip
	assert_eq "$(git log -1 --pretty=%s)" "wip" "HEAD should be untouched"
}
