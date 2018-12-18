### Data used in my PhD dissertation

This repository contains the data files and script files that were used to generate all the plots which can be found in my [PhD thesis](#).
Plots were created using [Gnuplot](http://www.gnuplot.info). 

The following folders correspond to the following chapter of my dissertation:

* `sr_migration`: _Zero-loss virtual machine migration with IPv6 Segment Routing_
* `dc_optim`: _Flow-aware workload migration in data centers_
* `rbier`: _Reliable multicast with BIER_
* `bier_peer`: _Reliable BIER with peer caching_
* `6lb`: _6LB: Scalable and application-aware load balancing with Segment Routing_
* `shell`: _Stateless load-aware load balancing in P4_
* `sr_autoscale`: _Joint autoscaling and load balancing with Segment Routing_

For each of these chapters, the script `./plot.sh` will generate PDF figures corresponding to the graphs found in these chapters. *Nota Bene:* the scripts are intended for MacOS and thus make use of `gzcat` in order to decompress `*.gz` files. On Linux, you might need to alias `gzcat` to `zcat` for the scripts to work.
