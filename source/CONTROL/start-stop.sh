#!/bin/sh -e

NAME=python-cec
PKG_PATH=/usr/local/AppCentral/python-cec

. /lib/lsb/init-functions

start_daemon () {
    true
}

stop_daemon () {
    true
}


case "$1" in
    start)
        log_daemon_msg "Starting" "$NAME"
        start_daemon
        log_end_msg 0
        ;;
    stop)
        log_daemon_msg "Stopping" "$NAME"
        stop_daemon
        log_end_msg 0
        ;;
    reload)
        log_daemon_msg "Reloading" "$NAME"
        stop_daemon
        start_daemon
        log_end_msg 0
        ;;
    restart|force-reload)
        log_daemon_msg "Restarting" "$NAME"
        stop_daemon
        start_daemon
        log_end_msg 0
        ;;
    *)
        echo "Usage: start-stop.sh {start|stop|reload|force-reload|restart}"
        exit 2
        ;;
esac

exit 0
