#!/bin/sh
for n in `seq 1 6`; do
  ping -q -w 60 10.1.1.$n
done
