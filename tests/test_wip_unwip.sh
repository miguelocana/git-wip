_seed_mixed_state() {
	echo base >a.txt
	echo base >b.txt
	git add a.txt b.txt
	git commit -q -m init
	echo mod >>a.txt # unstaged
	echo mod >>b.txt
	git add b.txt # staged
	echo new >c.txt # untracked
}

test_wip_excludes_untracked_without_args() {
	_seed_mixed_state
	assert_success "git wip should succeed" git wip
	assert_eq "$(git status --porcelain -- c.txt)" "?? c.txt" "c.txt should stay untracked"
}

test_wip_includes_untracked_with_args() {
	_seed_mixed_state
	git wip c.txt
	assert_eq "$(git status --porcelain)" "" "working tree should be clean after wip with explicit arg"
}

test_unwip_restores_exact_state() {
	_seed_mixed_state
	local before
	before=$(git status --porcelain | sort)
	git wip c.txt
	git unwip
	local after
	after=$(git status --porcelain | sort)
	assert_eq "$after" "$before" "unwip should restore the exact staged/unstaged/untracked split"
	assert_eq "$(cat a.txt)" "$(printf 'base\nmod\n')" "a.txt content should be untouched"
}

test_stacked_wip_unwip() {
	echo base >g.txt
	git add g.txt
	git commit -q -m real
	echo mod1 >>g.txt
	git wip
	echo mod2 >>g.txt
	git wip
	git unwip
	git unwip
	assert_eq "$(git status --porcelain)" " M g.txt" "two unwips should fully unwind two stacked wips"
	assert_eq "$(cat g.txt)" "$(printf 'base\nmod1\nmod2\n')" "g.txt should contain both edits"
}
