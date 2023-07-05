# 2018-S1 projects

lmtinfo.py grep 2018S1 | tabcols - 7 | sort | uniq -c | sort -nr

     7472 2018S1SEQUOIACommissioning
     2392 2018S1VLBI1mmCommissioning
     1901 2018S1RSRCommissioning
      318 2018S1VLBI1mmComm
      171 2018S1VLBI1mm
       16 2018S1-MU-8
        1 2018S1SequoiaCommissioning

lmtinfo.py grep 2018-S1 | tabcols - 7,3 | sort | uniq -c | sort -nr | tabalign.py

      N  ProjectId     I    SG      comments

     598 2018-S1-MU-64 SEQ
     545 2018-S1-MU-79 SEQ
     357 2018-S1-MU-8  SEQ
     206 2018-S1-MU-26 RSR
     186 2018-S1-MU-25 SEQ
     168 2018-S1-MU-65 SEQ
     96  2018-S1-MU-67 SEQ
     92  2018-S1-MU-46 SEQ
     86  2018-S1-MU-1  RSR
     79  2018-S1-MU-66 SEQ
     68  2018-S1-MU-45 SEQ
     31  2018-S1-MU-78 RSR
     18  2018-S1-MU-57 RSR
     18  2018-S1-MU-31 SEQ
     1   86.2434       SEQ
     1   2018-S1-MU-90 RSR

script-generators

lmtoy_2018-S1-MU-45
lmtoy_2018-S1-MU-46
lmtoy_2018-S1-MU-64
lmtoy_2018-S1-MU-66
lmtoy_2018-S1-MU-8
