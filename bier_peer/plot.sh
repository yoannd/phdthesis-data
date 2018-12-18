#!/bin/bash


##### POLICY ANALYSIS #####
### Nb of destinations that _did not_ receive the transmission from the source, and which are selecting peers 0 and 32 under the ε-greedy policy####
# static #
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,20" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'bier_peer_analysis-dest-0-a.pdf'


set xlabel "Packet number"
set ylabel "Number of destinations"
set xrange [0:3000]
set yrange [0:50]

step=1

plot \
'<gzcat log-eee000-eee000-a-n3000-seed1.txt.gz  | awk "{print (\$15*\$13);} " | ewma.py 0.01' u (column(0)):1 t 'ε=0, dest #0'  w l lw 2 lt 1, \
'<gzcat log-eee020-eee020-a-n3000-seed1.txt.gz  | awk "{print (\$15*\$13);} " | ewma.py 0.01' u (column(0)):1 t 'ε=0, dest #0'  w l lw 2 lt 2
#'<gzcat log-eee000-eee000-a-n3000-seed1.txt.gz ' u 2:(column(15)*column(13)) t 'ε=0.2, dest #0' w points lc rgb "#aaaaaa" ps 0.5 pt 1, \
#'<gzcat log-eee020-eee020-a-n3000-seed1.txt.gz ' u 2:(column(15)*column(13)) t 'ε=0.2, dest #0' w points lc rgb "#cccccc" ps 0.5 pt 2

pause mouse keypress
EOF


### Nb of destinations that _did not_ receive the transmission from the source, and which are selecting peers 0 and 32 under the ε-greedy policy####
# dynamic #
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,20" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'bier_peer_analysis-dest-0-32-f.pdf'


set xlabel "Packet number"
set ylabel "Number of destinations"
set xrange [0:16000]
set yrange [0:50]

step=20

plot \
'<gzcat log-eee000-eee000-f-n16000-seed1.txt.gz  | awk "{print (\$15*\$13);} " | ./ewma.py 0.01' using (column(0)*step):1 every (step) title 'ε=0, dest #0'  with lines lw 2 lt 1, \
'<gzcat log-eee000-eee000-f-n16000-seed1.txt.gz  | awk "{print (\$47*\$13);} " | ./ewma.py 0.01' using (column(0)*step):1 every (step) title 'ε=0, dest #32'  with lines lw 2 lt 2, \
'<gzcat log-eee020-eee020-f-n16000-seed1.txt.gz  | awk "{print (\$15*\$13);} " | ./ewma.py 0.01' using (column(0)*step):1 every (step) title 'ε=0.2, dest #0'  with lines lw 2 lt 3, \
'<gzcat log-eee020-eee020-f-n16000-seed1.txt.gz  | awk "{print (\$47*\$13);} " | ./ewma.py 0.01' using (column(0)*step):1 every (step) title 'ε=0.2, dest #32'  with lines lw 2 lt 4
#'<gzcat log-eee000-eee000-f-n16000-seed1.txt.gz ' u 2:(column(15)*column(13)) t '' w points lc rgb "#888888" ps 0.5 pt 1, \
#'<gzcat log-eee000-eee000-f-n16000-seed1.txt.gz ' u 2:(column(47)*column(13)) t '' w points lc rgb "#aaaaaa" ps 0.5 pt 2, \
#'<gzcat log-eee020-eee020-f-n16000-seed1.txt.gz ' u 2:(column(15)*column(13)) t '' w points lc rgb "#cccccc" ps 0.5 pt 3, \
#'<gzcat log-eee020-eee020-f-n16000-seed1.txt.gz ' u 2:(column(47)*column(13)) t '' w points lc rgb "#eeeeee" ps 0.5 pt 4, \

pause mouse keypress
EOF



### Success ratio (after 1st recovery) for epsilon-greedy policy, static ####
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,20" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'bier_peer_analysis-success-eee-comp-a.pdf'


