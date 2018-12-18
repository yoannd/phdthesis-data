#!/usr/bin/env python

## Compute the EWMA of a time series given in stdin ##
## Input format: 
## t_0 x_0
## t_1 x_1
## ...

import sys
import math

alpha = 1 if len(sys.argv) < 2 else float(sys.argv[1])

line = sys.stdin.readline()
ls = line.split()
x = 0.8 #float(ls[0])
ema = x


for line in sys.stdin:
	ls = line.split()
	x = float(ls[0])

	ema = alpha*x + (1-alpha)*ema
	print ema
