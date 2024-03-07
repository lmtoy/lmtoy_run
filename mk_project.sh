#! /bin/bash
#
#

PID=$1
pdir=lmtoy_$PID

if [ -z "$PID" ]; then
    echo "Usage: $0 PID"
    echo "Will create a new script generator lmtoy_PID"
    echo "NOTE: this will be the https://github.com/lmtoy/ namespace and you need special permission"
    echo "      plus for the sake of this script, you need to set up github's  'gh' command"
    echo "To check on a default mk_runs.py edit, use the command"
    echo "      source_obsnum.sh PID"
    exit 0
fi

if [ -d $pdir ]; then
    echo "lmtoy_$PID already exists"
    exit 0
fi

gh repo create --public lmtoy/lmtoy_$PID
gh repo clone lmtoy/lmtoy_$PID
cd lmtoy_$PID
cp ../template/{README.md,Makefile,mk_runs.py,comments.txt} .
echo "PID=\"$PID\"" > PID
git add PID
git add {README.md,Makefile,mk_runs.py,comments.txt}
git commit -m new {README.md,Makefile,mk_runs.py,comments.txt,PID}
git push


echo "Don't forget to add your PID:"
echo "     $PID to comments.txt "
echo "     lmtoy_$PID in the Makefile in the appropriate year"
