#! /usr/bin/env python
#

import os
import sys

from lmtoy import runs

project="2024-S1-US-17"

#        obsnums per source (make it negative if not added to the final combination)
on = {}

on["169742"] =   [ 127719, 127720, 127721, 127723, 127724, 127725, 127727, 127728, 127729, 
                   127803, 127804, 127805, 127807, 127808, 127809, 127811, 127812, 127813,]

on["20007227"] = [ 127422, 127423, 127424, 127426, 127427, 127428, 
                   127519, 127520, 127521, 127523, 127524, 127525,]


on["20010800"] = [ 127341, 127342, 127343, 127345, 127346, 127347, 127349,
                   127350, 127351, 127354, 127355, 127356,                     # 13-feb
                   127407, 127408, 127409, 127411, 127412, 127413, 127415, 127416, 127417,]

on["245566"] =   [ 127816, 127817, 127818, 127820, 127821, 127822, 127824, 127825, 127826,
                   128425, 128426, 128427, 128429, 128430, 128431,]

on["897104"] =   [ 128814, 128815, 128816, 128818, 128819, 128820,
                   131753, 131754, 131755, 131757, 131758, 131759, 131761, 131762, 131763,]



#        common parameters per source on the first dryrun (run1a, run2a)
pars1 = {}
pars1["169742"]   = ""
pars1["20007227"] = ""
pars1["20010800"] = ""
pars1["245566"]   = ""
pars1["897104"]   = ""

#        common parameters per source on subsequent runs (run1b, run2b), e.g. bank=0 for WARES
pars2 = {}
pars2["169742"]   = ""
pars2["20007227"] = ""
pars2["20010800"] = ""
pars2["245566"]   = ""
pars2["897104"]   = ""

#        common parameters per source on subsequent runs (run1c, run2c), e.g. bank=1 for WARES
pars3 = {}


if __name__ == '__main__':    
    runs.mk_runs(project, on, pars1, pars2, None, sys.argv)
