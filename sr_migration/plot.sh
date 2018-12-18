#!/bin/bash


gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'results_ping.pdf'
set xlabel "Sent (ms)"
set ylabel "Received (ms)"

set multiplot layout 2,2
set pointsize 0.5
set xrange [2500:4500]
set yrange [2500:4500]

plot 'ping_migration_no_sr.csv' using ($1):($1+$2) every 10 title "Non-SR migration" ls 1
plot 'ping_migration_no_buffer.csv' using ($1):($1+$2) every 10 title "SR migration, drop" ls 2
plot 'ping_migration_buffer.csv' using ($1):($1+$2) every 10 title "SR migration, buffer" ls 3
plot 'ping_no_migration.csv' using ($1):($1+$2) every 10 title "No migration" ls 4


EOF


gnuplot   << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'results_response_time_http_static_lambda_1500_loglog.pdf'
set xlabel "Response time (s)"
set ylabel "CDF"
set key bottom right horizontal
f(x)=1 - 10**(-x)
g(x)=-log10(1-x)
npoints=system("gzcat results_http_migration_no_sr.csv.gz | wc -l")+0.

set yrange [0:3]
set xrange [0.001:1.1]
set logscale x
set ytics ("0" 0, "" g(0.1) 1, "" g(0.2) 1, "" g(0.3) 1, "" g(0.4) 1, "" g(0.5) 0, "" g(0.6) 1, "" g(0.7) 1, "" g(0.8) 1, "0.9" g(0.9), "" g(0.91) 1, "" g(0.92) 1, "" g(0.93) 1, "" g(0.94) 1, "" g(0.95) 1, "" g(0.96) 1, "" g(0.97) 1, "" g(0.98) 1, "0.99" g(0.99), "" g(0.991) 1, "" g(0.992) 1, "" g(0.993) 1, "" g(0.994) 1, "" g(0.995) 1, "" g(0.996) 1, "" g(0.997) 1, "" g(0.998) 1, "0.999" g(0.999))



plot \
'<gzcat results_http_migration_no_sr.csv.gz' using 1:(g(column(0)/2000.)) every (npoints/2000.) with linespoints pointinterval 100 title 'Non-SR migration', \
'<gzcat results_http_migration_no_buffer.csv.gz' using 1:(g(column(0)/2000.)) every (npoints/2000.) with linespoints pointinterval 100 title 'SR migration, drop', \
'<gzcat results_http_migration_buffer.csv.gz' using 1:(g(column(0)/2000.)) every (npoints/2000.) with linespoints pointinterval 100 title 'SR migration, buffer', \
'<gzcat results_http_no_migration.csv.gz' using 1:(g(column(0)/2000.)) every (npoints/2000.) with linespoints pointinterval 100 title 'No migration', \

EOF

gnuplot  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'results_response_time_http_dynamic_lambda_1500_loglog.pdf'
set xlabel "Response time (s)"
set ylabel "CDF"
set key left 
f(x)=1 - 10**(-x)
g(x)=-log10(1-x)
npoints=system("gzcat results_http_dynamic_migration_no_sr.csv.gz | wc -l")+0.

set yrange [0:3]
set xrange [0.001:1.45]
set logscale x
set ytics ("0" 0, "" g(0.1) 1, "" g(0.2) 1, "" g(0.3) 1, "" g(0.4) 1, "" g(0.5) 0, "" g(0.6) 1, "" g(0.7) 1, "" g(0.8) 1, "0.9" g(0.9), "" g(0.91) 1, "" g(0.92) 1, "" g(0.93) 1, "" g(0.94) 1, "" g(0.95) 1, "" g(0.96) 1, "" g(0.97) 1, "" g(0.98) 1, "0.99" g(0.99), "" g(0.991) 1, "" g(0.992) 1, "" g(0.993) 1, "" g(0.994) 1, "" g(0.995) 1, "" g(0.996) 1, "" g(0.997) 1, "" g(0.998) 1, "0.999" g(0.999))



plot \
'<gzcat results_http_dynamic_migration_no_sr.csv.gz' using 1:(g(column(0)/2000.)) every (npoints/2000.) with linespoints pointinterval 100 title 'Non-SR migration', \
'<gzcat results_http_dynamic_migration_no_buffer.csv.gz' using 1:(g(column(0)/2000.)) every (npoints/2000.) with linespoints pointinterval 100 title 'SR migration, drop', \
'<gzcat results_http_dynamic_migration_buffer.csv.gz' using 1:(g(column(0)/2000.)) every (npoints/2000.) with linespoints pointinterval 100 title 'SR migration, buffer', \
'<gzcat results_http_dynamic_no_migration.csv.gz' using 1:(g(column(0)/2000.)) every (npoints/2000.) with linespoints pointinterval 100 title 'No migration', \

