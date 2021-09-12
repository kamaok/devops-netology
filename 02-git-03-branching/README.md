```bash
$ git checkout main

```
```bash
Already on 'main'
Your branch is up to date with 'origin/main'.
```

```
$ git branch
```

```bash
  fix
* main
```

```
$ mkdir branching
```

```bash
for file in merge.sh rebase.sh; do cat <<'EOF' > branching/$file
#!/bin/bash
# display command line options

count=1
for param in "$*"; do
    echo "\$* Parameter #$count = $param"
    count=$(( $count + 1 ))
done
EOF
done
```

```bash
$ ls -l branching
```
```bash
total 8
-rw-rw-r-- 1 eugene eugene 149 июл 28 02:12 merge.sh
-rw-rw-r-- 1 eugene eugene 149 июл 28 02:12 rebase.sh
```

```
$ git status
```
```bash
On branch main
Your branch is up to date with 'origin/main'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	branching/
```

```
$ git add .
```

```
$ git commit -m "prepare for merge and rebase"
```

```
[main df19261] prepare for merge and rebase
 2 files changed, 16 insertions(+)
 create mode 100644 branching/merge.sh
 create mode 100644 branching/rebase.sh
```

```
$ git push
```
```bash
Counting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 458 bytes | 458.00 KiB/s, done.
Total 4 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To github.com:kamaok/devops-netology.git
   1ddeb60..df19261  main -> main
```

```
$ git checkout -b git-merge
```

```
Switched to a new branch 'git-merge'
```

```
$ git branch
```

```
  fix
* git-merge
  main
```

```bash
cat << 'EOF' > branching/merge.sh
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "\$@ Parameter #$count = $param"
    count=$(( $count + 1 ))
done
EOF
```

```
$ git status
```

```bash
On branch git-merge
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)


	branching/merge.sh
```

```bash
$ git add branching/merge.sh
```

```bash
$ git commit -m "merge: @ instead *"
```

```
[git-merge 69e1367] merge: @ instead *
[git-merge 91adb68] merge: @ instead *
 1 file changed, 2 insertions(+), 2 deletions(-)
```

```
$ git push -u origin git-merge
```

```bash
Counting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 390 bytes | 390.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
remote:
remote: Create a pull request for 'git-merge' on GitHub by visiting:
remote:      https://github.com/kamaok/devops-netology/pull/new/git-merge
remote:
To github.com:kamaok/devops-netology.git
 * [new branch]      git-merge -> git-merge
Branch 'git-merge' set up to track remote branch 'git-merge' from 'origin'.
```

```bash
cat << 'EOF' > branching/merge.sh
#!/bin/bash
# display command line options

count=1
while [[ -n "$1" ]]; do
    echo "Parameter #$count = $1"
    count=$(( $count + 1 ))
    shift
done
EOF
```

```
$ git status
```

```bash
On branch git-merge
Your branch is up to date with 'origin/git-merge'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   branching/merge.sh

no changes added to commit (use "git add" and/or "git commit -a")
```

```
$ git add branching/merge.sh
```

```
$ git commit -m "merge: use shift"
```
```bash
[git-merge 226d9b7] merge: use shift
 1 file changed, 3 insertions(+), 2 deletions(-)
```

```
$ git push origin git-merge
```

```bash
Counting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 462 bytes | 462.00 KiB/s, done.
Total 4 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To github.com:kamaok/devops-netology.git
   91adb68..226d9b7  git-merge -> git-merge
```

```
$ git checkout main
```

```bash
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
```
```
$ git branch
```
```bash
  fix
  git-merge
* main
```

```bash
cat << 'EOF' > branching/rebase.sh
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "\$@ Parameter #$count = $param"
    count=$(( $count + 1 ))
done

echo "====="
EOF
```

```
$ git status
```
```bash
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   branching/rebase.sh

no changes added to commit (use "git add" and/or "git commit -a")
```

```
$ git add branching/rebase.sh
```
```
$ git commit -m "rebase: @ instead *"
```
```bash
[main b9ace55] rebase: @ instead *
 1 file changed, 4 insertions(+), 2 deletions(-)
```

```
$ git push
```

```bash
Counting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 401 bytes | 401.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:kamaok/devops-netology.git
   df19261..b9ace55  main -> main
```

```
$ git log --oneline | grep 'prepare for merge and rebase'
```
```bash
df19261 prepare for merge and rebase
```
```
$ git checkout df19261
```
```bash
Note: checking out 'df19261'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at df19261 prepare for merge and rebase
```
```
$ git checkout -b git-rebase
```
```bash
Switched to a new branch 'git-rebase'
```
```bash
cat << 'EOF' > branching/rebase.sh
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "Parameter: $param"
    count=$(( $count + 1 ))
done

echo "====="
EOF
```

