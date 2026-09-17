# git-wip

Checkpoint your work in progress as a regular commit, then undo it and
get back the exact same staged, unstaged, and untracked files.

Like `git stash`, but the checkpoint lives on your branch, so you can
see it in the log, push it, and not lose it in a stash stack.

```
$ git status
On branch main
Changes to be committed:
	modified:   auth.py
Changes not staged for commit:
	modified:   utils.py
Untracked files:
	scratch.py

$ git wip scratch.py
[main 8474555] wip
 3 files changed, 3 insertions(+)
 create mode 100644 scratch.py

$ git status
On branch main
nothing to commit, working tree clean

$ git unwip
Restored:
M  auth.py
 M utils.py
?? scratch.py
```

## Usage

```sh
git wip               # stages tracked modified files (git add -u) + commit "wip"
git wip a.py b.py     # also stages those untracked files before committing
git unwip              # undoes the wip commit and restores the original staged/unstaged/untracked state
```

## Installation

```sh
curl -fsSL https://raw.githubusercontent.com/miguelocana/git-wip/main/install.sh | bash
```

## Tests

```sh
bash tests/run.sh
```

## Uninstall

```sh
git config --global --unset alias.wip
git config --global --unset alias.unwip
```

## License

MIT
