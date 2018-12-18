#!/bin/bash


###### E[T]=f(lambda) for c=2 and SLA=2 ######
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72. 
set output 'autoscale_response_time_sla2.pdf'
set xrange [0:3]
set yrange [1:3]
set xlabel "Request rate ρ=λ/μ"
set ylabel "Expected response time"
set key top horiz

set multiplot layout 2,1

# NB: upscale when E[T]=2, downscale when E[T]=1/(1-(N-1)*(1-1/2)/N)
plot \
'n1sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 1 lw 0.5 dt 2 pt 1 title 'SR2 n=1', \
'n2c2.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 1 lw 0.5 dt 2 pt 2 title 'SR2 n=2', \
'n3c2.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 1 lw 0.5 dt 2 pt 3 title 'SR2 n=3', \
'n4c2.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 1 lw 0.5 dt 2 pt 4 title 'SR2 n=4', \
'n5c2.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 1 lw 0.5 dt 2 pt 8 title 'SR2 n=5', \
2 with lines ls -1 lw 2 dt 3 title 'SLA', \
'nautoc2sla2.csv' with lines ls 1 lw 2 title 'SR2 Autoscale'

plot \
'n1sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 2 lw 0.5 dt 2 pt 1 title 'SC n=1', \
'n2sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 2 lw 0.5 dt 2 pt 2 title 'SC n=2', \
'n3sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 2 lw 0.5 dt 2 pt 3 title 'SC n=3', \
'n4sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 2 lw 0.5 dt 2 pt 4 title 'SC n=4', \
'n5sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 2 lw 0.5 dt 2 pt 8 title 'SC n=5', \
'n6sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 2 lw 0.5 dt 2 pt 6 title 'SC n=6', \
2 with lines ls -1 lw 2 dt 3 title 'SLA', \
'nautoscsla2.csv' with lines ls 2 lw 2 title 'SC Autoscale'

pause mouse keypress
EOF





##### VMs needed for SLA=2 #####
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,160/72. 
set output 'autoscale_vms_sla2.pdf'
set xrange [0:3]
set yrange [0:7]
set xlabel "Request rate ρ=λ/μ"
set ylabel "Number of VMs\nneeded for SLA=2"
set key left

plot \
'nautoc2sla2.csv' using 1:3 with linespoints pointinterval 40 lt 1 lw 2 title 'SR2 Autoscale', \
'nautoscsla2.csv' using 1:3 with linespoints pointinterval 40 lt 2 lw 2 title 'SC Autoscale'

pause mouse keypress
EOF

###### E[T]=f(lambda) for c=3 and SLA=3 ######
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72. 
set output 'autoscale_response_time_sla3.pdf'
set xrange [0:3]
set yrange [1:4]
set xlabel "Request rate ρ=λ/μ"
set ylabel "Expected response time"
set key top horiz

set multiplot layout 2,1

# NB: upscale when E[T]=3, downscale when E[T]=1/(1-(N-1)*(1-1/3)/N)
plot \
'n1sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 1 lw 0.5 dt 2 pt 1 title 'SR3 n=1', \
'n2c3.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 1 lw 0.5 dt 2 pt 2 title 'SR3 n=2', \
'n3c3.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 1 lw 0.5 dt 2 pt 3 title 'SR3 n=3', \
'n4c3.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 1 lw 0.5 dt 2 pt 4 title 'SR3 n=4', \
3 with lines ls -1 lw 2 dt 3 title 'SLA', \
'nautoc3sla3.csv' with lines ls 1 lw 2 title 'SR3 Autoscale'

plot \
'n1sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 2 lw 0.5 dt 2 pt 1 title 'SC n=1', \
'n2sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 2 lw 0.5 dt 2 pt 2 title 'SC n=2', \
'n3sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 2 lw 0.5 dt 2 pt 3 title 'SC n=3', \
'n4sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 2 lw 0.5 dt 2 pt 4 title 'SC n=4', \
'n5sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 2 lw 0.5 dt 2 pt 8 title 'SC n=5', \
'n6sc.csv' using 1:($2/$1) with linespoints pointinterval 20 lt 2 lw 0.5 dt 2 pt 6 title 'SC n=6', \
3 with lines ls -1 lw 2 dt 3 title 'SLA', \
'nautoscsla3.csv' with lines ls 2 lw 2 title 'SC Autoscale'


pause mouse keypress
EOF





##### VMs needed for SLA=3 #####
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,160/72. 
set output 'autoscale_vms_sla3.pdf'
set xrange [0:3]
set yrange [0:7]
set xlabel "Request rate ρ=λ/μ"
set ylabel "Number of VMs\nneeded for SLA=3"
set key left

plot \
'nautoc3sla3.csv' using 1:3 with linespoints pointinterval 40 lt 1 lw 2 title 'SR3 Autoscale', \
'nautoscsla3.csv' using 1:3 with linespoints pointinterval 40 lt 2 lw 2 title 'SC Autoscale'


pause mouse keypress
EOF

##### E[T] for lambda with diurnal pattern #####
gnuplot -persist << "EOF"
set grid
set terminal qt font "Helvetica,15"
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72. 
set output 'autoscale_lambda_cosinus_sla2.pdf'
set multiplot layout 3,1

set xrange [0:24]
set samples 400

