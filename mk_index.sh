#! /usr/bin/env bash
#
#  create the table for http://taps.lmtgtm.org/lmtslr/lmtoy_run/index.html
#
#  @todo make it work for local use not on unity

tap1=http://taps.lmtgtm.org/lmtslr                          # /nese/toltec/dataprod_lmtslr/work_lmt
tap2=http://taps.lmtgtm.org/lmthelpdesk                     # /nese/toltec/dataprod_lmtslr/work_lmt_helpdesk/peter
taps=http://taps.lmtgtm.org/lmtslr                          # 
dv=http://taps.lmtgtm.org/dvsearch/                         # DataVerse
wr=http://taps.lmtgtm.org/pipeline_web                                 # webrun interface to pipeline
rss=http://lmtserver.astro.umass.edu/rss/lmtrss.html                   # LMT status (Kamal)
obs=http://lmtserver.astro.umass.edu/obs                               # observatory calendar
url1=https://www.kryogenix.org/code/browser/sorttable/sorttable.js     # remote version 
bench1=http://taps.lmtgtm.org/lmtslr/2014ARSRCommissioning/33551/README.html
bench2=http://taps.lmtgtm.org/lmtslr/2018S1SEQUOIACommissioning/79448/README.html
bench3=http://taps.lmtgtm.org/lmtslr/2024S1SEQUOIACommissioning/110399/README.html

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

last_unity=$(cat $DATA_LMT/last.obsnum | tail -1)
last_malt=$(tabcols last100.log 2  | head -1)

echo "<!-- Using taps=$taps -->"
echo "<!-- created by $0 -->"
echo "<html>"
echo '<H1> Progress on SL pipeline data reduction </H1>'
echo '<script src="sorttable.js"></script>'
echo "Index created $(date) (click on column name to sort by that column)"
echo "<br>"
echo "<A HREF=$tap1/lmtoy_run/last100.html>Latest 100 obsnums from malt available as lightweight TAPs. </A>"
echo "<br>"
echo "Latest obsnum registered on Malt : $last_malt"
echo "<br>"
echo "Latest obsnum registered on Unity: $last_unity"
echo "<br>"
echo "LMTOY benchmarks: <A HREF=$bench1>bench1</A>, <A HREF=$bench2>bench2</A>, <A HREF=$bench3>bench3</A>"
echo "<br>"
echo "<A HREF=$obs>Observatory Calendar</A>"
echo "<br>"
echo "<A HREF=$dv>LMT Dataverse archive access</A>"
echo "<br>"
echo "<A HREF=$wr>Pipeline Re-run (experimental)</A>"
echo "<br>"
echo "<A HREF=index.old.html>Previous listing of this file,</A>"
echo "<A HREF=index.old>Most recent listing of this file.</A>"
echo '<table border=1 class="sortable">'
echo '  <tr class="item">'
echo "    <th>"
echo "      #"
echo "    </th>"
echo "    <th>"
echo "      ProjectID"
echo "    </th>"
echo "    <th>"
echo "      Nsrc"
echo "    </th>"
echo "    <th>"
echo "      Nobs"
echo "    </th>"
echo "    <th>"
echo "      first_Obs"
echo "    </th>"
echo "    <th>"
echo "      last_Obs"
echo "    </th>"
echo "    <th>"
echo "      ____last_date_obs____"
echo "    </th>"
echo "    <th>"
echo "      __last_pipeline_date__"
echo "    </th>"
echo "    <th>"
echo "      Archived"
echo "    </th>"
echo "    <th>"
echo "      comments"
echo "    </th>"
echo "  </tr>"

#   loop over each command line argument (the lmtoy_PID's)
i=0
for dir in $*; do
    ((i++))
    pid=$(echo $dir|sed s/lmtoy_//)
    wdir=$WORK_LMT/$pid

    comments=$(grep -w ^$pid comments.txt | sed s/$pid//)
    ns=TBD
    ns=$(grep _s= $dir/*run1a | tabcols - 4 | sed s/_s=// | sort | uniq | wc -l)
    
    echo '  <tr class="item">'
    echo "    <td>"
    echo "      ${i}."
    echo "    </td>"
    
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
    echo "      -"
    echo "    </td>"



    echo "    <td>"
    echo "      $comments"
    echo "    </td>"

    

    echo "  </tr>"
done
echo "</table>"
echo "Last written on:  $(date)"
