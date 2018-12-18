#!/bin/bash

## Per-packet latency for a burst of 4800 packets, with d^max_off = 11 ##
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'results_latency_vs_packet_index_doff11.pdf'
set xlabel "Packet number"
set ylabel "Latency (μs)"
set xrange [0:4800]
#set yrange [0:16]
set key left

plot 'latency_results_12_24.csv' using 1:2 with lines ls 27 title 'doff\_max = 11'


pause mouse keypress

EOF

## CDF of per-packet latency for different values of d^max_off ##
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,320/72.
set output 'results_latency_vs_tlv_distrib.pdf'
set xlabel "Latency (μs)"
set ylabel "Cumulative Distribution Function"
set key left

normalizer1=system("tail -n 1 latency_results_distribution.csv | awk '{print $1}'")+0.0
normalizer2=system("tail -n 1 latency_results_distribution.csv | awk '{print $2}'")+0.0
normalizer3=system("tail -n 1 latency_results_distribution.csv | awk '{print $3}'")+0.0
normalizer4=system("tail -n 1 latency_results_distribution.csv | awk '{print $4}'")+0.0

plot 'latency_results_distribution.csv' using (column(0)/100.):($1/normalizer1) with linespoints pointinterval 40 lt 6 pt 8 title 'doff\_max = 8', \
'' using (column(0)/100.):($2/normalizer2) with linespoints pointinterval 40 lt 2 title 'doff\_max = 11', \
'' using (column(0)/100.):($3/normalizer3) with linespoints pointinterval 40 lt 7 pt 6  title 'doff\_max = 13', \
'' using (column(0)/100.):($4/normalizer4) with linespoints pointinterval 40 lt 4 title 'doff\_max = 15'

pause mouse keypress
EOF

## Consistant hashing ##
gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15"  linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_ad_buckets_500.pdf' 
set multiplot layout 2,1
set xrange [0:300]
set ylabel "Connection reset probability"
set key left

set label 'Infinite connections' center at 175,0.37


plot 'results_ad_buckets_500_unbalanced.csv' using (column(0)):(0.01*$2) with linespoints pointinterval 10 lt 6 pt 8 title '503 buckets', \
'' using (column(0)):(0.01*$8) with linespoints pointinterval 10 lt 2 title '8737 buckets', \
'' using (column(0)):(0.01*$11)  with linespoints pointinterval 10 pt 6 lt 7 title '31489 buckets', \
'' using (column(0)):(0.01*$13)  with linespoints pointinterval 10 lt 4 title '63709 buckets', \

set label "Connection durations from model" center at 175,0.0128
set xlabel "Number of server reconfigurations"
set yrange [0:0.014]
plot 'results_ad_buckets_500_worse.csv' using (column(0)):(0.01*$2) with linespoints pointinterval 10 lt 6 pt 8 title '503 buckets', \
'' using (column(0)):(0.01*$8) with linespoints pointinterval 10 lt 2 title '8737 buckets', \
'' using (column(0)):(0.01*$11)  with linespoints pointinterval 10 pt 6 lt 7 title '31489 buckets', \
'' using (column(0)):(0.01*$13)  with linespoints pointinterval 10 lt 4 title '63709 buckets', \


pause mouse keypress
EOF




gnuplot -persist << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15"  linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_ad_buffer_500.pdf' 
set multiplot layout 2,1
set xrange [0:300]
set ylabel "Connection reset probability"
set key left

set label 'Infinite connections' center at 150,0.74

#plot '< echo NaN' with lines title 'Infinite connections' ls -1, 
plot 'results_ad_buffer_500_unbalanced.csv' using (column(0)):(0.01*$1) with linespoints pointinterval 10 lt 6 pt 8 title 'h = 1', \
'' using (column(0)):(0.01*$2) with linespoints pointinterval 10 lt 2 title 'h = 2', \
'' using (column(0)):(0.01*$3)  with linespoints pointinterval 10 pt 6 lt 7 title 'h = 3', \

set yrange [0:0.07]
set label "Connection durations from model" center at 150,0.064
set xlabel "Number of server reconfigurations"

#plot '< echo NaN' with lines title 'Connection durations from model' ls -1, 
plot 'results_ad_buffer_500_worse.csv' using (column(0)):(0.01*$1) with linespoints pointinterval 10 lt 6 pt 8 title 'h = 1', \
'' using (column(0)):(0.01*$2) with linespoints pointinterval 10 lt 2 title 'h = 2', \
'' using (column(0)):(0.01*$3)  with linespoints pointinterval 10 pt 6 lt 7 title 'h = 3'


pause mouse keypress
EOF
