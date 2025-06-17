# The LMT Script Generator

The script generator is the infrastructure to help run the
SLpipeline. We maintain this in github, so that DA's, pipeline
developers, and even the PI, can communicate and agree on the best
possible pipeline run.  All useful PI information about the project
should be maintained in this script generator directory.  The typical
name for the repo will be **lmtoy_$PID**, where **$PID** is the
project ID, e.g. **lmtoy_2021-S1-US-3**, which can be retrieved from
github with

      $ git clone https://github.com/lmtoy/lmtoy_2021-S1-US-3

or

      $ git clone git@github.com:/lmtoy/lmtoy_2021-S1-US-3


## URLs


    http://taps.lmtgtm.org/lmtslr/lmtoy_run/        - LMTOY pipeline index list to all projects
    http://taps.lmtgtm.org/lmtslr/2021-S1-US-3/     - Example of a project
    http://taps.lmtgtm.org/lmtslr/2021-S1-US-3/TAP  - Example of the lightweight TAPs of a project
    https://www.astro.umd.edu/~teuben/work_lmt/     - peter's non-official experiments



## Directories and Files 

Important directories to remember in the LMTOY environment:

    $LMTOY                                root directory of all LMTOY software components
    $DATA_LMT                             root directory of LMT (read-only) raw data
    $WORK_LMT                             root directory of your LMT pipeline results
    $WORK_LMT/$PID                        pipeline results for this PID
    $WORK_LMT/lmtoy_run/lmtoy_$PID        script generator for this PID (note location!)
    $WORK_LMT/lmtoy_run/lmtoy_$PID/$PID   [optional] convenient symlink to $PID
    $WORK_LMT/$PID/lmtoy_$PID		  [optional] convenient symlink to lmtoy_$PID

A script generator directory has the following files:

    README.md              verbiage info for the PI
    Makefile               helper file for your workflow
    PID                    small text file what the PID is, the Makefile needs it
    $PID                   [optional] convenient symlink to the $WORK_LMT/$PID pipeline results
    mk_runs.py             [required] produces the run files
    comments.txt           [required] comments and directives for individual obsnums
    lmtinfo.txt            output from lmtinfo.py for this PID
    LMT_$PID_phase2.xlsx   phase-2 info

## LMT run files 

An LMT run file is a text file, consisting of the pipeline commands to
process a series of obsnums. They are typically created by a script
generator (mk_runs.py), and typically each *ProjectId* has a number of these runfiles,
to be executed in order.

1.  *.run1a - runs the first instance of the pipeline on individual obsnums, with minimal flagging
2.  *.run1b - runs subsequent instances, applying flags, and also allows arguments from comments.txt etc.
2.  *.run1c - runs subsequent instances, applying flags, and also allows arguments from comments.txt etc. [optional]
3.  *.run2a - runs the first instance of the pipeline on all obsnum combinations, one for each source/spectral line
4.  *.run2b - runs subsequent instances of combinations, applying flags etc.
4.  *.run2c - runs subsequent instances of combinations, applying flags etc. [optional]

A runfile can be processed (executed) via **SLURM**, GNU **parallel** or **bash**,
whichever your system supports or demands. On *Unity* we obviously will need to
use SLURM, on *lma@umd* and *malt* the obvious choice is GNU parallel,
and even on a multi-core laptop this might make sense. The slowest
approach of course is *bash*, as a pure serial script, but here you are
spending the least amount of CPU. Examples of use:


    sbatch_lmtoy.sh  test1.run [args]    # SLURM on Unity (optional SLpipeline args allowed here)
    parallel  -j 4 < test1.run           # GNU parallel, using max of 4 cores
    bash             test1.run           # classic serial shell processing

## Make a new script generator

Using the github CLI (the **gh** command) is probably the easiest to
explain in commands how to bootstrap the script generator. We do this
fromf the **lmtoy_run** directory, since it's simpler (and now
required) to maintain all script generators below there. We keep a
record of all projects in the Makefile in lmtoy_run. First you need to
grab lmtoy_run if that was not done yet:

     $ cd $WORK_LMT
     $ git clone https://github.com/lmtoy/lmtoy_run
     $ cd lmtoy_run

and optionally, but strongly recommended, add your personal
gitconfig file if you work from the shared lmthelpdesk_umass_edu account

     $ cat $WORK_LMT/gitconfig >> .git/config

