#!/bin/bash


##### CONSISTENT HASHING #####
gnuplot -persist << EOF
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'results_consistent_hash_65537_1000_1vs2_200.pdf'
set grid
set xlabel "Number of servers removed"
set ylabel "Failure rate (%)"
set xrange [0:30]
set yrange [0:4]

plot 'results_65537_1000_1vs2_200.txt' using (\$1*1000):(\$2*100) with linespoints title '1 choice' ls 1, \
'results_65537_1000_1vs2_200.txt' using (\$1*1000):(\$4*100) with linespoints title '2 choices' ls 4
pause mouse keypress
EOF
 



##### ANALYTICAL MODEL #####
######## E(T) #######
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'waiting_time_two_choices.pdf'
set xrange [0:1]
set yrange [0:20]
set xlabel "Normalized request rate λ"
set ylabel "Expected response time (in units of 1/μ)"
set key left Left reverse

plot \
1/(1-x) with lines dt 2 lw 2 title 'SC',  \
'c2.csv' using 1:($2)  title 'SR 2' with lines ls 7,  \
'c4.csv' using 1:($2)  title 'SR 4' with lines ls 4,  \
'c8.csv' using 1:($2)  title 'SR 8' with lines ls 2

pause mouse keypress
EOF

######## E(T) with delay #######
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'waiting_time_two_choices_with_delay.pdf'
set xrange [0:1]
set yrange [0:20]
set xlabel "Normalized request rate λ"
set ylabel "Expected response time (in units of 1/μ)"
set key left Left reverse

delay = 1
plot \
1/(1-x) with lines dt 2 lw 2 title 'SC',  \
'c2.csv' using 1:($2+delay*$3)  title 'SR 2' with lines ls 7,  \
'c4.csv' using 1:($2+delay*$3)  title 'SR 4' with lines ls 4,  \
'c8.csv' using 1:($2+delay*$3)  title 'SR 8' with lines ls 2

pause mouse keypress
EOF


######## Fairness index #######
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'fairness_index_two_choices.pdf'
set xrange [0:1]
set yrange [0:1]
set xlabel "Normalized request rate λ"
set ylabel "Fairness index"
set key left Left reverse

plot \
x/(1+x) with lines dt 2 lw 2 title 'SC',  \
'eofnsquared_c2.csv' using 1:($2**2/$3)  title 'SR 2' with lines ls 7,  \
'eofnsquared_c4.csv' using 1:($2**2/$3)  title 'SR 4' with lines ls 4,  \
'eofnsquared_c8.csv' using 1:($2**2/$3)  title 'SR 8' with lines ls 2

pause mouse keypress
EOF

######## Probability of wrongful rejection #######
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'proba_wrongful_rejection.pdf'
set xrange [0:1]
set yrange [0:0.5]
set xlabel "Normalized request rate λ"
set ylabel "Probability of wrongful rejection"
set key left Left reverse

plot \
'c2.csv' using 1:($1*$3**3/(1+$1*$3))  title 'SR 2' with lines ls 7,  \
'c4.csv' using 1:($1*$3**3/(1+$1*$3))  title 'SR 4' with lines ls 4,  \
'c8.csv' using 1:($1*$3**3/(1+$1*$3))  title 'SR 8' with lines ls 2

pause mouse keypress
EOF

######## 90-th percentile for T #######
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'ninth_decile_two_choices.pdf'
set xrange [0:1]
set yrange [0:20]
set xlabel "Normalized request rate λ"
set ylabel "90-th percentile response time (in units of 1/μ)"
set key left Left reverse

plot \
log(10)/(1-x) with lines dt 2 lw 2 title 'SC',  \
'ninth_decile_c2.csv' using 1:($2)  title 'SR 2' with lines ls 7,  \
'ninth_decile_c4.csv' using 1:($2)  title 'SR 4' with lines ls 4,  \
'ninth_decile_c8.csv' using 1:($2)  title 'SR 8' with lines ls 2


