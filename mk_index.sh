#! /usr/bin/env bash
#


h=index.html
taps=http://taps.lmtgtm.org/lmtslr

echo "<H1> LMT projects </H1>" > $h
echo "Index created $(date)"   >> $h
echo "<UL>"                    >> $h
for dir in $*; do
    pid=$(echo $dir|sed s/lmtoy_//)
    echo -n "<LI> <A HREF=$taps/$pid> $pid</A>" >> $h
    wdir=$WORK_LMT/$pid
    if [ -d $wdir ]; then
	last=$(cd $wdir ; ls -d ?????/lmtoy.rc ??????/lmtoy.rc | sort -n  | head -1 | sed s,/lmtoy.rc,,)
	echo -n " $last "  >> $h
	r=$wdir/$last/README.html
	if [ -e $r ]; then
	    echo "$(tail -1 $r | cut -c 10-37)" >> $h
	else
	    echo " - " >> $h
	fi
    else
	echo " - "  >> $h
    fi
done
echo "</UL>"                  >> $h

