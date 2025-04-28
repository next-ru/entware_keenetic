#!/bin/sh

if [ ! -f /tmp/.is_online ]; then
    exit 0
fi

if [ ! -f /opt/etc/nfqws/domains.list ]; then
    curl -f -L -o /opt/etc/nfqws/domains.list \
        $(curl -s https://api.github.com/repos/1andrevich/Re-filter-lists/releases/latest | grep -o '"browser_download_url": "[^"]*' | grep -o 'https://[^"]*domains_all.lst') > /dev/null 2>&1
else
    curl -f -L -z /opt/etc/nfqws/domains.list -o /opt/etc/nfqws/domains.list \
        $(curl -s https://api.github.com/repos/1andrevich/Re-filter-lists/releases/latest | grep -o '"browser_download_url": "[^"]*' | grep -o 'https://[^"]*domains_all.lst') > /dev/null 2>&1
fi
