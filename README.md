
# The LMT Script Generator

The script generator is the infrastructure to help run the LMT SL pipeline. We maintain this in github, so that
DA's, PI, and pipeline developers can communicate and agree on a good pipeline run.
All useful PI information about the project should be
maintained in this script generator directory.
The typical name for the repo will be **lmtoy_PID**, where **PID** is the
project ID, e.g. **lmtoy_2021-S1-US-3**, currently they reside in the teuben account on github, e.g.

      $ git clone https://github.com/teuben/lmtoy_2021-S1-US-3

# LMT run files 

An LMT run file is a text file, consisting of the pipeline commands to process
a series of obsnums. They are typically created by a script generator, and
typically each *ProjectId* has 4 of these runfiles

1.  *.run1a - runs the first instance of the pipeline on individual obsnums, with minimal flagging
2.  *.run1b - runs subsequent instances, applying flags, and also allows arguments from comments.txt etc.
3.  *.run2a - runs the first instance of the pipeline on all obsnum combinations, one for each source/spectral line
4.  *.run2b - runs subsequent instances of combinations, applying flags etc.

A runfile can be processed (executed) via SLURM, GNU parallel or bash, whichever your system supports. On *Unity*
we obviously will need to use SLURM, on *lma@umd* and *malt* the obvious choice is GNU parallel, and even on a multi-core laptop
this might make sense. The slowest approach of course is *bash*, as a pure serial script.

## Preparing

Ideally we have a script that sets up the script generator for a new project, but currently the bootstrap
is a manual process.  For the remainder of this document we assume you have the script generator:

      $ git clone https://github.com/teuben/lmtoy_2021-S1-US-3
      $ cd lmtoy_2021-S1-US-3

## Running

The following are the suggested steps to maintain your script generator, particular when new obsnums were added:

1. maintain the **lmtinfo.txt** where we keep all the obsnums used in this project

    $ lmtinfo.py grep PID > lmtinfo.txt

2. add new obsnums to **mk_runs.py** and figure out a good default argument list

    * on[]     - per source
    * pars1[]  - per source
    * pars2[]  - per source

