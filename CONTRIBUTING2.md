# A crazy alternative path to reducing LMT data by the PI

## Executive Summary

Here the PI forks the script generator in their own github account,
and creates a branch with modified directives, so the DA can run the
pipeline.  Data from this run overwrite the current data of the
official pipeline.

## Introduction


Reducing LMT data is controlled by something we call the script
generator. This is a (public) github repo with directives that the
pipeline needs to run. An example of this for 2021-S1-US-3 can be
found in the following repo:

      https://github.com/lmtoy/lmtoy_2021-S1-US-3

the essential two files that control how the pipeline is run are

1. mk_runs.py     - generic recipes for each source
2. comments.txt   - exceptions to the generics

This example is a Sequoia project, and for an RSR project some things
inside of these files will look a little different, but one thing they
all have in commmon is:

1. a project consists of a series of OBSNUM's (per source)
   that are eventually combined

2. a combination looks like an obsnum with the first and last obsnum in a
   series, with the underscore in the middle. You can see some examples listed
   in the comments.txt of that US-3 project. For example 97520_99703 is the
   final combo for M100.

## Sequoia rules

TBD  (this is where we talk about the PI parameters)

## RSR rules

TBD  (this is where we talk about the PI parameters)


## Github

### The workflow for the PI would be:  (the PI is assumed to know a bit of git)

(specific commands can be given here)

1. Fork the script generator to your own workspace on github.com
2. Clone the script generator from github to your laptop
3. Change to a branch in the laptop copy - this way you can keep different experiments separate
4. In this branch, edit the `mk_runs.py` and `comments.txt` files. Maybe README if you want track of things
5. Commit and Push these changes to github (in this branch)
6. Contact the DA and give them your URL and branchname to try.

We have avoided using the official "Pull Request" (PR) schema here. If we could, that would make the DA's workflow a bit
easier. But not all PI's are as familar with this PR scheme, but they should be familiar with working in a branch.

### The workflow for the DA would be:

The following variables are used below:

- $PID : the project, e.g. "2021-S1-US-3"
- $PI : the github handle of the PI, i.e. "teuben"
- $B : the branch name for the experiment, e.g. "bogus"

with the following steps

1. Change directory      :  `cd $WORK_LMT/lmtoy_run/lmtoy_$PID`
2. Set the remote        :  `git remote add ${PI} https://github.com/$PI/lmtoy_$PID`
3. Set the local branch  :  `git checkout -b ${PI}_${B}`
4. Fetch the branch      :  `git fetch ${PI} ${B}`
5. Merge the branch      :  `git merge ${PI}/${B}`
6. Run script generator  :  `make runs`
7. Submit to queue       :  `sbatch_lmtoy2.sh ....`

Notice this will overwrite all files with the new experiments. There is a way to keep the old
ones and make these appear somewhere else (the webpage pipeline runner does that), but I didn't
write down these steps here.

If somehow this branch should become the final one in the official repo, then

1. `git checkout main`       ( or master, whichever it is called these days)
2. `git merge ${PI}_${B}`
3. `git push`

