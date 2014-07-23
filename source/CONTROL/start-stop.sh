#!/bin/sh -e

NAME=python-cec
PKG_DIR=/usr/local/AppCentral/python-cec
PYTHON_DIR=/usr/local/AppCentral/python
SITE_PACKAGES=lib/python2.7/site-packages

. /lib/lsb/init-functions

start_daemon () {
    for i in ${PKG_DIR}/${SITE_PACKAGES}/*; do
        ln -s ${i} ${PYTHON_DIR}/${SITE_PACKAGES}
    done
}

stop_daemon () {
    for i in ${PKG_DIR}/${SITE_PACKAGES}/*; do
        file=$(basename ${i})
        target=${PYTHON_DIR}/${SITE_PACKAGES}/${file}
        readlink ${target} | grep -q ${PKG_DIR} && rm ${target}
    done
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
    restart)
        log_daemon_msg "Starting" "$NAME"
        stop_daemon
        start_daemon
        log_end_msg 0
        ;;
    *)
        echo "Usage: start-stop.sh {start|stop|restart}"
        exit 2
        ;;
esac

exit 0