3. add any deviations from the default args can go as a comment in
   **comments.txt**, the human readable comments itself (for the
   obsnum summary web pages) go first, followed by the comment (#)
   symbol, followed by special SLpipeline.sh arguments, e.g.

       99081  partial map     # pix_list=1,2,3,6,7,8,12,13,14,15

4. run ./mk_runs.py - this will have created a *run1a* and *run1b* file
   to process all individual obsnums, as well as *run2a* and *run2b* file
   to run all combinations (e.g. if there are more than one source
   and/or multiple frequency setups, e.g. CO and HCN for M51).

   We use two runfiles in order to always show the first pipeline run
   (restart=1) as well as any improvements. 

5. Now you can execute the run files, in the correct order. Depending on what
   machine you are, the execution command that acts on these files is
   different. Lets say the four files are

       PID.run1a
       PID.run1b
       PID.run2a
       PID.run2b

   Note each of these need too wait for the previous one to finish!

   On unity the command would be

       $ sbatch_lmtoy.sh PID.run1a
       ...

   but this is an example where you need to wait for each to complete. 


   On a machine with gnu parallel (even multicore laptops can benefit from this)

       $ parallel --jobs 4 < PID.run1a
       ...

   On a machines with single core, bash will do just fine, in fact, here
   you can submit all four since they operate serially

       $ bash PID.run1a
       ...

   The latter two can be given at the same time, whereas currently the SLURM method
   will need to be manually monitored to ensure all pipelines finished, before the
   next runfile can be given.

### Wrap-up

Once the data have been processed, a web summary in README.html is created:

     cd $WORK_LMT/PID
     mk_summary1.sh > README.html

there should be a symlink from the index.html to this file, if not, do this:

     ln -s README.html index.html

as well as a symlink to the comments.txt file, again depending on where you
played the lmtoy_$pid directory:

     ln -s $WORK_LMT/lmt_run/lmtoy_$pid/comments.txt
     ln -s ../comments.txt

### Unity cheat list

For a given ProjectId, say 2021-S1-MX-3, this is the procedure:

      # ensure all the script generators are up to date
      cd $WORK_LMT      
      git clone https://github.com/teuben/lmtoy_run
      cd lmtoy_run
      make git

      # set the ProjectId
      $ pid=2021-S1-MX-3
      
      $ cd $WORK_LMT/$pid

      # make sure you have symlinks here (only needed once)
      ln -s $WORK_LMT/lmt_run/lmtoy_$pid
      ln -s lmtoy_$pid/comments.txt
      ln -s README.html index.html

      $ cd lmtoy_$pid

      # update if need be, and make updated run files
      $ git pull
      $ ./mk_runs.py
      
      # submit to SLURM, each time wait until that runfile has been processed
      $ sbatch_lmtoy.sh $pid.run1a
      $ squeue -u lmtslr_umass_edu
      ...<wait>
      
      $ sbatch_lmtoy.sh $pid.run1b
      $ squeue -u lmtslr_umass_edu
      ...<wait>
      
      $ sbatch_lmtoy.sh $pid.run2a
      $ squeue -u lmtslr_umass_edu
      ...<wait>

      $ sbatch_lmtoy.sh $pid.run2b
      $ squeue -u lmtslr_umass_edu

after the runs are all done, and assuming comments.txt was symlinked, you can do

      # make summary

SLURM logfiles and runfiles are in:   **$WORK_LMT/sbatch** - occasionally this directory
should be cleaned of old files, e.g. to remove files older than 3 months:

      $ find $WORK_LMT/sbatch -type f -mtime +90 -delete 

A tip for a project with many sources: the sourcename is tagged in the run file via
the **_s=** keyword, so for each of the (four) runfiles you can grep out that source name
and run the pipeline for just that source. Here's an example:

       $ grep Arp143 2021-S1-MX-3.run1a > test.run1a
       $ sbatch_lmtoy.sh test.run1a

etc.

## Viewing results

Various ways to view the results:

1. terminal: the directory $WORK_LMT/$PID/$OBSNUM contains all processed data. Use any
   file browser, e.g.

       $ xdg-open $WORK_LMT/$PID/$OBSNUM

2. web: On Unity results are password protected and visible via this URL:

       https://taps.lmtgtm.org/lmtslr/$PID
       
   or if you are a helpdesk $USER
   
       https://taps.lmtgtm.org/lmthelpdesk/$USER/$PID

2. download: the ${OBSNUM}_SRDP.tar file linked in the $WORK_LMT/$PID/$OBSNUM/README.html
   file contains all data for perhaps easier viewing on your own laptop The pipeline cannot
   run on this data though.

## github

The script generator is currently maintained under github. We have not discussed how to
maintain them between DA's and PI. The two competing models are the "trusted collaborator"
model, as the "pull request from a collaborator branch". A somewhat long explanation is in
https://github.com/teuben/nemo/blob/master/CONTRIBUTING.md, though we should make our own
here.


# Workflow

Summary of steps to get the data end-to-end  (this is the current workflow, drafted as such,
and will likely change):

1. lmtc: the data are magically taken, and rsync'd to malt. This is where the pipeline
   work starts. Of course a lot of work precedes this step:  phase-1, phase-2, observing
   scripts, etc.

2. malt: Run **SLpipeline_run.sh** on malt. This will watch for new data to appear,
   run pipeline and make TAP files, and copies these to Unity. If somebody is awake on
   malt, a webbrowser can be run locally for viewing, and some combination work is sometimes
   tested already.

3. any: Collect the (new) PID/OBSNUM, and make a script generator, or update its OBSNUM's. - if
   this is a new PID, the PI should be emailed data is coming, and give them the unity URL

4. unity: Run **../do_untap *.tar** in each $WORK_LMT/PID, this will make them available to PI

5. unity: wait for raw data to arrive, ideally run **lmtinfo.py build** to get a new database.

6. unity: either DA or PT:  via the script generator run the pipeline, for PI to view. Ideally
   the DA will run it first, potentially flag data the pipeline didnt see.

7. unity: ingest in dataverse [not implemented yet]
   

Timeline:

     1-4: ~T+1 hour
     5:   ~T+1 day
     6:   ~T+1 week
     7:   ?

