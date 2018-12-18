#!/bin/bash

## Pareto front vs estimations for 20 machines, 100 tasks ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_tree_2_racks_100_tasks.pdf'
set xlabel "Migration cost"
set ylabel "Total throughput"
set key bottom 

plot \
'results_tree_2_racks_100_tasks_1_incr.csv' using 4:6 with linespoints title 'Δ=1', \
'results_tree_2_racks_100_tasks_3_incr.csv' using 4:6 with linespoints title 'Δ=3', \
'results_tree_2_racks_100_tasks_5_incr.csv' using 4:6 with linespoints title 'Δ=5', \
'results_tree_2_racks_100_tasks_epsilon_incr.csv' using 4:($6 <= 0 ? 1/0 : $6) with lines title 'Pareto front' ls 6 lw 2, \


#'results_tree_2_racks_100_tasks_2_incr.csv' using 4:6 with linespoints title 'Δ=2', \
#'results_tree_2_racks_100_tasks_4_incr.csv' using 4:6 with linespoints title 'Δ=4', \


pause mouse keypress
EOF


## Pareto front vs estimations for 20 machines, 40 tasks ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_tree_2_racks_40_tasks.pdf'
set xlabel "Migration cost"
set ylabel "Total throughput"
set key bottom 
set xrange [0:15]

plot \
'results_tree_2_racks_40_tasks_1_incr.csv' using 4:6 with linespoints title 'Δ=1', \
'results_tree_2_racks_40_tasks_3_incr.csv' using 4:6 with linespoints title 'Δ=3', \
'results_tree_2_racks_40_tasks_5_incr.csv' using 4:6 with linespoints title 'Δ=5', \
'results_tree_2_racks_40_tasks_epsilon_incr.csv' using 4:($6 <= 0 ? 1/0 : $6) with lines title 'Pareto front' ls 6 lw 2, \



#'results_tree_2_racks_40_tasks_2_incr.csv' using 4:6 with linespoints title 'Δ=2', \
#'results_tree_2_racks_40_tasks_4_incr.csv' using 4:6 with linespoints title 'Δ=4', \


pause mouse keypress
EOF



## Solving time for budget=20 ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_tree_time_20_budget.pdf'
set xlabel "Topology (#machines-#tasks)"
set ylabel "Total solving time (s)"
set key bottom
set xtics rotate
set logscale y

plot \
'results_tree_time_20_budget_1_incr.csv' using (column(0)):1:xtic(2) with lines title 'Δ=1', \
'results_tree_time_20_budget_2_incr.csv' using (column(0)):1 with lines title 'Δ=2', \
'results_tree_time_20_budget_3_incr.csv' using (column(0)):1 with lines title 'Δ=3', \
'results_tree_time_20_budget_4_incr.csv' using (column(0)):1 with lines title 'Δ=4', \
'results_tree_time_20_budget_5_incr.csv' using (column(0)):1 with lines title 'Δ=5', \
'results_tree_time_20_budget_epsilon_incr.csv' using (column(0)):($1 < 0 ? 1/0: $1) title 'Exact'
pause mouse keypress

EOF

## Solving time for budget=30 ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_tree_time_30_budget.pdf'
set xlabel "Topology (#machines-#tasks)"
set ylabel "Total solving time (s)"
set key bottom
set xtics rotate
set logscale y

plot \
'results_tree_time_30_budget_1_incr.csv' using (column(0)):1:xtic(2) with lines title 'Δ=1', \
'results_tree_time_30_budget_2_incr.csv' using (column(0)):1 with lines title 'Δ=2', \
'results_tree_time_30_budget_3_incr.csv' using (column(0)):1 with lines title 'Δ=3', \
'results_tree_time_30_budget_4_incr.csv' using (column(0)):1 with lines title 'Δ=4', \
'results_tree_time_30_budget_5_incr.csv' using (column(0)):1 with lines title 'Δ=5', \
'results_tree_time_30_budget_epsilon_incr.csv' using (column(0)):($1 < 0 ? 1/0: $1) title 'Exact'

pause mouse keypress
EOF

## Throughput improvement for budget=20 ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_tree_thr_improvement_20_budget.pdf'
set xlabel "Topology (#machines-#tasks)"
set ylabel "Throughput improvement"
set xtics rotate
set key bottom
set yrange [1:2.2]

plot \
'results_tree_thr_improvement_20_budget_1_incr.csv' using (column(0)):3:xtic(4) with lines title 'Δ=1', \
'results_tree_thr_improvement_20_budget_2_incr.csv' using (column(0)):3 with lines title 'Δ=2', \
'results_tree_thr_improvement_20_budget_3_incr.csv' using (column(0)):3 with lines title 'Δ=3', \
'results_tree_thr_improvement_20_budget_4_incr.csv' using (column(0)):3 with lines title 'Δ=4', \
'results_tree_thr_improvement_20_budget_5_incr.csv' using (column(0)):3 with lines title 'Δ=5', \
'results_tree_thr_improvement_20_budget_epsilon_incr.csv' using (column(0)):($3 < 0 ? 1/0 : $3) title 'Exact'

pause mouse keypress
EOF

## Throughput improvement for budget=30 ##
gnuplot -persist  << "EOF"
set grid
set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_tree_thr_improvement_30_budget.pdf'
set xlabel "Topology (#machines-#tasks)"
set ylabel "Throughput improvement"
set xtics rotate
set key bottom
set yrange [1:2.4]


plot \
'results_tree_thr_improvement_30_budget_1_incr.csv' using (column(0)):3:xtic(4) with lines title 'Δ=1', \
'results_tree_thr_improvement_30_budget_2_incr.csv' using (column(0)):3 with lines title 'Δ=2', \
'results_tree_thr_improvement_30_budget_3_incr.csv' using (column(0)):3 with lines title 'Δ=3', \
'results_tree_thr_improvement_30_budget_4_incr.csv' using (column(0)):3 with lines title 'Δ=4', \
'results_tree_thr_improvement_30_budget_5_incr.csv' using (column(0)):3 with lines title 'Δ=5', \
'results_tree_thr_improvement_30_budget_epsilon_incr.csv' using (column(0)):($3 < 0 ? 1/0 : $3) title 'Exact'


pause mouse keypress
EOF


## 3D pareto front ##
gnuplot -persist << EOF

set terminal pdfcairo font "Helvetica,15" linewidth 2 fontscale 1 size 640/72.,480/72.
set output 'results_multi_pareto.pdf'
set xlabel 'Migrated'
set xtics 1
set ylabel 'Placed'
set ytics 1
set zlabel 'Throughput' rotate parallel

set border 895
set grid
set dgrid3d 10,5
#set table 'seed_42_table.dat'
set style fill solid 0.6
#splot 'seed_42.csv' using 14:12:10
unset table
unset dgrid3d
set palette rgb 23,28,3
set pm3d border linestyle 6
set view 62,215
splot 'seed_42_table.dat' using 1:2:(\$3 == 0 ? 1/0 : \$3) with pm3d title 'Total DC throughput', \
  'seed_42_pareto.csv' using 14:12:10 pt 7 ps 1 lc rgb 'red' title 'Pareto-optimal solutions'
pause mouse keypress

EOF
