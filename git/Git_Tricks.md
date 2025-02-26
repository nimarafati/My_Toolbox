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

