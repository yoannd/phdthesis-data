#!/bin/bash



### ISP SIMULATIONS ###
## Link source -> its router (London) ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'bt_europe_link_src_usage.pdf'
set xlabel "Time (s)"
set ylabel "Link usage (b/s)"
set xrange [0:4]
set key bottom right
factor=8*(1/0.01)

plot 'bier-mc-traffic-bt-europe.txt' using ($1-6):($29*factor) with lines title 'BIER retransmissions, source to router 17 link' ls 1, \
'unicast-mc-traffic-bt-europe.txt' using ($1-6):($29*factor) with lines title 'Unicast retransmissions, source to router 17 link' ls 2, \
'multicast-mc-traffic-bt-europe.txt' using ($1-6):($29*factor) with lines title 'Multicast retransmissions, source to router 17 link' ls 3
pause mouse keypress
EOF


## Link 17 -> 5 (London to Frankfurt) ## 
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'bt_europe_link_1sthop_usage.pdf'
set xlabel "Time (s)"
set ylabel "Link usage (b/s)"
set xrange [0:4]
set key bottom right
factor=8*(1/0.01)

plot 'bier-mc-traffic-bt-europe.txt' using ($1-6):($79*factor) with lines title 'BIER retransmissions, example 1st hop link' ls 1, \
'unicast-mc-traffic-bt-europe.txt' using ($1-6):($79*factor) with lines title 'Unicast retransmissions, example 1st hop link' ls 2, \
'multicast-mc-traffic-bt-europe.txt' using ($1-6):($79*factor) with lines title 'Multicast retransmissions, example 1st hop link' ls 3
pause mouse keypress

EOF


## Delivery ratio ##
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'bt_europe_delivery_ratio.pdf'
set xlabel "Node identifier"
set ylabel "Delivery ratio"
set yrange [0:1.4]
set key right
set style fill solid 0.4
set boxwidth 0.3
npoints=system("sort -k2 -n bier-delivery-intra-rack.txt | tail -n 1 | awk '{print $2}'")+0. ##use the one from intra rack to get all points
plot 'bier-delivery-bt-europe.txt' using ($1):($2/npoints) with boxes title 'BIER retransmissions' ls 1, \
'multicast-delivery-bt-europe.txt' using ($1+0.3):($2/npoints):xtic(1) with boxes title 'Multicast retransmissions' ls 3, \
'unicast-delivery-bt-europe.txt' using ($1+0.6):($2/npoints) with boxes title 'Unicast retransmissions' ls 2, \

pause mouse keypress
EOF




# CDF of BIER retransmits ##
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'bt_europe_bier_retransmits.pdf'
set xlabel "# of destinations"
set ylabel "CDF"
set yrange [0:1.2]
set xrange [0:19]
set key left
npoints=system("gzcat bier-retransmits-bt-europe.txt.gz | wc -l")+0
plot '<gzcat bier-retransmits-bt-europe.txt.gz' using 10:(1./npoints) smooth cumulative with linespoints title 'BIER retransmits'

pause mouse keypress
EOF



## UNCORRELATED LOCALISED LOSSES ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 540/72.,240/72.
set output 'intra_rack_link_1sthop_usage_1.pdf'
set xlabel "Time (s)"
set ylabel "Link usage (b/s)"
set xrange [0:4]
set key bottom right
factor=1515./1458.*8*(1/0.01) #fix post-process.sh not taking IP headers into account :/

plot 'bier-mc-traffic-intra-rack.txt' using ($1-6):($84*factor) with lines title 'BIER retransmissions, core link #1' ls 1, \
'unicast-mc-traffic-intra-rack.txt' using ($1-6):($84*factor) with lines title 'Unicast retransmissions, core link #1' ls 2, \
'multicast-mc-traffic-intra-rack.txt' using ($1-6):($84*factor) with lines title 'Multicast retransmissions, core link #1' ls 3

pause mouse keypress
EOF

gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 540/72.,240/72.
set output 'intra_rack_link_1sthop_usage_2.pdf'
set xlabel "Time (s)"
set ylabel "Link usage (b/s)"
set xrange [0:4]
set key bottom right
factor=1515./1458.*8*(1/0.01) #fix post-process.sh not taking IP headers into account :/

