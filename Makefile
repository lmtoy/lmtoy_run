#   manage the script generators, also note the YEAR file for local deviations

# where they are stored (used to be https://github.com/teuben)
BASE  = https://github.com/lmtoy

# toy project
GIT_DIRS_2000 = \
        lmtoy_2000-S1-AA-1

# old
GIT_DIRS_OLD = lmtoy_2014AYUNM044 \
        lmtoy_2014ARSRCommissioning \
	lmtoy_2021S1RSRCommissioning \
# 2998 2015ARSRCommissioning
# 4089 2016ARSRCommissioning

#  552 2018ARSRCommissioning
# 1904 2018S1RSRCommissioning


GIT_DIRS_2018 = \
        lmtoy_2018S1SEQUOIACommissioning \
	lmtoy_2018-S1-MU-1  lmtoy_2018-S1-MU-8 lmtoy_2018-S1-MU-25 lmtoy_2018-S1-MU-26 \
	lmtoy_2018-S1-MU-31 lmtoy_2018-S1-MU-45 \
	lmtoy_2018-S1-MU-46 lmtoy_2018-S1-MU-57 lmtoy_2018-S1-MU-64 lmtoy_2018-S1-MU-65 \
	lmtoy_2018-S1-MU-66 lmtoy_2018-S1-MU-67 lmtoy_2018-S1-MU-78 lmtoy_2018-S1-MU-79

#    110 2019S1SEQUOIACommissioning
#      2 2019SEQUOIACommissioning

#    195 2021S1RSRCommissioning
#     49 2021S1SEQUOIACommissioning

# 	lmtoy_2021S1RSRCommissioning 
GIT_DIRS_2021 = \
	lmtoy_2021-S1-MX-3 lmtoy_2021-S1-MX-5  lmtoy_2021-S1-MX-14 lmtoy_2021-S1-MX-26 lmtoy_2021-S1-MX-34 \
	lmtoy_2021-S1-UM-1 lmtoy_2021-S1-UM-3  lmtoy_2021-S1-UM-11 \
	lmtoy_2021-S1-US-3 lmtoy_2021-S1-US-17 lmtoy_2021-S1-US-19 

#=  1706 2022S1MSIP1mmCommissioning
#     30 2022S1OOFCommissioning
#    748 2022S1RSRCommissioning
#=  2901 2022S1SEQUOIACommissioning
#    263 2022S1VLBI1mmCommissioning
#    103 2022VLBI1mmCommissioning

GIT_DIRS_2022 = \
	lmtoy_2022S1RSRCommissioning \
	lmtoy_2022S1SEQUOIACommissioning \
	lmtoy_2022S1MSIP1mmCommissioning

#    294 2023MSIP1mmCommissioning
#     76 2023S1MSIP1mmCommissioning
#   2188 2023S1RSRCommissioning
#    739 2023S1SEQUOIACommissioning
#    238 2023S1VLBI1mmCommissioning
#      1 2023S1VLBI3mmCommissioning
#     85 2023SequoiaCommissioning

GIT_DIRS_2023 = \
	lmtoy_2023S1RSRCommissioning \
        lmtoy_2023S1SEQUOIACommissioning \
	lmtoy_2023-S1-MX-28 lmtoy_2023-S1-MX-40 lmtoy_2023-S1-MX-41 lmtoy_2023-S1-MX-42 lmtoy_2023-S1-MX-46 \
	lmtoy_2023-S1-MX-47 lmtoy_2023-S1-MX-49 lmtoy_2023-S1-MX-55 \
	lmtoy_2023-S1-UM-8 lmtoy_2023-S1-UM-10 lmtoy_2023-S1-UM-15 lmtoy_2023-S1-UM-16 \
	lmtoy_2023-S1-US-8 lmtoy_2023-S1-US-17 lmtoy_2023-S1-US-18

