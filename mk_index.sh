#! /usr/bin/env bash
#
#  create the table for http://taps.lmtgtm.org/lmtslr/lmtoy_run/index.html
#
#  @todo make it work for local use not on unity

tap1=http://taps.lmtgtm.org/lmtslr           # /nese/toltec/dataprod_lmtslr/work_lmt
tap2=http://taps.lmtgtm.org/lmthelpdesk      # /nese/toltec/dataprod_lmtslr/work_lmt_helpdesk/peter
taps=http://taps.lmtgtm.org/lmtslr
dv=http://taps.lmtgtm.org/dvsearch/                         # DataVerse
rss=http://lmtserver.astro.umass.edu/rss/lmtrss.html        # LMT status (Kamal)

w=$(echo $WORK_LMT | cut -d/ -f5)

if [ $w == "work_lmt" ]; then
    taps=$tap1
elif [ $w == "work_lmt_helpdesk" ]; then
    user=$(echo $WORK_LMT | cut -d/ -f6)
    taps=$tap2/$user
else
    echo "User not established"
    exit 1
fi

echo "<!-- Using taps=$taps -->"
echo "<html>"
echo '<H1> Progress on SL pipeline data reduction </H1>'
echo '<script src="https://www.kryogenix.org/code/browser/sorttable/sorttable.js"></script>'
echo "Index created $(date) (click on column name to sort by that column)"
echo "<br>"
echo "<A HREF=$tap1/lmtoy_run/last100.html>Latest 100 obsnums from malt available as lightweight TAPs. </A>"
echo "<br>"
echo "<A HREF=$dv>LMT Dataverse archive access</A>"
echo "<br>"
echo "<A HREF=index.old.html>Previous listing of this file.</A>"
echo '<table border=1 class="sortable">'
echo '  <tr class="item">'
echo "    <th>"
echo "      ProjectID"
echo "    </th>"
echo "    <th>"
echo "      Nsources"
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
echo "      ____last_date_obs____"
echo "    </th>"
echo "    <th>"
echo "      __last_pipeline_date__"
echo "    </th>"
echo "    <th>"
echo "      comments"
echo "    </th>"
echo "  </tr>"

#   loop over each command line argument (the lmtoy_PID's)
for dir in $*; do
    pid=$(echo $dir|sed s/lmtoy_//)
    wdir=$WORK_LMT/$pid

    comments=$(grep -w ^$pid comments.txt | sed s/$pid//)
    ns=TBD
    ns=$(grep _s= $dir/*run1a | tabcols - 3 | sed s/_s=// | sort | uniq | wc -l)
    
    echo '  <tr class="item">'
    echo "    <td>"
    echo "      <A HREF=$taps/$pid> $pid</A>"
    echo "    </td>"


    if [ -d $wdir ]; then
	on0=$(cd $wdir ; ls -d */lmtoy.rc | grep -v _ | sort -n | head -1 | sed s,/lmtoy.rc,,)
	on1=$(cd $wdir ; ls -d */lmtoy.rc | grep -v _ | sort -n | tail -1 | sed s,/lmtoy.rc,,)
	n=$(cd $wdir   ; ls -d */lmtoy.rc | wc -l)
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
    echo "      $ns"
    echo "    </td>"
    
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
    echo "      $date_obs"
    echo "    </td>"
    
    echo "    <td>"
    echo "      $date"
    echo "    </td>"

    echo "    <td>"
    echo "      $comments"
    echo "    </td>"

    

    echo "  </tr>"
done
echo "</table>"
echo "Last written on:  $(date)"