pause mouse keypress
EOF


######## Reduction in number of servers (target 90-th percentile) #######
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'servers_needed_relative.pdf'
set xrange [0:20]
set yrange [0.7:1.1]
set xlabel "Target 90-th percentile response time (in units of 1/μ)"
set ylabel "Number of servers needed\nas compared to SC"

plot \
1 with lines dt 2 lw 2 title 'SC',  \
'ninth_decile_c4.csv' using 2:( (1-log(10)/$2)/$1)  title 'SR 4' with lines ls 4

pause mouse keypress
EOF


##### VPP EXPERIMENTS #####
### CDF of response time for lamba=0.88 ###
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'cdf_0_88_two_choices.pdf'
set xlabel "Response time (in units of 1/μ)"
set ylabel "CDF"
set xrange [0:20]
set yrange [0:1.2]
set key left

plot \
'cdf_1_0.88.csv' using 1:3 title 'SC' with lines dt 2 lw 2, \
'cdf_2_0.88.csv' using 1:2 title 'SR 2' with lines ls 7, \
'cdf_4_0.88.csv' using 1:2 title 'SR 4' with lines ls 4, \
'cdf_8_0.88.csv' using 1:2 title 'SR 8' with lines ls 2

pause mouse keypress
EOF

## Mean response time (poisson) ##
gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_48_servers_exp_mean.pdf'
set xlabel "Normalized request rate ρ"
set ylabel "Mean response time (s)"
set xrange [0:1]
set yrange [0:3]
set key left

a=8.74 
b=0.156
d=0.020

plot \
'results_48_servers_exp_mean.txt' using (\$2/a):(\$4) title 'SC' with linespoints ls 1, \
'results_48_servers_exp_mean.txt' using (\$2/a):(\$8) title 'SR 4' with linespoints ls 4, \
'results_48_servers_exp_mean.txt' using (\$2/a):(\$12) title 'SR 8' with linespoints ls 2, \
'results_48_servers_exp_mean.txt' using (\$2/a):(\$16) title 'SR 16' with linespoints ls 6, \
'results_48_servers_exp_mean.txt' using (\$2/a):(\$20) title 'SR dyn' with linespoints ls 8, \
'c1.csv' using (\$1):(d+b*(1/(1-\$1))) title '' with lines ls 1 lw 0.75 dt 3, \
'c4.csv' using (\$1):(d+b*(\$2)) title '' with lines ls 4 lw 0.75 dt 3, \
'c8.csv' using (\$1):(d+b*(\$2)) title '' with lines ls 2 lw 0.75 dt 3, \
'c16.csv' using (\$1):(d+b*(\$2)) title '' with lines ls 6 lw 0.75 dt 3


pause mouse keypress
EOF

## VPP throughput ##
gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'results_vpp_throughput.pdf'
set xlabel "Number of flows"
set ylabel "Forwarding performance (Mpps)"
set xtics rotate by 45 right
set boxwidth 0.30
set yrange [0:10]
set style fill solid 0.4

plot \
'results_vpp_throughput.txt' using (column(0)+0.30):(\$3/1000000.) title 'SC' with boxes ls 1, \
'results_vpp_throughput.txt' using (column(0)+0.60):(\$2/1000000.):xtic(1) title '6LB' with boxes ls 4
#'results_vpp_throughput.txt' using (column(0)):(\$4/1000000.) title 'Forward' with boxes ls 3, \


pause mouse keypress
EOF


## Reduction of number of servers (rho=0.71)##
gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'results_48_servers_exp_server_reduction_0_71.pdf'
set xlabel "Number of VMs"
set ylabel "Mean response time (s)"
set xrange [36:48]
set yrange [0:1.5]

plot \
'<printf "0 0.582\n48 0.582"' using 1:2 title 'SC, 48 VMs' with lines ls 1 dt 2 lw 2, \
'results_48_servers_exp_server_reduction.txt' using 1:4 title 'SR 4, 36..48 VMs' with linespoints ls 4, \
'<echo 40 99' with impulse title '' ls 4 dt 2