f(x)=1.35+1.35*sin( (x/24.0-0.25)*2*pi )
nc2sla2_t(x)=system("head -n ".( 1+floor(f(x)*100) )." nautoc2sla2.csv | tail -n 1 | awk '{print $2}'")+0.
nscsla2_t(x)=system("head -n ".( 1+floor(f(x)*100) )." nautoscsla2.csv | tail -n 1 | awk '{print $2}'")+0.
nc2sla2_n(x)=system("head -n ".( 1+floor(f(x)*100) )." nautoc2sla2.csv | tail -n 1 | awk '{print $3}'")+0.
nscsla2_n(x)=system("head -n ".( 1+floor(f(x)*100) )." nautoscsla2.csv | tail -n 1 | awk '{print $3}'")+0.


set yrange [1:2.5]
set ylabel "Response time"
set key horiz
plot \
nc2sla2_t(x) with linespoints pointinterval 40 lt 1 lw 2 title 'SR2 Autoscale', \
nscsla2_t(x) with linespoints pointinterval 40 lt 2 lw 2 title 'SC Autoscale', \
2 with lines ls -1 lw 2 dt 3 title 'SLA'


set yrange [1:6]
set ylabel "Number of VMs"
set key vert 
plot \
nc2sla2_n(x) with linespoints pointinterval 40 lt 1 lw 2 title 'SR2 Autoscale', \
nscsla2_n(x) with linespoints pointinterval 40 lt 2 lw 2 title 'SC Autoscale'

set yrange [0:2.7]
set ylabel "Request rate ρ=λ/μ"
set xlabel "Time of day (h)"
plot f(x) with lines ls 4 title 'Request rate'

pause mouse keypress
EOF

### WIKIPEDIA REPLAY ###

## Mean response time and number of VMs ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72. 
set output 'results_autoscale_wiki_sr4_vs_sc_response_time_and_num_vms.pdf'
set multiplot layout 3,1

set xdata time
set xtics 1190146243,14400,1190232643
set format x "%H:%M"
#set ylabel "Decile 1-9 response time (s)"
#set yrange [0:1]
set xrange [1190146243:1190146243+86400]
startTime = 1190146243
SLA = 0.29
set key bottom

set ylabel "Mean resp. time (s)"
set yrange [0:0.6]

plot \
SLA ls -1 lw 2 dt 2 title '', \
'replay_24hrs_onlywiki_sr4_downempty0.4_upthresh0.75.txt.wikipages.ma.10000' using (startTime+$1):2 with lines title 'SR4' ls 1 lw 2 dt 1, \
'replay_24hrs_onlywiki_sc_sla0.29_downnnm1sla_upnp1sla_win120s.txt.wikipages.ma.10000' using (startTime+$1):2 with lines title 'SC' ls 2 lw 1 dt 1

set yrange [0:20]
set ylabel "Number of VMs"

plot \
'replay_24hrs_onlywiki_sr4_downempty0.4_upthresh0.75_num_vms.csv' using (startTime+$1):2 with step title 'SR4' ls 1 lw 2 dt 1, \
'replay_24hrs_onlywiki_sc_sla0.29_downnnm1sla_upnp1sla_win120s_num_vms.csv' using (startTime+$1):2 with step title 'SC' ls 2 lw 1 dt 1


set yrange [0:140]
set ylabel "Queries per second"
set xlabel "Time of day (UTC)"

plot 'replay_24hrs_onlywiki_sr4_downempty0.4_upthresh0.75.txt.wikipages.deciles' using (startTime+$1):($2/600) with lines title 'Request rate' ls 4 dt 1, \


pause mouse keypress
EOF



## CDF of response time ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,320/72. 
set output 'results_autoscale_wiki_sr4_vs_sc_response_time_cdf.pdf'
set multiplot layout 1,2
set xlabel "Response time (s)"
set ylabel "CDF"
set yrange [0:1]
set xrange [0:1]
set key bottom right

npointssc=system("cat replay_24hrs_onlywiki_sc_sla0.29_downnnm1sla_upnp1sla_win120s.txt.wikipages.sorted.10000 | wc -l")+0
npoints4=system("cat replay_24hrs_onlywiki_sr4_downempty0.4_upthresh0.75.txt.wikipages.sorted.10000 | wc -l")+0


plot \
'replay_24hrs_onlywiki_sc_sla0.29_downnnm1sla_upnp1sla_win120s.txt.wikipages.sorted.10000' using 2:(column(0)/1000.) every (npointssc/1000.) with linespoints title 'SC' ls 2 pt 1 dt 1 pointinterval 1000./20, \
'replay_24hrs_onlywiki_sr4_downempty0.4_upthresh0.75.txt.wikipages.sorted.10000' using 2:(column(0)/1000.) every (npoints4/1000.) with linespoints title 'SR4' ls 1 pt 4 dt 1 pointinterval 1000./20

unset ylabel
set yrange [0.99:1]
set xrange [0.7:30]
set logscale x
plot \
'replay_24hrs_onlywiki_sc_sla0.29_downnnm1sla_upnp1sla_win120s.txt.wikipages.sorted.10000' using 2:(column(0)/10000.) every (npointssc/10000.) with linespoints title 'SC' ls 2 pt 1 dt 1 pointinterval 100./20, \
'replay_24hrs_onlywiki_sr4_downempty0.4_upthresh0.75.txt.wikipages.sorted.10000' using 2:(column(0)/10000.) every (npoints4/10000.) with linespoints title 'SR4' ls 1 pt 4 dt 1 pointinterval 100./20


pause mouse keypress
EOF