plot 'bier-mc-traffic-intra-rack.txt' using ($1-6):($9*factor) with lines title 'BIER retransmissions, core link #2' ls 1, \
'unicast-mc-traffic-intra-rack.txt' using ($1-6):($9*factor) with lines title 'Unicast retransmissions, core link #2' ls 2, \
'multicast-mc-traffic-intra-rack.txt' using ($1-6):($9*factor) with lines title 'Multicast retransmissions, core link #2' ls 3

pause mouse keypress
EOF


gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'intra_rack_delivery_ratio.pdf'
set xlabel "Node identifier"
set ylabel "Delivery ratio"
#set xrange [2:13]
set yrange [0:1.4]
set key right
set style fill solid 0.4
set boxwidth 0.3

npoints=system("sort -k2 -n bier-delivery-intra-rack.txt | tail -n 1 | awk '{print $2}'")+0.
plot 'bier-delivery-intra-rack.txt' using ($1):($2/npoints) with boxes title 'BIER retransmissions' ls 1, \
'unicast-delivery-intra-rack.txt' using ($1+0.3):($2/npoints):xtic(1) with boxes title 'Unicast retransmissions' ls 2, \
'multicast-delivery-intra-rack.txt' using ($1+0.6):($2/npoints) with boxes title 'Multicast retransmissions' ls 3

pause mouse keypress
EOF



gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'intra_rack_bier_retransmits.pdf'
set xlabel "# of destinations"
set ylabel "CDF"
set yrange [0:1.2]
set key left
npoints=system("gzcat bier-retransmits-intra-rack.txt.gz | wc -l")+0
plot '<gzcat bier-retransmits-intra-rack.txt.gz' using 10:(1./npoints) smooth cumulative with linespoints title 'BIER retransmits'

pause mouse keypress
EOF

## CORRELATED LOCALISED LOSSES ##

gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 540/72.,240/72.
set output 'inter_rack_link_1sthop_usage_1.pdf'
set xlabel "Time (s)"
set ylabel "Link usage (b/s)"
set xrange [0:4]
set key bottom right
factor=1515./1458.*8*(1/0.01) #fix post-process.sh not taking IP headers into account :/

plot 'bier-mc-traffic-inter-rack.txt' using ($1-6):($84*factor) with lines title 'BIER retransmissions, core link #1' ls 1, \
'unicast-mc-traffic-inter-rack.txt' using ($1-6):($84*factor) with lines title 'Unicast retransmissions, core link #1' ls 2, \
'multicast-mc-traffic-inter-rack.txt' using ($1-6):($84*factor) with lines title 'Multicast retransmissions, core link #1' ls 3

pause mouse keypress
EOF


gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 540/72.,240/72.
set output 'inter_rack_link_1sthop_usage_2.pdf'
set xlabel "Time (s)"
set ylabel "Link usage (b/s)"
set xrange [0:4]
set key bottom right
factor=1515./1458.*8*(1/0.01) #fix post-process.sh not taking IP headers into account :/

plot 'bier-mc-traffic-inter-rack.txt' using ($1-6):($9*factor) with lines title 'BIER retransmissions, core link #2' ls 1, \
'unicast-mc-traffic-inter-rack.txt' using ($1-6):($9*factor) with lines title 'Unicast retransmissions, core link #2' ls 2, \
'multicast-mc-traffic-inter-rack.txt' using ($1-6):($9*factor) with lines title 'Multicast retransmissions, core link #2' ls 3

pause mouse keypress
EOF


gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'inter_rack_delivery_ratio.pdf'
set xlabel "Node identifier"
set ylabel "Delivery ratio"
#set xrange [0:22]
set yrange [0:1.4]
set key right
set style fill solid 0.4 #pattern border
set boxwidth 0.3
npoints=system("sort -k2 -n bier-delivery-intra-rack.txt | tail -n 1 | awk '{print $2}'")+0. #use the one from intra rack to get all points
plot 'bier-delivery-inter-rack.txt' using ($1):($2/npoints) with boxes title 'BIER retransmissions' ls 1, \
'multicast-delivery-inter-rack.txt' using ($1+0.3):($2/npoints):xtic(1) with boxes title 'Multicast retransmissions' ls 3, \
'unicast-delivery-inter-rack.txt' using ($1+0.6):($2/npoints) with boxes title 'Unicast retransmissions' ls 2, \

pause mouse keypress
EOF

gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'inter_rack_bier_retransmits.pdf'
set xlabel "# of destinations"
set ylabel "CDF"
set yrange [0:1.2]
set xrange [0:32]
set key left
npoints=system("gzcat bier-retransmits-inter-rack.txt.gz | wc -l")+0
plot '<gzcat bier-retransmits-inter-rack.txt.gz' using 10:(1./npoints) smooth cumulative with linespoints title 'BIER retransmits'

pause mouse keypress
EOF


## UNLOCALISED BURSTY LOSSES ##

gnuplot -persist << "EOF"
set grid
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'gilbert_elliott_bier_retransmits.pdf'
set xlabel "# of destinations"
set ylabel "CDF"
set yrange [0:1]
set xrange [0:20]
set key bottom right
npoints1=system("gzcat bier-proba0.01-retransmits-gilbert-elliott.txt.gz | wc -l")+0
npoints2=system("gzcat bier-proba0.02-retransmits-gilbert-elliott.txt.gz | wc -l")+0
npoints3=system("gzcat bier-proba0.03-retransmits-gilbert-elliott.txt.gz | wc -l")+0
npoints4=system("gzcat bier-proba0.04-retransmits-gilbert-elliott.txt.gz | wc -l")+0
npoints5=system("gzcat bier-proba0.05-retransmits-gilbert-elliott.txt.gz | wc -l")+0
npoints6=system("gzcat bier-proba0.06-retransmits-gilbert-elliott.txt.gz | wc -l")+0
npoints7=system("gzcat bier-proba0.07-retransmits-gilbert-elliott.txt.gz | wc -l")+0
npoints8=system("gzcat bier-proba0.08-retransmits-gilbert-elliott.txt.gz | wc -l")+0
npoints9=system("gzcat bier-proba0.09-retransmits-gilbert-elliott.txt.gz | wc -l")+0
npoints10=system("gzcat bier-proba0.10-retransmits-gilbert-elliott.txt.gz | wc -l")+0
plot \
'<gzcat bier-proba0.01-retransmits-gilbert-elliott.txt.gz' using 10:(1./npoints1) smooth cumulative with linespoints title 'α=0.01', \
'<gzcat bier-proba0.02-retransmits-gilbert-elliott.txt.gz' using 10:(1./npoints2) smooth cumulative with linespoints title 'α=0.02', \
'<gzcat bier-proba0.03-retransmits-gilbert-elliott.txt.gz' using 10:(1./npoints3) smooth cumulative with linespoints title 'α=0.03', \
'<gzcat bier-proba0.04-retransmits-gilbert-elliott.txt.gz' using 10:(1./npoints4) smooth cumulative with linespoints title 'α=0.04', \
'<gzcat bier-proba0.05-retransmits-gilbert-elliott.txt.gz' using 10:(1./npoints5) smooth cumulative with linespoints title 'α=0.05', \
'<gzcat bier-proba0.06-retransmits-gilbert-elliott.txt.gz' using 10:(1./npoints6) smooth cumulative with linespoints title 'α=0.06', \
'<gzcat bier-proba0.07-retransmits-gilbert-elliott.txt.gz' using 10:(1./npoints7) smooth cumulative with linespoints title 'α=0.07', \
'<gzcat bier-proba0.08-retransmits-gilbert-elliott.txt.gz' using 10:(1./npoints8) smooth cumulative with linespoints title 'α=0.08', \
'<gzcat bier-proba0.09-retransmits-gilbert-elliott.txt.gz' using 10:(1./npoints9) smooth cumulative with linespoints title 'α=0.09', \
'<gzcat bier-proba0.10-retransmits-gilbert-elliott.txt.gz' using 10:(1./npoints10) smooth cumulative with linespoints title 'α=0.10'

pause mouse keypress
EOF



gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'gilbert_elliott_delivery_ratio.pdf'
set xlabel "Average loss probability (α)"
set ylabel "Average delivery ratio"
set yrange [0:1.4]
set xrange [-0.5:19]
set xtics rotate
set style fill solid 0.4
set boxwidth 0.28

