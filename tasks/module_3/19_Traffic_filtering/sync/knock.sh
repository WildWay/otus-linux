#!/bin/sh

for port in $2 $3 $4; do
    echo "KNOCK in $port"
    echo "*" > /dev/udp/$1/$port
done

echo "CONNECTION to $1:$5 as $6"
ssh $6@$1 -p $5