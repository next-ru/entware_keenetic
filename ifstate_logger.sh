#!/bin/sh

log_file="/opt/var/log/netmon.log"

log() {
    echo "$(date +"%b %d %Y %H:%M:%S") $1" >> "$log_file"
}

if [ ! -f "/tmp/.last_boot" ]; then
    touch "/tmp/.last_boot"
    log "system ready, uptime $(awk '{print int($1)}' /proc/uptime) seconds"
fi

if [ "$system_name" = "eth2.2" ] && [ "$change" = "link" ]; then
    log "$system_name interface current link status= $link"
fi

if [ "$system_name" = "ppp0" ] && [ "$change" = "link" ]; then
    if [ "$connected" = "yes" ] && [ ! -f "/tmp/.ppp0_connected" ]; then
        touch "/tmp/.ppp0_connected"
        log "$system_name interface current connection status= $connected"
    fi

    if [ "$connected" = "no" ] && [ -f "/tmp/.ppp0_connected" ]; then
        rm -f "/tmp/.ppp0_connected"
        log "$system_name interface current connection status= $connected"
    fi
fi
