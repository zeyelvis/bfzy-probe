#!/usr/bin/env bash
set -e

MY_IP=$(curl -s --connect-timeout 5 https://api.ipify.org || echo "unknown")
URL_M3U8="https://c1.rrcdnbf2.com/video/haizeiwang/%E7%AC%AC001%E9%9B%86/index.m3u8"
URL_TS="https://c1.rrcdnbf2.com/video/haizeiwang/%E7%AC%AC001%E9%9B%86/0000000.ts"

RESP_M3U8=$(mktemp)
RESP_TS=$(mktemp)

STATUS_M3U8=$(curl -s -o "$RESP_M3U8" -w "%{http_code}" --connect-timeout 8 "$URL_M3U8" || echo "000")
STATUS_TS=$(curl -s -o "$RESP_TS" -w "%{http_code}" --connect-timeout 8 "$URL_TS" || echo "000")
TS_SIZE=$(wc -c < "$RESP_TS" | tr -d ' ')

if [ "$STATUS_M3U8" = "200" ]; then
    echo "🎉【命中放行网段】IP: $MY_IP"
    echo "M3U8 状态: $STATUS_M3U8 OK"
    echo "TS 切片状态: $STATUS_TS (大小: $TS_SIZE 字节)"
    if [ "$STATUS_TS" = "200" ]; then
        echo "🚀【突破性大成】视频切片 0000000.ts 同样完全放行 200 OK！"
    fi
else
    DEBUG_LINE=$(grep -A 3 "DEBUG:" "$RESP_M3U8" | tr -d '\n' || true)
    echo "❌【阻断】IP: $MY_IP | $DEBUG_LINE"
fi

rm -f "$RESP_M3U8" "$RESP_TS"
