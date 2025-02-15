#! /usr/bin/env python
#

import os
import sys

from lmtoy import runs

project="2024-S1-US-17"

#        obsnums per source (make it negative if not added to the final combination)
on = {}

on["20007227"] = [ 127422, 127423, 127424, 127426, 127427, 127428, 
                   127519, 127520, 127521, 127523, 127524, 127525,]


on["20010800"] = [ 127341, 127342, 127343, 127345, 127346, 127347, 127349,
                   127350, 127351, 127354, 127355, 127356,                     # 13-feb
                   127407, 127408, 127409, 127411, 127412, 127413, 127415, 127416, 127417,]


#        common parameters per source on the first dryrun (run1a, run2a)
pars1 = {}
pars1["20007227"] = ""
pars1["20010800"] = ""

#        common parameters per source on subsequent runs (run1b, run2b), e.g. bank=0 for WARES
pars2 = {}
pars2["20007227"] = ""
pars2["20010800"] = ""

#        common parameters per source on subsequent runs (run1c, run2c), e.g. bank=1 for WARES
pars3 = {}


if __name__ == '__main__':    
    runs.mk_runs(project, on, pars1, pars2, None, sys.argv)