Normally this is you personal $HOME/.gitconfig file.

The **mk_project.sh** script will create a template, viz.

     $ PID=2023-S1-MX-47
     $ ./mk_project.sh $PID

Again, note the optional cat command to deal with the shared gitconfig issue.

## Preparing to run an existing script generator

First make sure all repos for your YEAR's are refreshed:

      $ cd $WORK_LMT/lmtoy_run
      $ make git pull
      $ cd lmtoy_2021-S1-US-3

On any machine with an updated $DATA_LMT, the **source_obsnum.sh** script can generate the **mk_runs.py** file
for the first time the project was done:

      $ source_obsnum.sh 2021-S1-US-3 > test1.py
      $ diff test1.py mk_runs.py

it will be a manual process to align these two files (for now).

## Running an existing script generator

The following are the suggested steps to maintain your script generator, particular when new obsnums were added:

1. maintain the **lmtinfo.txt** where we keep all the obsnums used in this project

     $ lmtinfo.py grep PID > lmtinfo.txt

2. add new obsnums to **mk_runs.py** and figure out a good default argument list

        on[]     - per source
        pars1[]  - per source
        pars2[]  - per source

   again, the **source_obsnum.sh** script can help you maintain these list.

   An example how they can look:

        on['Arp91']      = [97559, 97560]
        pars1['Arp91']   = "dv=250 dw=400 extent=240 edge=1"
        pars2['Arp91']   = "pix_list=-0,5"