set xlabel "Packet number"
set ylabel "Success ratio"
set xrange [0:3000]
set yrange [0:1.2]

step=1

plot \
'<gzcat log-eee000-eee000-a-n3000-seed1.txt.gz  | awk "{if (\$7<1) print (\$8-\$7)/(1-\$7);} " | ./ewma.py 0.01' using (column(0)*step):1 every (step) title 'ε=0' with lines lw 2 lt 1, \
'<gzcat log-eee020-eee020-a-n3000-seed1.txt.gz  | awk "{if (\$7<1) print (\$8-\$7)/(1-\$7);} " | ./ewma.py 0.01' using (column(0)*step):1 every (step) title 'ε=0.2' with lines lw 2 lt 2, \
#'<gzcat log-eee000-eee000-a-n3000-seed1.txt.gz ' using 2:((column(8)-column(7))/(1-column(7)))  title '' w points pt 1 lc 0 ps 0.5, \
#'<gzcat log-eee020-eee020-a-n3000-seed1.txt.gz ' using 2:((column(8)-column(7))/(1-column(7)))  title '' w points pt 2 lc rgb "#dddddd" ps 0.5, \


pause mouse keypress
EOF


### Success ratio (after 1st recovery) for epsilon-greedy policy, dynamic ####
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,20" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'bier_peer_analysis-success-eee-comp-f.pdf'


set xlabel "Packet number"
set ylabel "Success ratio"
set xrange [0:16000]
set yrange [0:1.2]

step=20

plot \
'<gzcat log-eee000-eee000-f-n16000-seed1.txt.gz  | awk "{if (\$7<1) print (\$8-\$7)/(1-\$7);} " | ./ewma.py 0.01' using (column(0)*step):1 every (step)  title 'ε=0' with lines lw 2 lt 1, \
'<gzcat log-eee020-eee020-f-n16000-seed1.txt.gz  | awk "{if (\$7<1) print (\$8-\$7)/(1-\$7);} " | ./ewma.py 0.01' using (column(0)*step):1 every (step)  title 'ε=0.2' with lines lw 2 lt 2
#'<gzcat log-eee000-eee000-f-n16000-seed1.txt.gz ' using 2:((column(8)-column(7))/(1-column(7)))  title '' w points pt 1 lc 0 ps 0.5, \
#'<gzcat log-eee020-eee020-f-n16000-seed1.txt.gz ' using 2:((column(8)-column(7))/(1-column(7)))  title '' w points pt 2 lc rgb "#dddddd" ps 0.5, \


pause mouse keypress
EOF



### PDF of the recovery at 2k hops (conditioning to a loss). ####
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'bier_peer_analysis-prob-rec-2k-hops.pdf'

set ylabel "PDF"
set xlabel "Minimum distance to successful destination"

topol1="1-2-2-2-32"
topol2="1-2-2-2-2-2-8"

plot '<(grep exp pdf-fd.txt | grep '.topol1.' | awk "(\$5==0.1)" )' using 3:6 with lines title topol1.' exp', \
'<(grep lin pdf-fd.txt | grep '.topol1.' | awk "(\$5==0.1)")' using 3:6 with lines title topol1.' lin', \
'<(grep exp pdf-fd.txt | grep '.topol2.' | awk "(\$5==0.1)" )' using 3:6 with lines title topol2.' exp', \
'<(grep lin pdf-fd.txt | grep '.topol2.' | awk "(\$5==0.1)")' using 3:6 with lines title topol2.' lin'

pause mouse keypress
EOF


### Number of destinations able to obtain a retransmission of a packet from a peer with k=35, n=100 ####
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'bier_peer_analysis-distr-success-n100-k35-rnd-clu.pdf'


set xlabel "Recovery successes"
set ylabel "PDF"
set xrange [0:36] 
set boxwidth 0.25 
set style fill solid

plot '<(grep rnd logprue.txt)' using 4:5 w boxes title 'Random', \
'<(grep clu logprue.txt)' using (column(4)+0.25):5 w boxes title 'Clustered'