pause mouse keypress
EOF

## Consistent hash table size influence (rho=0.89) ##
gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'results_48_servers_exp_cons_hashing_0_89.pdf'
set xlabel "Number of buckets"
set ylabel "Mean response time (s)"
set logscale x 2
set xrange [64:131072]
set yrange [0:3]

plot \
'<printf "1 1.405\n131072 1.405"' using 1:2 title 'SC, 65536 buckets' with lines ls 1 dt 2 lw 2, \
'results_48_servers_exp_cons_hash.txt' using 1:4 title 'SR 4, 64..131072 buckets' with linespoints ls 4


pause mouse keypress
EOF


## Connection resets (1000 long-lived flows, M=4096) ##
gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_48_servers_conn_rsts.pdf'
set xlabel "Number of removed application instances"
set ylabel "% of connection resets"

set key left

plot \
(x*1000/48)/1000*100 title 'Resets due to removed instances' ls 0, \
'results_48_servers_conn_rsts.txt' using 1:( (1000-(\$2+\$3+\$4+\$5+\$6+\$7+\$8+\$9+\$10)/9)/1000*100 ) title 'SC' with linespoints ls 1, \
'' using 1:( (1000-(\$11+\$12+\$13+\$14+\$15+\$16+\$17+\$18+\$19)/9)/1000*100 ) title 'SR' with linespoints ls 4


pause mouse keypress
EOF

## Mean response time (lognormal, rho=0.71, 69μs extra latency at the median) ##
gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'results_48_servers_exp_0_71_latency.pdf'
set xlabel "SYN → SYN-ACK latency (μs)"
set ylabel "CDF"
set xrange [0.0:600]
set yrange [0:1.2]
set key horiz
#set termoption dashlength 10

plot \
'<gzcat results_exp_0_74_thresh_maglev.sorted.txt.gz' using (\$1*1000000.):(column(0)/80000) with linespoints ls 1 pointinterval 4000 title 'SC', \
'<gzcat results_exp_0_74_thresh_4.sorted.txt.gz' using (\$1*1000000.):(column(0)/80000) with linespoints ls 4 pointinterval 4000 title 'SR 4, 1st+2nd choice', \
'<gzcat results_exp_0_74_thresh_4.sorted.1stchoice.txt.gz' using (\$1*1000000.):(column(0)/80000) with lines ls 4 dt (2,2,2,2) title 'SR 4, 1st choice', \
'<gzcat results_exp_0_74_thresh_4.sorted.2ndchoice.txt.gz' using (\$1*1000000.):(column(0)/80000) with lines ls 4 dt 3 title 'SR 4, 2nd choice', \


pause mouse keypress
EOF


## Mean response time (centralized) ##
gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_48_servers_exp_mean_centralized.pdf'
set xlabel "Normalized request rate ρ"
set ylabel "Mean response time (s)"
set xrange [0:1]
set yrange [0:3]
set key left

a=8.74 
b=0.156 
d=0.020

plot \
'results_48_servers_exp_mean.txt' using (\$2/a):(\$4) title 'SC' with linespoints ls 1, \
'results_48_servers_exp_mean.txt' using (\$2/a):(\$20) title 'SR dyn' with linespoints ls 8, \
'results_48_servers_exp_mean.txt' using (\$2/a):(\$24) title 'Round-Robin' with linespoints ls 7, \
'results_48_servers_exp_mean.txt' using (\$2/a):(\$28) title 'Round-Robin+feedback' with linespoints ls 2 lc 3

pause mouse keypress
EOF

## Mean response time (lognormal, rho=0.71) ##
gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_48_servers_lognormal_mean.pdf'
set xlabel "Std. dev. of job time (normalized to mean)"
set ylabel "Mean response time (s)"
set xrange [0:0.8]
set yrange [0:3.5]
set key left

