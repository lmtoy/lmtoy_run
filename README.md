
# The LMT Script Generator

The script generator is the infrastructure to help run the LMT SL pipeline. We maintain this in github, so that
DA's, PI, and pipeline developers can communicate. All useful PI information about the project should be
maintained in this script generator.   The typical name will be **lmtoy_PID**, where **PID** is the
project ID, e.g. **lmtoy_2021-S1-US-3**


# LMT run files 

An LMT run file is a text file, consisting of the pipeline commands to process
a series of obsnums. They are typically created by a script generator, and
typically each *ProjectId* has 4 of these runfiles

1.  *.run1a - runs the first instance of the pipeline on individual obsnums, with minimal flagging
2.  *.run1b - runs subsequent instances, applying flags etc.
3.  *.run2a - runs the first instance of the pipeline on obsnum combinations, one for each source/spectral line
4.  *.run2b - runs subsequent instances of combinations, applying flags etc.

A runfile can be processed (executed) via SLURM, GNU parallel or bash, whichever your system supports. On *Unity*
we obviously will need to use SLURM, on *lma@umd* the obvious choice if GNU parallel, and even on a multi-core laptop
this might make sense. The slowest approach of course is *bash*, a pure serial 

## Preparing

more to come here, ideally we have a script that sets up the script generator for a new project.  This will also be
handy in case the script generator itself needs new features.

## Running

The following are the suggested steps to maintain your script generator.

1. maintain the **lmtinfo.txt** if new obsnums were added, e.g.

    lmtinfo.py grep PID > lmtinfo.txt

2. add new obsnums to **mk_runs.py** and figure out a good default argument list

    * on[]
    * pars1[]  - per source if there are > 1 
    * pars2[]

   If you see **mk_runs** instead of **mk_runs.py**, ignore it, it should
   have been deleted as they've been deprecated.

3. add any deviations from the default args can go as a comment in
   **comments.txt**, the human readable comments itself (for the
   obsnum summary web pages) go first, followed by the comment (#)
   symbol, followed by special arguments, e.g.

       99081  partial map     # pix_list=1,2,3,6,7,8,12,13,14,15

4. run ./mk_runs.py - this will have created a run1a and run1b file
   to process all individual obsnums, as well as run2a and run2b file
   to run all combinations (e.g. if there are more than one source
   and/or multiple frequency setups, e.g. CO and HCN for M51).

   We use two runfile in order to always show the first pipeline run
   (restart=1) as well as any improvements.

5. Now you can execute the run files, in the correct order. Depending on what
   machine you are, the execution command that acts on these files is
   different. The four files are

       PID.run1a
       PID.run1b
       PID.run2a
       PID.run2b

   Note each of these need too wait for the previous one to finish!

   On unity the command would be

       sbatch_lmtoy.sh PID.run1a
       ...

   On a machine with gnu parallel (even multicore laptops can benefit from this)

       parallel --jobs 4 < PID.run1a
       ...

   On a machines with single core, bash will do just fine, in fact, here
   you can submit all four since they operate serially

       bash PID.run1a
       ...

### Wrap-up

Once the data have been processed, a web summary in README.html is created:

     cd $WORK_LMT/PID
     mk_summary1.sh > README.html

there should be a symlink from the index.html to this file, if not

     ln -s README.html index.html

as well as a symlink to the comments.txt file, again depending on where you
played the lmtoy_$pid directory:

     ln -s $WORK_LMT/lmt_run/lmtoy_$pid/comments.txt
     ln -s ../comments.txt

### Unity cheat list

For a given ProjectId, say 2021-S1-MX-3, this is the procedure:

      # set the ProjectId
      pid=2021-S1-MX-3

      # pick one of these directories, whichever you implemented
      cd $WORK_LMT/lmt_run/lmtoy_$pid
      cd $WORK_LMT/$pid/lmtoy_$pid

      # update if need be, and make updated run files
      git pull
      ./mk_runs.py
      
      # submit to SLURM, each time wait until that runfile has been processed
      sbatch_lmtoy.sh $pid.run1a
      squeue -u lmtslr_umass_edu
      
      sbatch_lmtoy.sh $pid.run1b
      squeue -u lmtslr_umass_edu

      sbatch_lmtoy.sh $pid.run2a
      squeue -u lmtslr_umass_edu

      sbatch_lmtoy.sh $pid.run2b
      squeue -u lmtslr_umass_edu

SLURM logfiles and runfiles are in:   $WORK_LMT/sbatch - occasionally this directory
should be cleaned of old files, e.g. to remove files older than 3 months:

      find $WORK_LMT/sbatch -type f -mtime +90 -delete 

A tip for a project with many sources: the sourcename is tagged in the run file via
the _s= keyword, so for each of the (four) runfiles you can grep out that source name
and run the pipeline for just that source. Here's an example:

       grep Arp143 2021-S1-MX-3.run1a > test.run1a
       sbatch_lmtoy.sh test.run1a

etc.

Another tip for stacking is the bootstrap approach, by combining different sets of obsnums,
even though the S/N will be a bit worse.

## Viewing results

Various ways to view the results:

1. terminal: the directory $WORK_LMT/$PID/$OBSNUM contains all processed data. Use any
   file browser.

2. web: On unity results are password protected on
   https://taps.lmtgtm.org/lmtslr/$PID

2. download: the ${OBSNUM}_SRDP.tar file linked in the $WORK_LMT/$PID/$OBSNUM/README.html
   file contains all data for perhaps easier viewing on your own laptop.