npoints=system("head -n 1 bier-all-delivery-gilbert-elliott.txt | awk '{print $2}'")+0
plot "bier-all-delivery-gilbert-elliott.txt" using (column(0)):($2/npoints) with boxes title 'BIER retransmissions' ls 1, \
"multicast-all-delivery-gilbert-elliott.txt" using (column(0)+0.28):($2/npoints):xtic(1) with boxes title 'Multicast retransmissions' ls 3, \
"unicast-all-delivery-gilbert-elliott.txt" using (column(0)+0.56):($2/npoints) with boxes title 'Unicast retransmissions' ls 2, \
"< echo 8.78 1.4" with impulse title '' ls 0 dt 2

pause mouse keypress
EOF






gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'gilbert_elliott_link_src_usage.pdf'
set xlabel "Average loss probability (α)"
set ylabel "Average link usage (b/s)"
set yrange [0:1200000000.]
set key bottom right
factor=8/4 #4 seconds

plot 'bier-all-mc-traffic-gilbert-elliott.txt' using ($1):($50*factor) with linespoints title 'BIER retransmissions, source to core link' ls 1, \
'unicast-all-mc-traffic-gilbert-elliott.txt' using ($1):($50*factor) with linespoints title 'Unicast retransmissions, source to core link' ls 2, \
'multicast-all-mc-traffic-gilbert-elliott.txt' using ($1):($50*factor) with linespoints title 'Multicast retransmissions, source to core link' ls 3
pause mouse keypress
EOF

gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'gilbert_elliott_link_agg_usage.pdf'
set xlabel "Average loss probability (α)"
set ylabel "Aggregate multicast traffic (bytes)"
set yrange [0:25000000000.]
set key bottom right
factor=1


plot "< awk '{s=0;for(i=1;i<=NF;i++)s+=$i;print $1,s;}' bier-all-mc-traffic-gilbert-elliott.txt" using ($1):($2*factor) with linespoints title 'BIER retransmissions' ls 1, \
"< awk '{s=0;for(i=1;i<=NF;i++)s+=$i;print $1,s;}' unicast-all-mc-traffic-gilbert-elliott.txt" using ($1):($2*factor) with linespoints title 'Unicast retransmissions' ls 2, \
"< awk '{s=0;for(i=1;i<=NF;i++)s+=$i;print $1,s;}' multicast-all-mc-traffic-gilbert-elliott.txt" using ($1):($2*factor) with linespoints title 'Multicast retransmissions' ls 3

pause mouse keypress
EOF

gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'gilbert_elliott_link_src_usage_deltatagg_alpha_0_01.pdf'
set xlabel "NACK aggregation delay (ms)" 
set ylabel "Link usage (b/s)"
set yrange [5e8:10e8]
set xrange [-1.5:11.5]
set boxwidth 0.7
set style fill solid 0.4
factor=2
plot "< cat bier-all-mc-traffic-gilbert-elliott-alpha0.01.txt | tail -n 12" using (column(0)):(\$50*factor):xtic(1) with boxes title 'BIER retransmissions, α=0.01' ls 1, \
"< cat bier-all-mc-traffic-gilbert-elliott-alpha0.01.txt | head -n 1" using (column(0)-1):(\$50*factor):xtic(1) with boxes title 'Unicast retransmissions, α=0.01' ls 2

pause mouse keypress
EOF

gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'gilbert_elliott_link_src_usage_deltatagg_alpha_0_008.pdf'
set xlabel "NACK aggregation delay (ms)"
set ylabel "Link usage (b/s)"
set yrange [5e8:10e8]
set xrange [-1.5:11.5]
set boxwidth 0.7
set style fill solid 0.4
factor=2

set yrange [5e8:10e8]
plot "< cat bier-all-mc-traffic-gilbert-elliott-alpha0.008.txt | tail -n 12" using (column(0)):(\$50*factor):xtic(1) with boxes title 'BIER retransmissions, α=0.008' ls 1, \
"< cat bier-all-mc-traffic-gilbert-elliott-alpha0.008.txt | head -n 1" using (column(0)-1):(\$50*factor):xtic(1) with boxes title 'Unicast retransmissions, α=0.008' ls 2, \


pause mouse keypress
EOF

### ISP SIMULATIONS ###
## Link source -> its router (London) ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'bt_europe_link_src_usage.pdf'
set xlabel "Time (s)"
set ylabel "Link usage (b/s)"
set xrange [0:4]
set key bottom right
factor=8*(1/0.01)