plot \
'results_48_servers_lognormal_mean.txt' using (sqrt(exp(\$1**2)-1)):(\$4) title 'SC' with linespoints ls 1, \
'results_48_servers_lognormal_mean.txt' using (sqrt(exp(\$1**2)-1)):(\$8) title 'SR dyn' with linespoints ls 8, \
'results_48_servers_lognormal_mean.txt' using (sqrt(exp(\$1**2)-1)):(\$12) title 'Round-Robin' with linespoints ls 7, \
'results_48_servers_lognormal_mean.txt' using (sqrt(exp(\$1**2)-1)):(\$16) title 'Round-Robin+feedback' with linespoints ls 2 lc 3

pause mouse keypress
EOF

## Server load and fairness (ewma'd) ##
gnuplot -persist << EOF
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_48_servers_load_maglev_vs_sr4_0_89.pdf'
set grid
set multiplot layout 2,1
set key bottom right

set xrange [0:218]
set ylabel "Server load (mean)"

plot '<gzcat log_8.25_maglev.txt.mean.ewma.gz' using (\$1/1000):2 every 100 title 'SC' with lines, \
'<gzcat log_8.25_4.txt.mean.ewma.gz' using (\$1/1000):2 every 100 title 'SR 4' with lines ls 4,

set ylabel "Server load (fairness)"
set xlabel "Time (s)"

plot '<gzcat log_8.25_maglev.txt.fairness.ewma.gz' using (\$1/1000):2 every 100 title 'SC' with lines, \
'<gzcat log_8.25_4.txt.fairness.ewma.gz' using (\$1/1000):2 every 100 title 'SR 4' with lines ls 4

pause mouse keypress
EOF

### CDF Poisson rho=0.71 and 0.89 ###
gnuplot -persist  << EOF
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_48_servers_exp_cdf_0_71_and_0_89.pdf'
set multiplot layout 2,1
set key right bottom

set xlabel "Response time (s)"
set ylabel "CDF"
set xrange [0:4]
set yrange [0:1]
set arrow from 0.384479, 0.2 to 0.726721, 0.2 ls -1 heads
set label "1.89x" at 0.42, 0.15 

npoints=system("gzcat bench_cdf_thresh_maglev_rate_8.25.txt.gz | wc -l")-1
plot \
'<gzcat bench_cdf_thresh_maglev_rate_8.25.txt.gz' using 1:2 every (npoints/100) title 'SC' with linespoints ls 1 pointinterval 5, \
'<gzcat bench_cdf_thresh_4_rate_8.25.txt.gz' using 1:2 every (npoints/100) title 'SR 4' with linespoints ls 4 pointinterval 5, \
'<gzcat bench_cdf_thresh_8_rate_8.25.txt.gz' using 1:2 every (npoints/100) title 'SR 8' with linespoints ls 2 pointinterval 5, \
'<gzcat bench_cdf_thresh_16_rate_8.25.txt.gz' using 1:2 every (npoints/100) title 'SR 16' with linespoints ls 6 pointinterval 5, \
'<gzcat bench_cdf_thresh_-1_rate_8.25.txt.gz' using 1:2 every (npoints/100) title 'SR dyn' with linespoints ls 8 pointinterval 5, \
'<echo 0.726721 0.5; echo 0.384479 0.5' with impulse ls -1 dt 2 title ''

set xrange [0:1.5]
set yrange [0:1]
unset arrow
unset label
set arrow from 0.246765, 0.2 to 0.317417, 0.2 ls -1 heads
set label "1.29x" at 0.229, 0.15 

