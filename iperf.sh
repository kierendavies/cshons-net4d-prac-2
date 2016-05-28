#!/bin/sh

iperf -s &
pid=$!

for n in `seq 1 7`; do
  ssh 10.1.1.$n iperf -c 10.1.1.200 -t 60 > /dev/null
done

kill $pid
