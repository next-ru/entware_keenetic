#!/bin/sh

log_file="/opt/var/log/connection_checker.log"

log() {
    echo "$(date +"%b %d %Y %H:%M:%S") $1" >> "$log_file"
}

if [ ! -f "/tmp/.last_boot" ]; then
    touch "/tmp/.last_boot"
    log "system ready, uptime $(awk '{print int($1)}' /proc/uptime) seconds"
fi

if [ "$system_name" = "eth2.2" ]; then
    if [ "$link" = "up" ]; then
        if [ ! -f "/tmp/.eth2.2_up" ]; then
            log "eth2.2 interface is up"
            touch "/tmp/.eth2.2_up"
        fi
    else        
        if [ -f "/tmp/.eth2.2_up" ]; then
            log "eth2.2 interface is down"
            rm -f "/tmp/.eth2.2_up"
        fi
    fi
fi

if [ "$system_name" = "ppp0" ]; then
    if [ "$connected" = "yes" ]; then
        if [ ! -f "/tmp/.ppp0_connected" ]; then
            log "ppp0 interface is up"
            touch "/tmp/.ppp0_connected"
        fi
    else        
        if [ -f "/tmp/.ppp0_connected" ]; then
            log "ppp0 interface is down"
            rm -f "/tmp/.ppp0_connected"
        fi
    fi
fi