plot 'bier-mc-traffic-bt-europe.txt' using ($1-6):($29*factor) with lines title 'BIER retransmissions, source to router 17 link' ls 1, \
'unicast-mc-traffic-bt-europe.txt' using ($1-6):($29*factor) with lines title 'Unicast retransmissions, source to router 17 link' ls 2, \
'multicast-mc-traffic-bt-europe.txt' using ($1-6):($29*factor) with lines title 'Multicast retransmissions, source to router 17 link' ls 3
pause mouse keypress
EOF


## Link 17 -> 5 (London to Frankfurt) ## 
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'bt_europe_link_1sthop_usage.pdf'
set xlabel "Time (s)"
set ylabel "Link usage (b/s)"
set xrange [0:4]
set key bottom right
factor=8*(1/0.01)

plot 'bier-mc-traffic-bt-europe.txt' using ($1-6):($79*factor) with lines title 'BIER retransmissions, example 1st hop link' ls 1, \
'unicast-mc-traffic-bt-europe.txt' using ($1-6):($79*factor) with lines title 'Unicast retransmissions, example 1st hop link' ls 2, \
'multicast-mc-traffic-bt-europe.txt' using ($1-6):($79*factor) with lines title 'Multicast retransmissions, example 1st hop link' ls 3
pause mouse keypress

EOF


## Delivery ratio ##
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'bt_europe_delivery_ratio.pdf'
set xlabel "Node identifier"
set ylabel "Delivery ratio"
set yrange [0:1.4]
set key right
set style fill solid 0.4
set boxwidth 0.3
npoints=system("sort -k2 -n bier-delivery-intra-rack.txt | tail -n 1 | awk '{print $2}'")+0. ##use the one from intra rack to get all points
plot 'bier-delivery-bt-europe.txt' using ($1):($2/npoints) with boxes title 'BIER retransmissions' ls 1, \
'multicast-delivery-bt-europe.txt' using ($1+0.3):($2/npoints):xtic(1) with boxes title 'Multicast retransmissions' ls 3, \
'unicast-delivery-bt-europe.txt' using ($1+0.6):($2/npoints) with boxes title 'Unicast retransmissions' ls 2, \

pause mouse keypress
EOF




# CDF of BIER retransmits ##
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'bt_europe_bier_retransmits.pdf'
set xlabel "# of destinations"
set ylabel "CDF"
set yrange [0:1.2]
set xrange [0:19]
set key left
npoints=system("gzcat bier-retransmits-bt-europe.txt.gz | wc -l")+0
plot '<gzcat bier-retransmits-bt-europe.txt.gz' using 10:(1./npoints) smooth cumulative with linespoints title 'BIER retransmits'

pause mouse keypress
EOF


### ANALYTICAL MODEL ###

gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'all_dests_1_2_2_10.pdf'
set xlabel "Link loss probability (α)"
set ylabel "Packets transmitted"
set xrange [0:0.01]
set key left

plot \
NaN title 'Approximation' ls -1 dt 2, \
NaN title 'Exact' ls -1 dt 1, \
"simul_1,2,2,10_bier.csv" using 1:2 title 'BIER retransmissions' with linespoints ls 1, \
47+177.*x title '' with lines ls 1 dt 2, \
"simul_1,2,2,10_unicast.csv" using 1:2 title 'Unicast retransmissions' with linespoints ls 2, \
47+510.*x title '' with lines ls 2 dt 2, \
"simul_1,2,2,10_flood.csv" using 1:2 title 'Multicast retransmissions' with linespoints ls 3, \
47+2079.*x title '' with lines ls 3 dt 2

#order 2: 47+177*x-1122*x**2

pause mouse keypress
EOF

gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,240/72.
set output 'all_dests_2_2.pdf'
set xlabel "Link loss probability (α)"
set ylabel "Packets transmitted"
set xrange [0:0.5]
set key left


plot \
"reliable_c2d2.csv" using 1:2 title 'BIER retransmissions' with lines ls 1 lw 1.5, \
"reliable_c2d2.csv" using 1:4 title 'Unicast retransmissions' with lines ls 2 lw 1, \
"reliable_c2d2.csv" using 1:3 title 'Multicast retransmissions' with lines ls 3 lw 0.5, \
#6+10*x title '' ls 1 dt 3, \
#6+12*x title '' ls 2 dt 3, \
#6+32*x title '' ls 3 dt 3

pause mouse keypress
EOF