```
$ git status
```
```bash
On branch git-rebase
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   branching/rebase.sh

no changes added to commit (use "git add" and/or "git commit -a")
```
```
$ git add branching/rebase.sh
```
```
$ git commit -m "git-rebase 1"
```
```bash
[git-rebase f9730ce] git-rebase 1
 1 file changed, 4 insertions(+), 2 deletions(-)
```
```
$ git push -u origin git-rebase
```
```bash
Counting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 404 bytes | 404.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
remote:
remote: Create a pull request for 'git-rebase' on GitHub by visiting:
remote:      https://github.com/kamaok/devops-netology/pull/new/git-rebase
remote:
To github.com:kamaok/devops-netology.git
 * [new branch]      git-rebase -> git-rebase
Branch 'git-rebase' set up to track remote branch 'git-rebase' from 'origin'.
```

```bash
$ sed -i 's/Parameter/Next parameter/' branching/rebase.sh
```

```
$ git status
```
```bash
On branch git-rebase
Your branch is up to date with 'origin/git-rebase'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   branching/rebase.sh

no changes added to commit (use "git add" and/or "git commit -a")
```

```
$ git add branching/rebase.sh
```
```
$ git commit -m "git-rebase 2"
```
```bash
[git-rebase 36e07f5] git-rebase 2
 1 file changed, 1 insertion(+), 1 deletion(-)
```
```
$ git push
```
```bash
Counting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 374 bytes | 374.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:kamaok/devops-netology.git
   f9730ce..36e07f5  git-rebase -> git-rebase
```

