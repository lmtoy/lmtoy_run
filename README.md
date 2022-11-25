Manage LMT project run files. Note that there is no good template yet,
some script generators (see Makefile) are still in an older version.

# Running

A number of steps before you can run

1. maintain a **lmtinfo.txt** if new obsnums were added

    lmtinfo.py grep PID > lmtinfo.txt

2. add new obsnums to **mk_runs.py** and default args

    * on[]
    * pars1[]  - per source if there are > 1 
    * pars2[]

   If you see mk_runs instead of mk_runs.py, ignore it, it should
   have been deleted as they've been deprecated.

3. add any deviations from the default args to **obsnum.args**

4. run ./mk_runs.py - this will have created a run1a, run1b file
   to run all individual obsnums, as well as run2a, run2b file
   to run all combinations (e.g. if there are more than one source
   and/or multiple frequency setups, e.g. CO and HCN for M51)

5. Now you can execute the run files, in this order. Depending on what
   machine you are, the execution command that acts on these files is
   different

       PID.run1a
       PID.run1b
       PID.run2a
       PID.run2b

   Note each of these four need too wait for each other to finish!

   On unity the command would be

       sbatch_lmtoy.sh PID.run1a
       ...

   On a machine with gnu parallel (even multicore laptops can benefit from this)

       parallel --jobs 8 < PID.run1a
       ...

   On a machines with single core, bash will do

       bash PID.run1a
       ...

