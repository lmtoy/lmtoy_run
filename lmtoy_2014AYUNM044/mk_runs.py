#! /usr/bin/env python
#
#   script generator for project=2014AYUNM044
#


import os
import sys

# in prep of the new lmtoy module
try:
    lmtoy = os.environ['LMTOY']
    sys.path.append(lmtoy + '/lmtoy')
    import runs
except:
    print("No LMTOY with runs.py")
    sys.exit(0)

project="2014AYUNM044"

#        obsnums per source (make it negative if not added to the final combination)
on = {}
on['J004056.01'] = [44710, 44711, 44712, 44714, 44715, 44716, 44718, 44719, 44720, 45740,
                    45741, 45742, 45744, 45745, 45746, 45748, 45749, 45750, 45753, 45754,
                    45755]

#        common parameters per source on the first dryrun (run1a, run2a)
pars1 = {}
pars1['J004056.01'] = ""

#        common parameters per source on subsequent runs (run1b, run2b)
pars2 = {}
pars2['J004056.01'] = ""

runs.mk_runs(project, on, pars1, pars2)