pause mouse keypress
EOF

### Probability that a fraction of (1-δ) of destinations successfully receive the packet 
### (1) directly from the source in the first transmission,
### or (2) from a contacted peer – i.e., excluding source retransmissions, with n = 100, β = 0.2. ####
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'bier_peer_analysis-prob_1eps_direct_req.pdf'


set key bottom
set grid
set xlabel 'Fraction δ of destinations served by the source'
set ylabel 'CDF'
set yrange [0:1.2]
plot 'logprue2.txt' using 1:2 with lines t 'Random', 'logprue2.txt' using 1:3 with lines t 'Cluster'

pause mouse keypress
EOF


### ONE-PEERSTRING MODE ###
## Link usage for source->core ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_gilbert_elliott_peer_randomdesignatedinsubtree_link_src_to_core.pdf'
set xlabel "Average loss probability (α)"
set ylabel "Average link usage (b/s)"
set yrange [0:1200000000.]
set key bottom right
factor=8/4 #4 seconds

plot 'peer-all-mc-traffic-random-in-subtree.txt' using 1:($50*factor) with linespoints title 'BIER-PEER, random, source to core link' ls 1 pt 2, \
'peer-all-mc-traffic-designated-in-subtree.txt' using 1:($50*factor) with linespoints title 'BIER-PEER, clustered, source to core link' ls 3 pt 4, \
'bier-all-mc-traffic-designated-in-subtree.txt' using 1:($50*factor) with linespoints title 'BIER, source to core link' ls 2 pt 3, \

pause mouse keypress
EOF

## Retransmissions by source ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_gilbert_elliott_peer_randomdesignatedinsubtree_source_retransmissions.pdf'
set xlabel "Average loss probability (α)"
set ylabel "Source retransmissions"
#set xrange [-0.5:19]
set yrange [0:2.5e5]
set xtics rotate
set style fill solid 0.4
set boxwidth 0.28
set key left

plot 'peer-peer-to-src-ratio-random-in-subtree.txt' using (column(0)):2 every ::9 with boxes title 'BIER-PEER, random' ls 1, \
'peer-peer-to-src-ratio-designated-in-subtree.txt' using (column(0)+0.28):2:xtic(1) every ::9 with boxes title 'BIER-PEER, clustered' ls 3, \
"bier-peer-to-src-ratio-designated-in-subtree.txt" using (column(0)+0.56):2 every ::9 with boxes title 'BIER' ls 2, \

pause mouse keypress
EOF

### Random policy: Number of destinations in bier bitstrings ###
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_gilbert_elliott_peer_randominsubtree_bitstrings.pdf'
set multiplot layout 1,2

set xlabel "# of destinations in source bistrings"
set ylabel "CDF"
set yrange [0:1]
#set xrange [0:20]
set key bottom right
npoints1=system("gzcat peer-proba0.01-retransmits-random-in-subtree.txt.gz | grep 'at 47' | wc -l")+0
npoints5=system("gzcat peer-proba0.05-retransmits-random-in-subtree.txt.gz | grep 'at 47' | wc -l")+0
npoints10=system("gzcat peer-proba0.10-retransmits-random-in-subtree.txt.gz | grep 'at 47' | wc -l")+0
plot \
"< gzcat peer-proba0.01-retransmits-random-in-subtree.txt.gz | grep 'at 47'" using 10:(1./npoints1) smooth cumulative with linespoints title 'α=0.01', \
"< gzcat peer-proba0.05-retransmits-random-in-subtree.txt.gz | grep 'at 47'" using 10:(1./npoints5) smooth cumulative with linespoints title 'α=0.05', \
"< gzcat peer-proba0.10-retransmits-random-in-subtree.txt.gz | grep 'at 47'" using 10:(1./npoints10) smooth cumulative with linespoints title 'α=0.10'

set xlabel "# of destinations in peers bistrings"
set xrange [0:5]

