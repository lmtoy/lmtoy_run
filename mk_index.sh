#! /usr/bin/env bash
#

taps=http://taps.lmtgtm.org/lmtslr

echo "<html>"
echo '<script src="https://www.kryogenix.org/code/browser/sorttable/sorttable.js"></script>'
echo "Index created $(date) (click on column name to sort by that column)"
echo '<table border=1 class="sortable">'
echo '  <tr class="item">'
echo "    <th>"
echo "      ProjectID"
echo "    </th>"
echo "    <th>"
echo "      Nobsnums"
echo "    </th>"
echo "    <th>"
echo "      first_Obsnum"
echo "    </th>"
echo "    <th>"
echo "      last_Obsnum"
echo "    </th>"
echo "    <th>"
echo "      last_pipeline_date"
echo "    </th>"
echo "    <th>"
echo "      date_obs"
echo "    </th>"
echo "  </tr>"

for dir in $*; do
    pid=$(echo $dir|sed s/lmtoy_//)
    wdir=$WORK_LMT/$pid
    
    echo '  <tr class="item">'
    echo "    <td>"
    echo "      <A HREF=$taps/$pid> $pid</A>"
    echo "    </td>"


    if [ -d $wdir ]; then
	on0=$(cd $wdir ; ls -d ?????/lmtoy.rc ??????/lmtoy.rc | sort -n  | head -1 | sed s,/lmtoy.rc,,)
	on1=$(cd $wdir ; ls -d ?????/lmtoy.rc ??????/lmtoy.rc | sort -n  | tail -1 | sed s,/lmtoy.rc,,)
	n=$(cd $wdir ; ls -d ?????/lmtoy.rc ??????/lmtoy.rc | wc -l)
	r=$wdir/$on1/README.html
	date=""
	date_obs=""
	source $wdir/$on1/lmtoy_${on1}.rc
    else
	n=""
	on0=""
	on1=""
	date=""
	date_obs=""	
    fi
    echo "    <td>"
    echo "      $n"
    echo "    </td>"
    
    echo "    <td>"
    echo "      $on0"
    echo "    </td>"
    
    echo "    <td>"
    echo "      $on1"
    echo "    </td>"
    
    echo "    <td>"
    echo "      $date"
    echo "    </td>"
    
    echo "    <td>"
    echo "      $date_obs"
    echo "    </td>"

    echo "  </tr>"
done
echo "</table>"
echo "Last written on:  $(date)"
