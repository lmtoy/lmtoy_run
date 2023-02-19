#! /usr/bin/bash
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
	echo $last
	echo " yes $last "  >> $h
    else
	echo " no "  >> $h
    fi
done
echo "</UL>"                  >> $h

