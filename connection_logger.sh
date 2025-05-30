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

service_action() {
    local service_name="$1"
    local action="$2"
    if [ "$action" = "start" ]; then
        if is_running "$service_name"; then
            log "Service $service_name is already running"
        else
            log "Starting $service_name service"
            /opt/etc/init.d/${service_name} start
        fi
    elif [ "$action" = "stop" ]; then
        if is_running "$service_name"; then
            log "Stopping $service_name service"
            /opt/etc/init.d/${service_name} stop
        else
            log "Service $service_name is not running"
        fi
    fi
}

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

        service_action "K99adguardhome" "start"
        service_action "K51nfqws" "start"
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

        service_action "K99adguardhome" "stop"
        service_action "K51nfqws" "stop"
        ;;
esac
