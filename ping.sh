#!/bin/sh

for n in `seq 1 7`; do
  ping -q -w 60 10.1.1.$n
done