npoints1=system("gzcat peer-proba0.01-retransmits-random-in-subtree.txt.gz | grep -v 'at 47' | wc -l")+0
npoints5=system("gzcat peer-proba0.05-retransmits-random-in-subtree.txt.gz | grep -v 'at 47' | wc -l")+0
npoints10=system("gzcat peer-proba0.10-retransmits-random-in-subtree.txt.gz | grep -v 'at 47' | wc -l")+0
plot \
"< gzcat peer-proba0.01-retransmits-random-in-subtree.txt.gz | grep -v 'at 47'" using 10:(1./npoints1) smooth cumulative with linespoints title 'α=0.01', \
"< gzcat peer-proba0.05-retransmits-random-in-subtree.txt.gz | grep -v 'at 47'" using 10:(1./npoints5) smooth cumulative with linespoints title 'α=0.05', \
"< gzcat peer-proba0.10-retransmits-random-in-subtree.txt.gz | grep -v 'at 47'" using 10:(1./npoints10) smooth cumulative with linespoints title 'α=0.10'

pause mouse keypress
EOF



### Clustered policy: Number of destinations in bier bitstrings ###
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_gilbert_elliott_peer_designatedinsubtree_bitstrings.pdf'
set multiplot layout 1,2

set xlabel "# of destinations in source bistrings"
set ylabel "CDF"
set yrange [0:1]
#set xrange [0:20]
set key bottom right
npoints1=system("gzcat peer-proba0.01-retransmits-designated-in-subtree.txt.gz | grep 'at 47' | wc -l")+0
npoints5=system("gzcat peer-proba0.05-retransmits-designated-in-subtree.txt.gz | grep 'at 47' | wc -l")+0
npoints10=system("gzcat peer-proba0.10-retransmits-designated-in-subtree.txt.gz | grep 'at 47' | wc -l")+0
plot \
"< gzcat peer-proba0.01-retransmits-designated-in-subtree.txt.gz | grep 'at 47'" using 10:(1./npoints1) smooth cumulative with linespoints title 'α=0.01', \
"< gzcat peer-proba0.05-retransmits-designated-in-subtree.txt.gz | grep 'at 47'" using 10:(1./npoints5) smooth cumulative with linespoints title 'α=0.05', \
"< gzcat peer-proba0.10-retransmits-designated-in-subtree.txt.gz | grep 'at 47'" using 10:(1./npoints10) smooth cumulative with linespoints title 'α=0.10'

set xlabel "# of destinations in peers bistrings"
set xrange [0:5]

npoints1=system("gzcat peer-proba0.01-retransmits-designated-in-subtree.txt.gz | grep -v 'at 47' | wc -l")+0
npoints5=system("gzcat peer-proba0.05-retransmits-designated-in-subtree.txt.gz | grep -v 'at 47' | wc -l")+0
npoints10=system("gzcat peer-proba0.10-retransmits-designated-in-subtree.txt.gz | grep -v 'at 47' | wc -l")+0
plot \
"< gzcat peer-proba0.01-retransmits-designated-in-subtree.txt.gz | grep -v 'at 47'" using 10:(1./npoints1) smooth cumulative with linespoints title 'α=0.01', \
"< gzcat peer-proba0.05-retransmits-designated-in-subtree.txt.gz | grep -v 'at 47'" using 10:(1./npoints5) smooth cumulative with linespoints title 'α=0.05', \
"< gzcat peer-proba0.10-retransmits-designated-in-subtree.txt.gz | grep -v 'at 47'" using 10:(1./npoints10) smooth cumulative with linespoints title 'α=0.10'

pause mouse keypress
EOF


### TWO-PEERSTRINGS MODE ###


## Link usage for source->core ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_gilbert_elliott_peer_designatedintwotrees_link_src_to_core.pdf'
set xlabel "Average loss probability (α)"
set ylabel "Average link usage (b/s)"
set yrange [0:1200000000.]
set key bottom right
factor=8/4 #4 seconds

