#!/bin/sh

if [ ! -f /tmp/.is_online ]; then
    exit 0
fi

curl -Lfz /opt/etc/nfqws/domains.list -o /opt/etc/nfqws/domains.list \
    $(curl -s https://api.github.com/repos/1andrevich/Re-filter-lists/releases/latest | grep -o '"browser_download_url": "[^"]*' | grep -o 'https://[^"]*domains_all.lst') > /dev/null 2>&1
