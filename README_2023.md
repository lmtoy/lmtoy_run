

lmtinfo.py grep 2023S1 | tabcols - 7 | sort | uniq -c | sort -nr

     2110 2023S1RSRCommissioning
      735 2023S1SEQUOIACommissioning
      274 2023S1VLBI1mm
      240 2023S1VLBI1mmCommissioning
      226 2023S1VLBI3mm
       76 2023S1MSIP1mmCommissioning
        1 2023S1VLBI3mmCommissioning


lmtinfo.py grep 2023-S1 | tabcols - 7,3 | sort | uniq -c | sort -nr | tabalign.py


     368 2023-S1-MX-47 RSR
     316 2023-S1-MX-55 RSR
     309 2023-S1-MX-41 RSR
     297 2023-S1-MX-46 RSR
     282 2023-S1-UM-10 RSR
     205 2023-S1-US-18 RSR
     106 2023-S1-US-8  RSR
     37  2023-S1-MX-40 RSR
     23  2023-S1-US-17 RSR
     21  2023-S1-MX-28 SEQ
     20  2023-S1-UM-8  SEQ
     20  2023-S1-MX-49 SEQ
     14  2023-S1-UM-16 SEQ
     10  2023-S1-UM-15 SEQ