npoints=system("gzcat bench_cdf_thresh_maglev_rate_6.5.txt.gz | wc -l")-1
plot \
'<gzcat bench_cdf_thresh_maglev_rate_6.5.txt.gz' using 1:2 every (npoints/100) title 'SC' with linespoints ls 1 pointinterval 5, \
'<gzcat bench_cdf_thresh_4_rate_6.5.txt.gz' using 1:2 every (npoints/100) title 'SR 4' with linespoints ls 4 pointinterval 5, \
'<gzcat bench_cdf_thresh_8_rate_6.5.txt.gz' using 1:2 every (npoints/100) title 'SR 8' with linespoints ls 2 pointinterval 5, \
'<gzcat bench_cdf_thresh_16_rate_6.5.txt.gz' using 1:2 every (npoints/100) title 'SR 16' with linespoints ls 6 pointinterval 5, \
'<gzcat bench_cdf_thresh_-1_rate_6.5.txt.gz' using 1:2 every (npoints/100) title 'SR dyn' with linespoints ls 8 pointinterval 5, \
'<echo 0.317417 0.5; echo 0.246765 0.5' with impulse ls -1 dt 2 title ''



pause mouse keypress
EOF


#### WIKIPEDIA REPLAY ####
## Wikipedia: CDF Response time (static+wiki pages)##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_replay_wiki_28_vms_median_maglev_vs_4_vs_dyn.pdf'
set multiplot layout 2,1
set xlabel "Static page load time (ms)"
set ylabel "CDF"
set yrange [0:1]
set xrange [0:100]
set key bottom right

npointsmaglev=system("cat replay_24hrs_maglev_vms_28.txt.staticpages.sorted.1000 | wc -l")+0
npoints4=system("cat replay_24hrs_4_vms_28.txt.staticpages.sorted.1000 | wc -l")+0
npoints1=system("cat replay_24hrs_-1_vms_28.txt.staticpages.sorted.1000 | wc -l")+0


plot \
'<cat replay_24hrs_maglev_vms_28.txt.staticpages.sorted.1000' using ($2*1000):(column(0)/1000.) every (npointsmaglev/1000.) with linespoints title 'SC static pages' ls 1 dt 1 pointinterval 1000./20, \
'<cat replay_24hrs_4_vms_28.txt.staticpages.sorted.1000' using ($2*1000):(column(0)/1000.) every (npoints4/1000.) with linespoints title 'SR 4 static pages' ls 4 dt 1 pointinterval 1000./20, \
'<cat replay_24hrs_-1_vms_28.txt.staticpages.sorted.1000' using ($2*1000):(column(0)/1000.) every (npoints1/1000.) with linespoints title 'SR dyn static pages' ls 8 dt 1 pointinterval 1000./20

set xlabel "Wiki page load time (s)"
set xrange [0:0.8]

npointsmaglev=system("cat replay_24hrs_maglev_vms_28.txt.wikipages.sorted.1000 | wc -l")+0
npoints4=system("cat replay_24hrs_4_vms_28.txt.wikipages.sorted.1000 | wc -l")+0
npoints1=system("cat replay_24hrs_-1_vms_28.txt.wikipages.sorted.1000 | wc -l")+0


plot \
'<cat replay_24hrs_maglev_vms_28.txt.wikipages.sorted.1000' using 2:(column(0)/1000.) every (npointsmaglev/1000.) with linespoints title 'SC wiki pages' ls 1 dt 1 pointinterval 1000./20, \
'<cat replay_24hrs_4_vms_28.txt.wikipages.sorted.1000' using 2:(column(0)/1000.) every (npoints4/1000.) with linespoints title 'SR 4 wiki pages' ls 4 dt 1 pointinterval 1000./20, \
'<cat replay_24hrs_-1_vms_28.txt.wikipages.sorted.1000' using 2:(column(0)/1000.) every (npoints1/1000.) with linespoints title 'SR dyn wiki pages' ls 8 dt 1 pointinterval 1000./20


pause mouse keypress
EOF


## Wikipedia: Median response time ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_replay_wiki_28_vms_cdf_maglev_vs_4_vs_dyn_with_static.pdf'
set multiplot layout 2,1

