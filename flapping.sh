#!/bin/sh

get_route() {
  route=`traceroute -I -n $1 | tail -n +2 | awk '{ print $2; }'`
}

destination=$1

duration=$2
end_time=$(( $(date +%s) + $duration ))

get_route $destination
echo -e "Initial route:\n$route"

flap_count=0
while [ $(date +%s) -lt $end_time ]; do
  old_route=$route
  get_route $destination
  flapped=false
  echo "$old_route" > /tmp/old_route
  echo "$route" > /tmp/new_route

  if [ $(wc -l /tmp/old_route | awk '{ print $1; }') != $(wc -l /tmp/new_route | awk '{ print $1; }') ]; then
    flapped=true
  else
    while read old_hop <&3 && read new_hop <&4; do
      if [ "$old_hop" != "$new_hop" ] && [ "$old_hop" != "*" ] && [ "$new_hop" != "*" ]; then
        flapped=true
        break
      fi
    done 3</tmp/old_route 4</tmp/new_route
  fi

  if [ "$flapped" = true ]; then
    flap_count=$((flap_count+1))
    echo -e "\nNew route:\n$route"
  fi
done

echo -e "\nFlap count: $flap_count"
