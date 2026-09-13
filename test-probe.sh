#!/usr/bin/env bash
set -e

echo "==============================================================="
echo "🚀 暴风资源（BFZY）全维度网络探针测试"
echo "==============================================================="

echo ""
echo "📍 [1/5] 当前探测节点网络与公网 IP 信息："
curl -s --connect-timeout 5 https://ipapi.co/json | grep -E '"ip"|"city"|"region"|"country_name"|"org"|"asn"' || curl -s https://myip.ipip.net || echo "无法获取公网IP信息"

echo ""
echo "---------------------------------------------------------------"
echo "🎯 [2/5] 测试 1：暴风资源老集群《海贼王》第001集 M3U8"
URL1="https://c1.rrcdnbf2.com/video/haizeiwang/%E7%AC%AC001%E9%9B%86/index.m3u8"
echo "目标地址: $URL1"
STATUS1=$(curl -s -o /tmp/resp1.txt -w "%{http_code}" --connect-timeout 10 "$URL1" || true)
echo "HTTP 状态码: $STATUS1"
if [ "$STATUS1" = "200" ]; then
    echo "🎉 状态: 200 OK 放行！M3U8 前 5 行:"
    head -n 5 /tmp/resp1.txt
else
    echo "⚠️ 状态: $STATUS1 拦截！返回内容:"
    head -n 10 /tmp/resp1.txt
fi

echo ""
echo "---------------------------------------------------------------"
echo "🎯 [3/5] 测试 2：暴风资源老集群《海贼王》第001集 TS 切片"
TS_URL="https://c1.rrcdnbf2.com/video/haizeiwang/%E7%AC%AC001%E9%9B%86/0000000.ts"
echo "目标地址: $TS_URL"
STATUS_TS=$(curl -s -o /tmp/resp_ts.bin -w "%{http_code}" --connect-timeout 10 "$TS_URL" || true)
TS_SIZE=$(wc -c < /tmp/resp_ts.bin | tr -d ' ')
echo "HTTP 状态码: $STATUS_TS, 响应大小: $TS_SIZE 字节"
if [ "$STATUS_TS" = "200" ]; then
    echo "🎉 状态: 200 OK 切片放行！"
else
    echo "⚠️ 状态: $STATUS_TS 切片拦截！"
fi

echo ""
echo "---------------------------------------------------------------"
echo "🎯 [4/5] 测试 3：暴风资源新集群《夜王》"
URL2="https://fengbao12.com/video/yewang_6e4841/e8d5017f618c/index.m3u8"
echo "目标地址: $URL2"
STATUS2=$(curl -s -o /tmp/resp2.txt -w "%{http_code}" --connect-timeout 10 "$URL2" || true)
echo "HTTP 状态码: $STATUS2"
if [ "$STATUS2" = "200" ]; then
    echo "✅ 状态: 200 OK 正常连通！"
else
    echo "⚠️ 状态: $STATUS2 异常！"
fi

echo ""
echo "---------------------------------------------------------------"
echo "🎯 [5/5] 测试 4：暴风资源短剧集群《黑月光上线》"
URL3="https://s3.bfllvip.com/video/heiyueguangshangxian/a3b8ad3120d2/index.m3u8"
echo "目标地址: $URL3"
STATUS3=$(curl -s -o /tmp/resp3.txt -w "%{http_code}" --connect-timeout 10 "$URL3" || true)
echo "HTTP 状态码: $STATUS3"
if [ "$STATUS3" = "200" ]; then
    echo "✅ 状态: 200 OK 放行！"
else
    echo "⚠️ 状态: $STATUS3 拦截！"
fi

echo ""
echo "==============================================================="
echo "🏁 测试结论："
echo "海贼王M3U8: $STATUS1 | 海贼王TS: $STATUS_TS | 夜王: $STATUS2 | 黑月光: $STATUS3"
echo "==============================================================="