set xdata time
set xtics 1190146243,14400,1190232643
set format x "%H:%M"
set xlabel "Time of day (UTC)"
set ylabel "Median response time (s)"
set yrange [0.1:0.4]

set origin 0, 0.5
set size 1, 0.5
startTime = 1190146243

plot \
'replay_24hrs_maglev_vms_28.txt.wikipages.deciles' using (startTime+$1):7 with lines title 'SC wiki pages' ls 1 dt 1, \
'replay_24hrs_4_vms_28.txt.wikipages.deciles' using (startTime+$1):7 with lines title 'SR 4 wiki pages' ls 4 dt 1, \
'replay_24hrs_-1_vms_28.txt.wikipages.deciles' using (startTime+$1):7 with lines title 'SR dyn wiki pages' ls 8 dt 1

set origin 0, 0
set size 1, 0.5
set yrange [100:240]
set ylabel "Queries per second"
plot \
'replay_24hrs_maglev_vms_28.txt.wikipages.deciles' using (startTime+$1):($2/600) with lines title 'wiki pages' ls 3 dt 1

pause mouse keypress
EOF




## Wikipedia: Deciles of response time ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,17" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_replay_wiki_28_vms_deciles_maglev_vs_4_vs_dyn.pdf'
set multiplot layout 3,1

set xdata time
set xtics 1190146243,14400,1190232643
set format x "%H:%M"
set xlabel "Time of day (UTC)"
set ylabel "Decile 1-9\nresponse time (s)"
set yrange [0:0.6]

startTime = 1190146243

plot \
'replay_24hrs_maglev_vms_28.txt.wikipages.deciles' using (startTime+$1):3 with lines title 'SC wiki pages' ls 1 dt 1, \
'' using (startTime+$1):4 with lines title '' ls 1 dt 2, \
'' using (startTime+$1):5 with lines title '' ls 1 dt 3, \
'' using (startTime+$1):6 with lines title '' ls 1 dt 4, \
'' using (startTime+$1):7 with lines title '' ls 8 dt 1, \
'' using (startTime+$1):8 with lines title '' ls 1 dt 2, \
'' using (startTime+$1):9 with lines title '' ls 1 dt 3, \
'' using (startTime+$1):10 with lines title '' ls 1 dt 4, \
'' using (startTime+$1):11 with lines title '' ls 1 dt 1, \

plot \
'replay_24hrs_4_vms_28.txt.wikipages.deciles' using (startTime+$1):3 with lines title 'SR 4 wiki pages' ls 4 dt 1, \
'' using (startTime+$1):4 with lines title '' ls 4 dt 2, \
'' using (startTime+$1):5 with lines title '' ls 4 dt 3, \
'' using (startTime+$1):6 with lines title '' ls 4 dt 4, \
'' using (startTime+$1):7 with lines title '' ls 8 dt 1, \
'' using (startTime+$1):8 with lines title '' ls 4 dt 2, \
'' using (startTime+$1):9 with lines title '' ls 4 dt 3, \
'' using (startTime+$1):10 with lines title '' ls 4 dt 4, \
'' using (startTime+$1):11 with lines title '' ls 4 dt 1

plot \
'replay_24hrs_-1_vms_28.txt.wikipages.deciles' using (startTime+$1):3 with lines title 'SR dyn wiki pages' ls 8 dt 1, \
'' using (startTime+$1):4 with lines title '' ls 8 dt 2, \
'' using (startTime+$1):5 with lines title '' ls 8 dt 3, \
'' using (startTime+$1):6 with lines title '' ls 8 dt 4, \
'' using (startTime+$1):7 with lines title '' ls 8 dt 1, \
'' using (startTime+$1):8 with lines title '' ls 8 dt 2, \
'' using (startTime+$1):9 with lines title '' ls 8 dt 3, \
'' using (startTime+$1):10 with lines title '' ls 8 dt 4, \
'' using (startTime+$1):11 with lines title '' ls 8 dt 1

pause mouse keypress
EOF


