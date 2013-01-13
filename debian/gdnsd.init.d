#!/bin/sh
### BEGIN INIT INFO
# Provides:          gdnsd
# Required-Start:    $syslog $remote_fs
# Required-Stop:     $syslog $remote_fs
# Should-Start:      $local_fs
# Should-Stop:       $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: gdnsd
# Description:       authoritative name server
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/sbin/gdnsd
NAME="gdnsd"

test -x $DAEMON || exit 0

. /lib/lsb/init-functions

[ -f /etc/default/$NAME ] && . /etc/default/$NAME

GDNSD_CMD="$DAEMON $GDNSD_CHROOT"

gdnsd_cmd() {
    $GDNSD_CMD "$1" >/dev/null 2>/dev/null
    ret=$?
    log_end_msg $ret
    exit $ret
}

case "$1" in
    start)
        log_daemon_msg "Starting $NAME" "$NAME"
        gdnsd_cmd "$1"
        ;;
    stop)
        log_daemon_msg "Stopping $NAME" "$NAME"
        gdnsd_cmd "$1"
        ;;
    reload)
        log_daemon_msg "Reloading $NAME" "$NAME"
        gdnsd_cmd "$1"
        ;;
    force-reload|restart|condrestart|try-restart)
        log_daemon_msg "Restarting $NAME" "$NAME"
        gdnsd_cmd "$1"
        ;;
    status)
        $GDNSD_CMD $1 >/dev/null 2>/dev/null
        case "$?" in
            0) log_success_msg "$NAME is running"; exit 0 ;;
            *) log_failure_msg "$NAME is not running"; exit 3 ;;
        esac
        ;;
    *)
        echo "Usage: /etc/init.d/gdnsd {start|stop|reload|force-reload|restart|condrestart|status}"
        exit 1
esac

exit 0
