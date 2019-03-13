#!/bin/sh

case $1 of
start) /usr/bin/mydaemon -p /var/run/mydaemon.pid
;;
stop) kill $(</var/run/mydaemon.pid
;;
restart) $0 stop; $0 start
;;
*) echo "unknown command $1"
esac