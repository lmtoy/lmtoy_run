#! /usr/bin/env python
#

import os
import sys

from lmtoy import runs

project="2023-S1-US-00"

#        obsnums per source (make it negative if not added to the final combination)
on = {}
on['foo'] = [ ]


#        common parameters per source on the first dryrun (run1a, run2a)
pars1 = {}
pars1['foo']   = ""

#        common parameters per source on subsequent runs (run1b, run2b), e.g. bank=0 for WARES
pars2 = {}
pars2['foo']   = "srdp=1 admit=0"

#        common parameters per source on subsequent runs (run1c, run2c), e.g. bank=1 for WARES
pars3 = {}
pars3['foo']   = "srdp=1 admit=0"

if __name__ == '__main__':    
    runs.mk_runs(project, on, pars1, pars2, pars3, sys.argv)