plot 'peer2-all-mc-traffic.txt' using 1:($50*factor) with linespoints title 'BIER-PEER, clustered 2 levels, source to core link' ls 1, \
'peer-all-mc-traffic-designated-in-subtree.txt' using 1:($50*factor) with linespoints title 'BIER-PEER, clustered, source to core link' ls 3, \
'bier-all-mc-traffic-designated-in-subtree.txt' using 1:($50*factor) with linespoints title 'BIER, source to core link' ls 2, \

pause mouse keypress
EOF



## Retransmissions by source ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_gilbert_elliott_peer_designatedintwotrees_source_retransmissions.pdf'
set xlabel "Average loss probability (α)"
set ylabel "Source retransmissions"
#set xrange [-0.5:19]
set yrange [0:2.5e5]
set xtics rotate
set style fill solid 0.4
set boxwidth 0.28
set key left

plot 'peer2-peer-to-src-ratio.txt' using (column(0)):2 every ::9 with boxes title 'BIER-PEER, clustered 2 levels' ls 1, \
'peer-peer-to-src-ratio-designated-in-subtree.txt' using (column(0)+0.28):2:xtic(1) every ::9 with boxes title 'BIER-PEER, clustered' ls 3, \
"bier-peer-to-src-ratio-designated-in-subtree.txt" using (column(0)+0.56):2 every ::9 with boxes title 'BIER' ls 2, \

pause mouse keypress
EOF


### Number of destinations in bier bitstrings ##
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_gilbert_elliott_peer_designatedintwotrees_bitstrings.pdf'
set ylabel "CDF"
set yrange [0:1]
#set xrange [0:10]
set key bottom right

set multiplot layout 1,2

set xlabel "# of destinations in source bitstrings"
npoints1=system("gzcat peer2-proba0.01-retransmits.txt.gz | grep 'at 47' | wc -l")+0
npoints5=system("gzcat peer2-proba0.05-retransmits.txt.gz | grep 'at 47' | wc -l")+0
npoints10=system("gzcat peer2-proba0.10-retransmits.txt.gz | grep 'at 47' | wc -l")+0
plot \
"< gzcat peer2-proba0.01-retransmits.txt.gz | grep 'at 47'" using 10:(1./npoints1) smooth cumulative with linespoints title 'α=0.01', \
"< gzcat peer2-proba0.05-retransmits.txt.gz | grep 'at 47'" using 10:(1./npoints5) smooth cumulative with linespoints title 'α=0.05', \
"< gzcat peer2-proba0.10-retransmits.txt.gz | grep 'at 47'" using 10:(1./npoints10) smooth cumulative with linespoints title 'α=0.10'


set xrange [0:10]
set xlabel "# of destinations in peer bitstrings"
set key bottom right
npoints1=system("gzcat peer2-proba0.01-retransmits.txt.gz | grep -v 'at 47' | wc -l")+0
npoints5=system("gzcat peer2-proba0.05-retransmits.txt.gz | grep -v 'at 47' | wc -l")+0
npoints10=system("gzcat peer2-proba0.10-retransmits.txt.gz | grep -v 'at 47' | wc -l")+0
plot \
"< gzcat peer2-proba0.01-retransmits.txt.gz | grep -v 'at 47'" using 10:(1./npoints1) smooth cumulative with linespoints title 'α=0.01', \
"< gzcat peer2-proba0.05-retransmits.txt.gz | grep -v 'at 47'" using 10:(1./npoints5) smooth cumulative with linespoints title 'α=0.05', \
"< gzcat peer2-proba0.10-retransmits.txt.gz | grep -v 'at 47'" using 10:(1./npoints10) smooth cumulative with linespoints title 'α=0.10'

pause mouse keypress
EOF





### ADAPTIVE POLICY ###
## Link usage for source->core ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_gilbert_elliott_peer_epsilongreedyinsubtree_link_src_to_core.pdf'
set xlabel "Average loss probability (α)"
set ylabel "Average link usage (b/s)"
set yrange [0:1200000000.]
set key bottom right
factor=8/4 #4 seconds

