test_ref_removed_after_successful_unwip() {
	echo base >a.txt
	git add a.txt
	git commit -q -m init
	echo mod >>a.txt
	git wip
	assert_eq "$(git for-each-ref refs/wip/ | wc -l)" "1" "refs/wip should hold exactly one ref right after wip"
	git unwip
	assert_eq "$(git for-each-ref refs/wip/)" "" "refs/wip should be empty after unwip"
}
