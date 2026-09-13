#!/usr/bin/env bash
set -e

# 获取公网 IP
MY_IP=$(curl -s --connect-timeout 5 https://api.ipify.org || curl -s --connect-timeout 5 https://ifconfig.me || echo "unknown")
MY_GEO=$(curl -s --connect-timeout 5 "https://ipapi.co/${MY_IP}/json" | grep -E '"city"|"region"|"country_name"|"org"' | tr -d '\n' || echo "")

URL="https://c1.rrcdnbf2.com/video/haizeiwang/%E7%AC%AC001%E9%9B%86/index.m3u8"
RESP_FILE=$(mktemp)

STATUS=$(curl -s -o "$RESP_FILE" -w "%{http_code}" --connect-timeout 8 "$URL" || echo "000")

if [ "$STATUS" = "200" ]; then
    echo "🎯【命中白名单放行】IP: $MY_IP | HTTP 200 OK!"
    echo "📍 归属信息: $MY_GEO"
    echo "📄 M3U8 验证:"
    head -n 5 "$RESP_FILE"
else
    DEBUG_LINE=$(grep -A 4 "DEBUG:" "$RESP_FILE" | tr -d '\n' || true)
    echo "❌【阻断拦截】IP: $MY_IP | HTTP: $STATUS | $DEBUG_LINE"
fi

rm -f "$RESP_FILE"