plot 'peer-epsilon-greedy-all-mc-traffic.txt' using 1:($50*factor) with linespoints title 'BIER-PEER ε-greedy, source to core link' ls 1, \
'peer-somedestswithgoodlinks-all-mc-traffic.txt' using 1:($50*factor) with linespoints title 'BIER-PEER random, source to core link' ls 3, \
'bier-somedestswithgoodlinks-all-mc-traffic.txt' using 1:($50*factor) with linespoints title 'BIER, source to core link' ls 2


pause mouse keypress
EOF




## Retransmissions by source ##
gnuplot -persist  << "EOF"
set grid
set terminal qt font "Helvetica,15" size 640,240
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_gilbert_elliott_peer_epsilongreedyinsubtree_source_retransmissions.pdf'
set xlabel "Average loss probability (α)"
set ylabel "Source retransmissions"
#set xrange [-0.5:19]
set yrange [0:2.5e5]
set xtics rotate
set style fill solid 0.4
set boxwidth 0.28
set key left

plot 'peer-epsilon-greedy-peer-to-src-ratio.txt' using (column(0)):2 every ::9 with boxes title 'BIER-PEER ε-greedy' ls 1, \
'peer-somedestswithgoodlinks-peer-to-src-ratio.txt' using (column(0)+0.28):2:xtic(1) every ::9 with boxes title 'BIER-PEER random' ls 3, \
"bier-somedestswithgoodlinks-peer-to-src-ratio.txt" using (column(0)+0.56):2 every ::9 with boxes title 'BIER' ls 2, \

pause mouse keypress
EOF


## Epsilon-greedy: what destinations are picked ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_gilbert_elliott_peer_epsilongreedyinsubtree_proba0_10_picks.pdf'
set xlabel "Peer identifier"
set ylabel "Number of times\npeer is chosen"

set xtics rotate
set style fill solid 0.4
set xrange [-0.75:39.75]

plot "peer-epsilon-greedy-proba0.10-epsilon_greedy_picks.txt" using (column(0)):2 with boxes title 'BIER-PEER ε-greedy' ls 1

pause mouse keypress
EOF





## ISP TOPOLOGY ###

## Link usage for source->core ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_bt_gilbert_elliott_link_src_to_core.pdf'
set xlabel "Average loss probability (α)"
set ylabel "Average link usage (b/s)"
set yrange [0:1200000000.]
set key bottom right
factor=8/4 #4 seconds

plot 'peer-epsilongreedy-all-mc-traffic-bt-europe.txt' using 1:($5*factor) with linespoints title 'BIER-PEER ε-greedy, source to core link' ls 1, \
'peer-random-all-mc-traffic-bt-europe.txt' using 1:($5*factor) with linespoints title 'BIER-PEER random, source to core link' ls 3, \
'bier-all-mc-traffic-bt-europe.txt' using 1:($5*factor) with linespoints title 'BIER, source to core link' ls 2, \

pause mouse keypress
EOF



## Retransmissions by source ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_bt_gilbert_elliott_source_retransmissions.pdf'
set xlabel "Average loss probability (α)"
set ylabel "Source retransmissions"
#set xrange [-0.5:19]
set yrange [0:2.5e5]
set xtics rotate
set style fill solid 0.4
set boxwidth 0.28
set key left

plot 'peer-epsilongreedy-peer-to-src-ratio-bt-europe.txt' using (column(0)):2 every ::9 with boxes title 'BIER-PEER ε-greedy' ls 1, \
'peer-random-peer-to-src-ratio-bt-europe.txt' using (column(0)+0.28):2:xtic(1) every ::9 with boxes title 'BIER-PEER random' ls 3, \
"bier-peer-to-src-ratio-bt-europe.txt" using (column(0)+0.56):2 every ::9 with boxes title 'BIER' ls 2, \