3. add any deviations from the default args can go as a comment in
   **comments.txt**, the human readable comments itself (for the
   obsnum summary web pages) go first, followed by the comment (#)
   symbol, followed by special SLpipeline.sh arguments, e.g.

        99081  0,5 are bad       # pix_list=1,2,3,6,7,8,9,10,1112,13,14,15
        99082  0,5 are bad       # pix_list=-0,5

4. run ./mk_runs.py - this will have created a *run1a* and *run1b* file
   to process all individual obsnums, as well as *run2a* and *run2b* file
   to run all combinations (e.g. if there are more than one source
   and/or multiple frequency setups, e.g. CO and HCN for M51).

   We use two runfiles in order to always show the first pipeline run
   (restart=1) as well as any improvements.

   For the new 2 IF wares systems (april 2023 and beyond) there will be 3
   runfiles per obsnum.

5. Now you can execute the run files, in the correct order. Depending on what
   machine you are, the execution command that acts on these files is
   different. Lets say the four files are

       $PID.run1a
       $PID.run1b
       $PID.run2a
       $PID.run2b

   Note each of these need too wait for the previous one to finish!
   

   On unity the command would be

       $ sbatch_lmtoy.sh $PID.run1a
       ...

   but this is an example where you need to wait for each to complete. 


   On a machine with gnu parallel (even multicore laptops can benefit from this)

       $ parallel --jobs 4 < $PID.run1a
       ...

   On a machines with single core, bash will do just fine, in fact, here
   you can submit all four since they operate serially

       $ bash $PID.run1a
       ...

   The latter two can be given at the same time, whereas currently the SLURM method
   will need to be manually monitored to ensure all pipelines finished, before the
   next runfile can be given.

   After all this, the summary for this project needs to be updated:

       $ make summary

6. After a project was updated, the LMTOY pipeline index should also be updated

       $ (cd $WORK_LMT/lmtoy_run; make index)
       $ xdg-open http://taps.lmtgtm.org/lmtslr/lmtoy_run/

### Wrap-up

Once the data have been processed, a web summary in README.html is created:

     cd $WORK_LMT/$PID
     mk_summary1.sh > README.html

there should be a symlink from the index.html to this file, if not, do this:

     ln -s README.html index.html

as well as a symlink to the comments.txt file, again depending on where you
placed the lmtoy_$pid directory:

     ln -s $WORK_LMT/lmt_run/lmtoy_$PID/comments.txt
     ln -s ../comments.txt

### Unity cheat list

For a given ProjectId, say 2021-S1-MX-3, this is the procedure:

      # set the ProjectId
      PID=2021-S1-MX-3

      # go to the ProjectId directory
      $ cd $WORK_LMT/$PID

      # make sure you have symlinks here (only needed once)
      ln -s $WORK_LMT/lmt_run/lmtoy_$PID
      ln -s lmtoy_$PID/comments.txt
      ln -s README.html index.html


      # ensure the script generator is up to date
      cd $WORK_LMT/lmtoy_run/lmtoy_$PID
      git pull
      make runs

      # submit to SLURM, each time wait until that runfile has been processed
      sbatch_lmtoy.sh $PID.run1a
      squeue -u lmtslr_umass_edu
      ...<wait>
      
      sbatch_lmtoy.sh $PID.run1b
      squeue -u lmtslr_umass_edu
      ...<wait>
      
      sbatch_lmtoy.sh $PID.run2a
      squeue -u lmtslr_umass_edu
      ...<wait>

      sbatch_lmtoy.sh $PID.run2b
      squeue -u lmtslr_umass_edu

after the runs are all done, and assuming comments.txt was symlinked, you can do

      # make summary

SLURM logfiles and runfiles are in:   **$WORK_LMT/sbatch** - occasionally this directory
should be cleaned of old files, e.g. to remove files older than 1 months:

      $ find $WORK_LMT/sbatch -type f -mtime +30 -delete 

A tip for a project with many sources: the sourcename is tagged in the run file via
the **_s=** keyword, so for each of the (four) runfiles you can grep out that source name
and run the pipeline for just that source. Here's an example:

       $ grep Arp143 2021-S1-MX-3.run1a > test1
       $ sbatch_lmtoy.sh test1

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

   or if you want to see the overnight TAP's (usually available a few minutes after an obsnum has finished)

       https://taps.lmtgtm.org/lmtslr/$PID/TAP

3. download: the ${OBSNUM}_SRDP.tar file linked in the $WORK_LMT/$PID/$OBSNUM/README.html
   file contains all data for perhaps easier viewing on your own laptop.
   The pipeline cannot run on this data though since it does contain the raw data.
   Notice the TAP's do not come with a link to the SRDP tar file.

## github

The script generator is currently maintained under github. We have not discussed how to
maintain them between DA's and PI. The two competing models are the "trusted collaborator"
model, as the "pull request from a collaborator branch". See CONTRIBUTING.md for some
suggestions and git flow references.

### Here are the recommended steps for DA as a "trusted collaborator?":

1. Get a fresh copy of lmtoy_PID script generator, normally via lmtoy_run, and pull it to
   be up to par. We use the **2024-S1-MX-2** project as example, with **peter** as the
   DA that is testing the pipeline with some new flags, comments, obsnums etc.

         PID=2024-S1-MX-2
         cd $WORK_LMT/lmtoy_run/$PID
	 git pull
	 git checkout peter
         git merge origin/peter

2. This last command is to ensure that **peter** has all the latest updates from the **main** branch.
   Now edit the various files at your leisure:

         edit comments.txt
	 edit mk_runs.py

3. and prepare runfiles for the pipeline

         make runs
	 sbatch_lmtoy.sh *run1a
	 <wait for finish>
	 make summary

4. If happy, commit them for later main branch merge:

         git comment -m "my changes bla bla"  comments.txt mk_runs.py

Note those who want to directly submit into the scripts, need to be on https://github.com/orgs/lmtoy/people


### Master Pipeliner





# Workflow Summary

Summary of steps to get the data end-to-end  (this is the current workflow, drafted as such,
and will likely change):

1. lmtc: the data are magically taken, and rsync'd to malt. This is where the pipeline
   work starts. Of course a lot of work precedes this step:  phase-1, phase-2, observing
   scripts, etc.

2. malt: Run **SLpipeline_run.sh** on malt. This will watch for new data to appear,
   runs the pipeline and make TAP files, and copies these to Unity. If somebody is awake on
   malt, a webbrowser can be run locally for viewing, and some combination work is sometimes
   tested already. The TAP data can also be viewed on unity.

3. any: Collect the (new) PID/OBSNUM, and make a script generator, or update its OBSNUM's. - if
   this is a new PID, the PI should be emailed data is coming, and give them the unity URL

4. <not needed>

5. unity: wait for raw data to arrive, ideally run **lmtinfo.py build** to get a new database.

6. unity: either DA or PT:  via the script generator run the pipeline, for PI to view. Ideally
   the DA will run it first, potentially flag data the pipeline didnt see.

7. unity: ingest in dataverse [not implemented yet]
   

Timeline:

     1-4: ~T+1 hour
     5:   ~T+1 day
     6:   ~T+1 week
     7:   ?