[3 branches before `merge/rebase` - Check network in Github](https://github.com/kamaok/devops-netology/network)


```
$ git checkout main
```
```bash
Switched to branch 'main'
```
```
$ git merge git-merge
```
```bash
Merge made by the 'recursive' strategy.
 branching/merge.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
```
```
$ git push
```
```bash
Counting objects: 3, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 375 bytes | 375.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To github.com:kamaok/devops-netology.git
   b9ace55..25057e3  main -> main
```
```
$ git log --oneline --graph
```
```bash
*   25057e3 (HEAD -> main, origin/main, origin/HEAD) Merge branch 'git-merge' into main
|\
| * 226d9b7 (origin/git-merge, git-merge) merge: use shift
| * 91adb68 merge: @ instead *
* | b9ace55 rebase: @ instead *
|/
* df19261 prepare for merge and rebase
* 1ddeb60 (tag: v0.1, tag: v0.0, gitlab/main, bitbucket/main) Moved and deleted
* f7f8d4f Prepare to delete and move
* aeb8a88 Added gitignore
* 49a224f First commit
* c9a837e Initial commit
```


[Merge `git-merge` in `main` - Check network in Github](https://github.com/kamaok/devops-netology/network)

```
$ git checkout git-rebase
```
```bash
Switched to branch 'git-rebase'
Your branch is up to date with 'origin/git-rebase'.
```
```
$ git branch
```
```bash
  fix
  git-merge
* git-rebase
  main
```
```
$ git rebase -i main
```
Открывается редактор с таким содержимым:

```bash
pick f9730ce git-rebase 1
pick 36e07f5 git-rebase 2

# Rebase 25057e3..36e07f5 onto 25057e3 (2 commands)
#
# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
# d, drop = remove commit
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

Ничего не меняю, оставляем текущий комментарий

Ожидаемо получаем конфликт
```bash
Auto-merging branching/rebase.sh
CONFLICT (content): Merge conflict in branching/rebase.sh
error: could not apply f9730ce... git-rebase 1

Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".

Could not apply f9730ce... git-rebase 1
```

```
$ cat branching/rebase.sh
```
```bash
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
<<<<<<< HEAD
    echo "\$@ Parameter #$count = $param"
=======
    echo "Parameter: $param"
>>>>>>> f9730ce... git-rebase 1
    count=$(( $count + 1 ))
done

echo "====="
```
```
$ nano branching/rebase.sh
```
```bash
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "\$@ Parameter #$count = $param"
    count=$(( $count + 1 ))
done

echo "====="
```
```
$ git status branching/rebase.sh
```
```bash
interactive rebase in progress; onto 25057e3
Last command done (1 command done):
   pick f9730ce git-rebase 1
Next command to do (1 remaining command):
   pick 36e07f5 git-rebase 2
  (use "git rebase --edit-todo" to view and edit)
You are currently rebasing branch 'git-rebase' on '25057e3'.
  (fix conflicts and then run "git rebase --continue")
  (use "git rebase --skip" to skip this patch)
  (use "git rebase --abort" to check out the original branch)

Unmerged paths:
  (use "git reset HEAD <file>..." to unstage)
  (use "git add <file>..." to mark resolution)

	both modified:   branching/rebase.sh
```
```
$ git add  branching/rebase.sh
```
```
$ git rebase --continue
```
```bash
Auto-merging branching/rebase.sh
CONFLICT (content): Merge conflict in branching/rebase.sh
error: could not apply 36e07f5... git-rebase 2

Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".

Could not apply 36e07f5... git-rebase 2
```

```
$ cat branching/rebase.sh
```
```bash
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
<<<<<<< HEAD
    echo "\$@ Parameter #$count = $param"
=======
    echo "Next parameter: $param"
>>>>>>> 36e07f5... git-rebase 2
    count=$(( $count + 1 ))
done

echo "====="
```
```
$ nano branching/rebase.sh
```
```bash
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "Next parameter: $param"
    count=$(( $count + 1 ))
done

echo "====="
```
```
$ git add  branching/rebase.sh
```
```
$ git rebase --continue
```

Открывается редактор с таким содержимым

```bash
git-rebase 2

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# interactive rebase in progress; onto 25057e3
# Last commands done (2 commands done):
#    pick f9730ce git-rebase 1
#    pick 36e07f5 git-rebase 2
# No commands remaining.
# You are currently rebasing branch 'git-rebase' on '25057e3'.
#
# Changes to be committed:
#       modified:   branching/rebase.sh
#
```

Оставляем текущий комментарий

В результате rebase выполнился успешно

```bash
[detached HEAD a3a2d0f] git-rebase 2
 1 file changed, 1 insertion(+), 1 deletion(-)
Successfully rebased and updated refs/heads/git-rebase.
```
```
$ git log --oneline --graph
```
```bash
* a3a2d0f (HEAD -> git-rebase) git-rebase 2
*   25057e3 (origin/main, origin/HEAD, main) Merge branch 'git-merge' into main
|\
| * 226d9b7 (origin/git-merge, git-merge) merge: use shift
| * 91adb68 merge: @ instead *
* | b9ace55 rebase: @ instead *
|/
* df19261 prepare for merge and rebase
* 1ddeb60 (tag: v0.1, tag: v0.0, gitlab/main, bitbucket/main) Moved and deleted
* f7f8d4f Prepare to delete and move
* aeb8a88 Added gitignore
* 49a224f First commit
* c9a837e Initial commit
```

```
$ git push -u origin git-rebase
```
```bash
To github.com:kamaok/devops-netology.git
 ! [rejected]        git-rebase -> git-rebase (non-fast-forward)
error: failed to push some refs to 'git@github.com:kamaok/devops-netology.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

```
$ git push -u origin git-rebase -f
```
```bash
Counting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 389 bytes | 389.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:kamaok/devops-netology.git
 + 36e07f5...a3a2d0f git-rebase -> git-rebase (forced update)
Branch 'git-rebase' set up to track remote branch 'git-rebase' from 'origin'.
```
```
$ git checkout main
```
```bash
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
```
```
$ git branch
```
```bash
  fix
  git-merge
  git-rebase
* main
```

```
$ git merge git-rebase
```
```bash
Updating 25057e3..a3a2d0f
Fast-forward
 branching/rebase.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```
```
$ git log --oneline --graph
```
```bash
* a3a2d0f (HEAD -> main, origin/git-rebase, git-rebase) git-rebase 2
*   25057e3 (origin/main, origin/HEAD) Merge branch 'git-merge' into main
|\
| * 226d9b7 (origin/git-merge, git-merge) merge: use shift
| * 91adb68 merge: @ instead *
* | b9ace55 rebase: @ instead *
|/
* df19261 prepare for merge and rebase
* 1ddeb60 (tag: v0.1, tag: v0.0, gitlab/main, bitbucket/main) Moved and deleted
* f7f8d4f Prepare to delete and move
* aeb8a88 Added gitignore
* 49a224f First commit
* c9a837e Initial commit
```

```
$ git push
```
```bash
Total 0 (delta 0), reused 0 (delta 0)
To github.com:kamaok/devops-netology.git
   25057e3..a3a2d0f  main -> main
```


[Merge `git-rebase` in `main` - Check network in Github](https://github.com/kamaok/devops-netology/network)
