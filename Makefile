#   manage the script generators

GIT_DIRS = lmtoy_2014AYUNM044 \
        lmtoy_2018-S1-MU-8 lmtoy_2018-S1-MU-45 lmtoy_2018-S1-MU-64 lmtoy_2018-S1-MU-66 \
	lmtoy_2021S1RSRCommissioning \
	lmtoy_2021-S1-MX-3 lmtoy_2021-S1-MX-14 lmtoy_2021-S1-MX-34 \
	lmtoy_2021-S1-UM-1 lmtoy_2021-S1-UM-3 lmtoy_2021-S1-UM-11 \
	lmtoy_2021-S1-US-3 \
	lmtoy_2022S1RSRCommissioning \
	lmtoy_2023S1RSRCommissioning \
	lmtoy_2023-S1-MX-41 lmtoy_2023-S1-MX-46 lmtoy_2023-S1-MX-47 lmtoy_2023-S1-MX-55 \
	lmtoy_2023-S1-UM-10 \
	lmtoy_2023-S1-US-8  lmtoy_2023-S1-US-18


.PHONY:  help install build

BASE = https://github.com/teuben

help install:
	@echo "no help/install here"

git:  
	-@for dir in $(GIT_DIRS); do\
	(if [ ! -d $$dir ]; then git clone $(BASE)/$$dir ; fi); done

pull:
	@echo -n "### lmtoy_run: "; git pull
	-@for dir in $(GIT_DIRS); do\
	(echo -n "### $$dir: " ;cd $$dir; git pull); done
	@echo Last pull: `date` >> git.log

status:
	@echo -n "### lmtoy_run: "; git status -uno
	-@for dir in $(GIT_DIRS); do\
	(echo -n "### $$dir: " ;cd $$dir; git status -uno); done

branch:
	@echo -n "### lmtoy_run: "; git branch --show-current
	-@for dir in $(GIT_DIRS); do\
	(echo -n "### $$dir: " ;cd $$dir; git branch --show-current); done

runs:
	-@for dir in $(GIT_DIRS); do\
	(cd $$dir; make runs); done

TAPS = http://taps.lmtgtm.org/lmtslr
index:
	./mk_index.sh $(GIT_DIRS)
