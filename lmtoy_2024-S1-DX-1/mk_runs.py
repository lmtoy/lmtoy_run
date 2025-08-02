#! /usr/bin/env python
#

import os
import sys

from lmtoy import runs

project="2024-S1-DX-1"

#        obsnums per source (make it negative if not added to the final combination)
on = {}

on["PG1202+281"] = \
 [ 132046, 132047, 132048,]

on["PG1402+261"] = \
 [ 131808, 131809, 131810, 131812,-131813,]

on["PG1425+267"] = \
 [ 138020, 138021, 138022, 138024, 138025, 138026, 138028, 138029, 138202, 138203, 138204, 138206, 138207, 138208, 138419, 138420, 138421,]

on["PG1427+480"] = \
 [ 136925, 136926, 136927,]

#        common parameters per source on the first dryrun (run1a, run2a)
pars1 = {}
pars1["PG1202+281"] = "qagrade=3 speczoom=80,3"
pars1["PG1402+261"] = "qagrade=3"
pars1["PG1425+267"] = "qagrade=3 speczoom=80,3"
pars1["PG1427+480"] = "qagrade=3"

#        common parameters per source on subsequent runs (run1b, run2b), e.g. bank=0 for WARES
pars2 = {}
pars2["PG1202+281"] = ""
pars2["PG1402+261"] = ""
pars2["PG1425+267"] = ""
pars2["PG1427+480"] = ""



if __name__ == '__main__':    
    runs.mk_runs(project, on, pars1, pars2, sys.argv)