GIT_DIRS_2024 = \
	lmtoy_2024S1MSIP1mmCommissioning \
	lmtoy_2024S1RSRCommissioning \
	lmtoy_2024S1SEQUOIACommissioning \
	lmtoy_2024-S1-DX-1 \
	lmtoy_2024-S1-MX-2 lmtoy_2024-S1-MX-3 lmtoy_2024-S1-MX-5 \
	lmtoy_2024-S1-MX-11 lmtoy_2024-S1-MX-15 lmtoy_2024-S1-MX-17 lmtoy_2024-S1-MX-18 \
        lmtoy_2024-S1-MX-20 lmtoy_2024-S1-MX-22 lmtoy_2024-S1-MX-24 \
        lmtoy_2024-S1-MX-26 lmtoy_2024-S1-MX-32 lmtoy_2024-S1-MX-34 lmtoy_2024-S1-MX-35 lmtoy_2024-S1-MX-37 \
	lmtoy_2024-S1-SP-5 lmtoy_2024-S1-SP-7 \
	lmtoy_2024-S1-UM-1 lmtoy_2024-S1-UM-3 lmtoy_2024-S1-UM-9 lmtoy_2024-S1-UM-11 \
	lmtoy_2024-S1-US-3 lmtoy_2024-S1-US-5 lmtoy_2024-S1-US-16 lmtoy_2024-S1-US-17 lmtoy_2024-S1-US-20

# default, but the YEAR file can override
GIT_DIRS = $(GIT_DIRS_2024) $(GIT_DIRS_2023) $(GIT_DIRS_2022)
-include YEAR

.PHONY:  help install build status pull

## install:   
install:
	@echo "GIT_DIRS=$(GIT_DIRS)"


## help:    this help
help: Makefile
	@sed -n 's/^##//p' $<

## git:     ensure all git repos for GIT_DIRS= are present
git:  pull1
	-@for dir in $(GIT_DIRS_2000) $(GIT_DIRS); do\
	(if [ ! -d $$dir ]; then git clone $(BASE)/$$dir ; fi); done

pull1:
	git pull
	@echo "Also consider 'make pull' to update all script generators"
	@echo "Or 'make status' to query their status"
	@echo "Or 'make branch' to query what branch you are on"

## pull:    git pull    from all repos from GIT_DIRS=
pull:   pull1
	@echo -n "### lmtoy_run: "; git pull
	-@for dir in $(GIT_DIRS_2000) $(GIT_DIRS); do\
	(echo -n "### $$dir " ;cd $$dir; git pull); done
	@echo Last pull: `date` >> git.log

## status:  git status -uno  from all repos from GIT_DIRS=
status:
	@echo -n "### lmtoy_run: "; git status -uno
	-@for dir in $(GIT_DIRS_2000) $(GIT_DIRS); do\
	(echo "### $$dir " ;cd $$dir; git status -suno); done

## log:     git log --pretty=oneline    from all repos from GIT_DIRS=
log:
	@echo -n "### lmtoy_run: "; git log --pretty=oneline -1
	-@for dir in $(GIT_DIRS_2000) $(GIT_DIRS); do\
	(echo "### $$dir " ;cd $$dir; git log --pretty=oneline -1); done

## branch:  git branch --show-current    from all repos from GIT_DIRS=
branch:
	@echo -n "### lmtoy_run: "; git branch --show-current
	-@for dir in $(GIT_DIRS_2000) $(GIT_DIRS); do\
	(echo -n "### $$dir " ;cd $$dir; git branch --show-current); done

## runs:    update the run scripts for all repos from GIT_DIRS=
runs:
	-@for dir in $(GIT_DIRS_2000) $(GIT_DIRS); do\
	(cd $$dir; make runs); done

TAPS = http://taps.lmtgtm.org/lmtslr
## index:   update the index for TAPS (lmtoy_run) - keeps one index.old.html
index:
	@cp index.html index.old.html
	@./mk_index.sh $(GIT_DIRS) > index.html
	@echo "xdg-open http://taps.lmtgtm.org/lmtslr/lmtoy_run"