pause mouse keypress
EOF

## Where do retransmissions come from ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_bt_gilbert_elliott_proba0_10_random_epsilon_greedy_peers_contribution.pdf'
set xlabel "Peer identifier"
set ylabel "Packets recovered\nthanks to peer"
set xtics rotate
set style fill solid 0.4
set xrange [0.25:24.75]
set yrange [0:45000]
set key left

set multiplot layout 1,2


set size 0.55,1 
plot "peer-random-proba0.10-recoveries-bt-europe.txt" using ($1-23):2 with boxes title 'Random' ls 3
unset ylabel
set format y ""
set size 0.44,1 
set orig 0.54,0 
plot "peer-epsilongreedy-proba0.10-recoveries-bt-europe.txt" using ($1-23):2 with boxes title 'ε-greedy' ls 1

pause mouse keypress
EOF




### Number of destinations in bier bitstrings##
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'results_bt_gilbert_elliott_epsilongreedy_bitstrings.pdf'
set ylabel "CDF"
set yrange [0:1]
#set xrange [0:10]
set key bottom right

set multiplot layout 1,2

set xlabel "# of destinations in source bitstrings"
npoints1=system("gzcat peer-epsilongreedy-proba0.01-retransmits-bt-europe.txt.gz | grep  'at 34' | wc -l")+0
npoints5=system("gzcat peer-epsilongreedy-proba0.05-retransmits-bt-europe.txt.gz | grep  'at 34' | wc -l")+0
npoints10=system("gzcat peer-epsilongreedy-proba0.10-retransmits-bt-europe.txt.gz | grep  'at 34' | wc -l")+0
plot \
"< gzcat peer-epsilongreedy-proba0.01-retransmits-bt-europe.txt.gz | grep  'at 34'" using 10:(1./npoints1) smooth cumulative with linespoints title 'α=0.01', \
"< gzcat peer-epsilongreedy-proba0.05-retransmits-bt-europe.txt.gz | grep  'at 34'" using 10:(1./npoints5) smooth cumulative with linespoints title 'α=0.05', \
"< gzcat peer-epsilongreedy-proba0.10-retransmits-bt-europe.txt.gz | grep  'at 34'" using 10:(1./npoints10) smooth cumulative with linespoints title 'α=0.10'


set xrange [0:5]
set xlabel "# of destinations in peer bitstrings"
set key bottom right
npoints1=system("gzcat peer-epsilongreedy-proba0.01-retransmits-bt-europe.txt.gz | grep -v 'at 34' | wc -l")+0
npoints5=system("gzcat peer-epsilongreedy-proba0.05-retransmits-bt-europe.txt.gz | grep -v 'at 34' | wc -l")+0
npoints10=system("gzcat peer-epsilongreedy-proba0.10-retransmits-bt-europe.txt.gz | grep -v 'at 34' | wc -l")+0
plot \
"< gzcat peer-epsilongreedy-proba0.01-retransmits-bt-europe.txt.gz | grep -v 'at 34'" using 10:(1./npoints1) smooth cumulative with linespoints title 'α=0.01', \
"< gzcat peer-epsilongreedy-proba0.05-retransmits-bt-europe.txt.gz | grep -v 'at 34'" using 10:(1./npoints5) smooth cumulative with linespoints title 'α=0.05', \
"< gzcat peer-epsilongreedy-proba0.10-retransmits-bt-europe.txt.gz | grep -v 'at 34'" using 10:(1./npoints10) smooth cumulative with linespoints title 'α=0.10'

pause mouse keypress
EOF


## Centrality of peers ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 320/72.,240/72.
set output 'bt_europe_centrality.pdf'
set xlabel "Peer identifier"
set ylabel "Centrality"

set xtics rotate
set style fill solid 0.4
set xrange [0.25:24.75]

plot "bt_europe_centrality.csv" using (column(0)+1):2 with boxes title '' ls 1

pause mouse keypress
EOF

