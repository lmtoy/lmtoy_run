#


include PID

help:
	@echo PID=$(PID)
	@echo WORK_LMT=$(WORK_LMT)
	@echo Targets here in $(PWD)
	@echo "   runs      - make the run1/run2/... files"
	@echo "   summary   - update the project summary index"
	@echo "               https://taps.lmtgtm.org/lmtslr/$(PID)"


runs:
	./mk_runs.py


links:  links1 links2

links1: $(PID)

links2: $(PID)/comments.txt

$(PID):
	ln -s $(WORK_LMT)/$(PID)

$(PID)/comments.txt:
	(cd $(PID); ln -sf $(PWD)/comments.txt; ln -sf README.html index.html)

summary:
	@for p in $(PID); do \
	(echo $$p;  cd $(WORK_LMT)/$$p; mk_summary1.sh > README.html); \
	done

q:
	squeue -u lmtslr_umass_edu | awk '{print NR-1,$$0}'

