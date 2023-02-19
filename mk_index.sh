#! /usr/bin/env bash
#

taps=http://taps.lmtgtm.org/lmtslr

echo "<html>"
echo '<script src="https://www.kryogenix.org/code/browser/sorttable/sorttable.js"></script>'
echo "Index created $(date) (click on column name to sort by that column)
echo '<table border=1 class="sortable">'
echo '  <tr class="item">'
echo "    <th>"
echo "      ProjectID"
echo "    </th>"
echo "    <th>"
echo "      last_Obsnum"
echo "    </th>"
echo "    <th>"
echo "      last_Obsnum_date"
echo "    </th>"
echo "  </tr>"

for dir in $*; do
    pid=$(echo $dir|sed s/lmtoy_//)
    wdir=$WORK_LMT/$pid
    
    echo '  <tr class="item">'
    echo "    <td>"
    echo "    <LI> <A HREF=$taps/$pid> $pid</A>"
    echo "    </td>"


    if [ -d $wdir ]; then
	last=$(cd $wdir ; ls -d ?????/lmtoy.rc ??????/lmtoy.rc | sort -n  | tail -1 | sed s,/lmtoy.rc,,)
	r=$wdir/$last/README.html
	if [ -e $r ]; then
	    # publish obs_date and red_date
	    date="$(tail -1 $r | cut -c 10-37)" 
	else
	    date=""
	fi
    else
	last=""
	date=""
    fi
    echo "    <td>"
    echo "      $last"
    echo "    </td>"
    
    echo "    <td>"
    echo "      $date"
    echo "    </td>"

    echo "  </tr>"
done
echo "</table>"
echo "Last written on:  $(date)"
