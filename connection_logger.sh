#!/bin/sh

log_file="/opt/var/log/netmon.log"
sites="https://api.ipify.org https://checkip.amazonaws.com https://icanhazip.com"
local_ip="$address"

is_running() {
    local pid_file="/opt/var/run/$1.pid"
    if [ ! -f "$pid_file" ]; then
        return 1
    fi
    pid=$(cat "$pid_file" 2>/dev/null)
    if kill -0 "$pid" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

get_public_ip() {
    curl -s "$1"
}

log() {
    echo "$(date +"%b %d %Y %H:%M:%S") $1" >> "$log_file"
}

# reconnect_pppoe() {
    # log "Carrier-Grade NAT detected (local IP address $local_ip), reconnecting PPPoE..."
    # curl -X DELETE "http://localhost:79/rci/interface/connect?name=PPPoE0" >/dev/null 2>&1
    # sleep 2
    # curl -X POST -d '{}' "http://localhost:79/rci/interface/connect?name=PPPoE0&via=ISP" >/dev/null 2>&1
    # sleep 5
# }

case "$1" in
    start)
        if [ -f "/tmp/.is_online" ]; then
            exit 0
        fi		
		
        touch /tmp/.is_online
		
        while [ ! -f /tmp/.ppp0_connected ]; do
            sleep 1
        done				

        # if echo "$local_ip" | grep -q '^100\.'; then
            # reconnect_pppoe
        # fi

        log "Internet access detected"

        while true; do
            for site in $sites; do
                public_ip=$(get_public_ip "$site")
                if [ -n "$public_ip" ]; then
                    log "local IP address $local_ip public IP address $public_ip"
                    break 2
                fi
                sleep 1
            done
        done

        if is_running "AdGuardHome"; then
            log "Service AdGuardHome is already running"
        else
            log "Starting AdGuardHome service"
            /opt/etc/init.d/K99adguardhome start
        fi

        if is_running "nfqws"; then
            log "Service NFQWS is already running"
        else
            log "Starting NFQWS service"
            /opt/etc/init.d/K51nfqws start
        fi
        ;;

    stop)
        log "Internet access lost"
        rm -f /tmp/.is_online

        for i in $(seq 1 15); do
            if curl -s http://localhost:79/rci/show/internet/status | grep -q '"internet": true'; then
                exit 0
            fi
            sleep 1
        done

        if is_running "AdGuardHome"; then
            log "Stopping AdGuardHome service"
            /opt/etc/init.d/K99adguardhome stop
        else
            log "Service AdGuardHome is not running"
        fi

        if is_running "nfqws"; then
            log "Stopping NFQWS service"
            /opt/etc/init.d/K51nfqws stop
        else
            log "Service NFQWS is not running"
        fi
        ;;
esac