EOF

gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'results_iperf_agg_throughput_cdf.pdf'
set xlabel "Instantaneous throughput (Gbps)"
set ylabel "CDF"
set key top left

set xrange [0:3.73]
set yrange [0:1]
npoints=system("wc -l < iperf_migration_buffer_agg_inst_throughput_cdf.csv")+0.


plot \
'iperf_migration_no_sr_agg_inst_throughput_cdf.csv' using ($1/1e9):(column(0)/npoints) with linespoints pointinterval (npoints/20.) title "Non-SR migration", \
'iperf_migration_no_buffer_agg_inst_throughput_cdf.csv' using ($1/1e9):(column(0)/npoints) with linespoints pointinterval (npoints/20.) title "SR migration, drop", \
'iperf_migration_buffer_agg_inst_throughput_cdf.csv' using ($1/1e9):(column(0)/npoints) with linespoints pointinterval (npoints/20.) title "SR migration, buffer", \
'iperf_no_migration_agg_inst_throughput_cdf.csv' using ($1/1e9):(column(0)/npoints) with linespoints pointinterval (npoints/20.) title "No migration", \


EOF



gnuplot  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72.
set ylabel "Throughput\n(Gbps)"
set key bottom right
set output 'results_iperf_agg_throughput_one_experiment.pdf'

set multiplot layout 4,1

set ytics 2
set xrange [0:10]
set yrange [0:4]

plot "iperf_migration_no_sr_aggregate_throughput_all.csv" using (column(0)/2):( $2/1e9 ) with linespoints title 'Non-SR migration' ls 1
plot "iperf_migration_no_buffer_aggregate_throughput_all.csv" using (column(0)/2):( $2/1e9 ) with linespoints title 'SR migration, drop' ls 2
plot "iperf_migration_buffer_aggregate_throughput_all.csv" using (column(0)/2):( $2/1e9 ) with linespoints title 'SR migration, buffer' ls 3

set xlabel "Time (s)"
plot "iperf_no_migration_aggregate_throughput_all.csv" using (column(0)/2):( $2/1e9 ) with linespoints title 'No migration' ls 4

EOF


gnuplot  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'results_iperf_sink_agg_throughput_cdf.pdf'
set xlabel "Instantaneous throughput (Gbps)"
set ylabel "CDF"
set key top left

set xrange [0:3.50]
set yrange [0:1]
npoints=system("wc -l < iperf_sink_no_migration_agg_inst_throughput_cdf.csv")+0.


plot \
'iperf_sink_migration_no_sr_agg_inst_throughput_cdf.csv' using ($1/1e9):(column(0)/npoints) with linespoints pointinterval (npoints/20.) title "Non-SR migration", \
'iperf_sink_migration_no_buffer_agg_inst_throughput_cdf.csv' using ($1/1e9):(column(0)/npoints) with linespoints pointinterval (npoints/20.) title "SR migration, drop", \
'iperf_sink_migration_buffer_agg_inst_throughput_cdf.csv' using ($1/1e9):(column(0)/npoints) with linespoints pointinterval (npoints/20.) title "SR migration, buffer", \
'iperf_sink_no_migration_agg_inst_throughput_cdf.csv' using ($1/1e9):(column(0)/npoints) with linespoints pointinterval (npoints/20.) title "No migration", \


EOF



gnuplot  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_iperf_sink_agg_throughput_one_experiment.pdf'

set ylabel "Throughput\n(Gbps)"
set key bottom right

set multiplot layout 4,1

set ytics 2
set xrange [0:10]
set yrange [0:4]

plot "iperf_sink_migration_no_sr_aggregate_throughput_all.csv" using (column(0)/2):( $7/1e9 ) with linespoints title 'Non-SR migration' ls 1
plot "iperf_sink_migration_no_buffer_aggregate_throughput_all.csv" using (column(0)/2):( $7/1e9 ) with linespoints title 'SR migration, drop' ls 2
plot "iperf_sink_migration_buffer_aggregate_throughput_all.csv" using (column(0)/2):( $7/1e9 ) with linespoints title 'SR migration, buffer' ls 3


set xlabel "Time (s)"
plot "iperf_sink_no_migration_aggregate_throughput_all.csv" using (column(0)/2):( $7/1e9 ) with linespoints title 'No migration' ls 4

EOF
