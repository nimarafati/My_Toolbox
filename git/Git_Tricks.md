# How to deal with large files already deleted?  
If you see errors like this:
```
> git push --set-upstream origin plp_design_package
....
remote: Resolving deltas: 100% (24/24), completed with 3 local objects.
remote: error: Trace: .......123231laksjdksjlasd
remote: error: See https://gh.io/lfs for more information.
remote: error: File codes/Mus.fa is 315.77 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: File codes/Mus_musculus.GRCm39.dna.chromosome.1.fa is 189.22 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: File codes/Mus_musculus.GRCm39.dna.chromosome.10.fa is 126.56 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
To https://github.com/account/repo.git
 ! [remote rejected] branch -> branch (pre-receive hook declined)
error: failed to push some refs to 'https://github.com/account/repo.git'
```


## Step 1: Install BFG Repo Cleaner
```
wget https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar
```

## Step 2: Remove Large Files

Remove all large files (`.fa`) files from history:  
```
cd ~/repo/
java -jar bfg-1.14.0.jar --delete-files "*.fa"
```
## Step 3: Clean Up Git
After running BFG, clean up the repository:

```
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```


## Step 4: Force Push the Cleaned Repo
Finally, force push your changes to rewrite history:
```
 git push --set-upstream origin branch
```

**Note:** In this case I am pushing to a new branch which exists locally but not remotely.  

# Git Cheatsheet
## Beginner
| Command | Function / Outcome |
|--------|---------------------|
| `git init` | Create a new local Git repository in the current folder. |
| `git clone <url>` | Download a remote repository to your local machine. |
| `git status` | Show what has changed, what is staged, and what is untracked. |
| `git add <file>` | Stage a specific file for the next commit. |
| `git add .` | Stage all modified and new files. |
| `git commit -m "message"` | Save staged changes as a new commit in the local repo. |
| `git log` | Show the commit history. |
| `git diff` | Show the changes in files (working directory vs last commit). |
| `git branch` | List local branches. |
| `git branch <name>` | Create a new branch. |
| `git switch <branch>` | Switch to another branch. |
| `git switch -c <branch>` | Create and switch to a new branch. |
| `git merge <branch>` | Merge another branch into the current branch (creates a merge commit if needed). |
| `git pull` | Fetch from remote and integrate changes (merge or rebase, depending on config). |
| `git push` | Upload your local commits to the remote repository. |
| `git remote -v` | Show the remote repositories linked to this repo. |
| `git restore <file>` | Restore a file to the last committed version. |
| `git restore --staged <file>` | Unstage a file but keep its changes. |
| `git reset <file>` | Older way to unstage; similar to `git restore --staged`. |
| `git rm <file>` | Remove a file and stage its deletion. |
| `git stash` | Temporarily save uncommitted changes and clean the working directory. |
| `git stash pop` | Re-apply the stashed changes and drop them from the stash. |

## Rebase & pull behaviour
| Command | Function / Outcome (Beginner-speak) |
|--------|--------------------------------------|
| `git rebase <branch>` | Replay your current branch’s commits on top of `<branch>` (rewrites history; keeps it linear). |
| `git pull --rebase` | Fetch remote changes and then reapply your local commits on top (no merge commit; history is rewritten). |
| `git pull --no-rebase` | Fetch remote changes and merge them into your branch (creates a merge commit if needed; no history rewrite). |
| `git pull --ff-only` | Only update your branch if it can be fast-forwarded (no merge commit, no rebase); fails if histories have diverged. |


## Configuring default pull strategy
| Command | What it configures / When to use |
|--------|-----------------------------------|
| `git config pull.rebase false` | Make `git pull` use **merge** by default in this repo. Preserves your existing commits (no history rewrite). |
| `git config pull.rebase true` | Make `git pull` use **rebase** by default (linear history, but your local commits get new hashes). |
| `git config pull.ff only` | Make `git pull` only do **fast-forward** updates (no merge commits; fails if local & remote have diverged). |
| `git config --global pull.rebase false` | Same as above, but applies to **all repositories** for your user. |
| `git config --global user.name "<name>"` | Set your global Git username (for commit metadata). |
| `git config --global user.email "<email>"` | Set your global Git email (for commit metadata). |


