#!/bin/sh

if [ ! -f /tmp/.is_online ]; then
    exit 0
fi

# КТТС
curl -s 'https://kttc.ru/wot/ru/statistics/user/update/2245/' \
  -X 'POST' \
  -H 'accept: application/json, text/javascript, */*; q=0.01' \
  -H 'accept-language: ru-RU,ru;q=0.9' \
  -H 'content-length: 0' \
  -H 'origin: https://kttc.ru' \
  -H 'priority: u=1, i' \
  -H 'referer: https://kttc.ru/' \
  -H 'sec-ch-ua: "Google Chrome";v="135", "Not-A.Brand";v="8", "Chromium";v="135"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36' \
  -H 'x-requested-with: XMLHttpRequest' \
  > /dev/null 2>&1

# WOT-O-Matic
curl -s 'http://wotomatic.net/?search=Next&update' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'Accept-Language: ru-RU,ru;q=0.9' \
  -H 'Cache-Control: max-age=0' \
  -H 'Connection: keep-alive' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36' \
  --insecure \
  > /dev/null 2>&1

# TANKI.lOl
curl -s 'https://tanki.lol/ru/players/ruby/2245/Next/sessions/30' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: ru-RU,ru;q=0.9' \
  -H 'priority: u=0, i' \
  -H 'referer: https://tanki.lol/ru/players/ruby/2245/Next/' \
  -H 'sec-ch-ua: "Google Chrome";v="135", "Not-A.Brand";v="8", "Chromium";v="135"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36' \
  > /dev/null 2>&1
  