# 2021-S1 projects

lmtinfo.py grep 2021S1 | tabcols - 7 | sort | uniq -c | sort -nr

     195 2021S1RSRCommissioning
      49 2021S1SEQUOIACommissioning
       1 2021S1MSIP1mmCommissioning

lmtinfo.py grep 2021-S1 | tabcols - 7,3 | sort | uniq -c | sort -nr | tabalign.py

      N  ProjectId     I    SG      comments
       
     374 2021-S1-MX-3  SEQ  ok      edge survey
     242 2021-S1-UM-11 RSR  ok
     177 2021-S1-MX-14 SEQ  ok      ?
     141 2021-S1-US-3  SEQ  ok      M100
     91  2021-S1-MX-34 RSR  ok
     65  2021-S1-US-19 RSR 
     45  2021-S1-UM-3  SEQ  ok      ?
     28  2021-S1-MX-26 RSR
     13  2021-S1-UM-1  SEQ  ok      ?  (skeleton)
     8   2021-S1-US-17 RSR
     7   2021-S1-MX-5  SEQ          ?

script-generators

lmtoy_2021-S1-MX-14
lmtoy_2021-S1-MX-3
lmtoy_2021-S1-MX-34
lmtoy_2021-S1-UM-1
lmtoy_2021-S1-UM-11
lmtoy_2021-S1-UM-3
lmtoy_2021-S1-US-3
lmtoy_2021S1RSRCommissioning
