#!/usr/bin/env bash
set -e

echo "==============================================================="
echo "🚀 暴风资源（BFZY）中国大陆边缘网络穿透测试"
echo "==============================================================="

echo ""
echo "📍 [1/4] 正在探测当前构建节点的公网 IP 与地理位置..."
curl -s --connect-timeout 5 https://myip.ipip.net || curl -s --connect-timeout 5 https://ipapi.co/json | grep -E 'ip|country|city|org' || true

echo ""
echo "---------------------------------------------------------------"
echo "🎯 [2/4] 测试 1：暴风资源被封锁经典日漫《海贼王》第001集"
TARGET_URL1="https://c1.rrcdnbf2.com/video/haizeiwang/%E7%AC%AC001%E9%9B%86/index.m3u8"
echo "请求地址: $TARGET_URL1"

HTTP_STATUS1=$(curl -s -o /tmp/resp1.txt -w "%{http_code}" --connect-timeout 10 "$TARGET_URL1" || true)
echo "HTTP 状态码: $HTTP_STATUS1"

if [ "$HTTP_STATUS1" = "200" ]; then
    echo "🎉【大获全胜】暴风资源对中国大陆构建机完全放行！200 OK！"
    echo "M3U8 清单内容前 20 行预览:"
    head -n 20 /tmp/resp1.txt
else
    echo "⚠️ 返回状态码非 200，内容预览:"
    head -n 25 /tmp/resp1.txt
fi

echo ""
echo "---------------------------------------------------------------"
echo "🎯 [3/4] 测试 2：暴风资源新集群《夜王》"
TARGET_URL2="https://fengbao12.com/video/yewang_6e4841/e8d5017f618c/index.m3u8"
echo "请求地址: $TARGET_URL2"

HTTP_STATUS2=$(curl -s -o /tmp/resp2.txt -w "%{http_code}" --connect-timeout 10 "$TARGET_URL2" || true)
echo "HTTP 状态码: $HTTP_STATUS2"
if [ "$HTTP_STATUS2" = "200" ]; then
    echo "✅ 正常连通 200 OK！前 10 行预览:"
    head -n 10 /tmp/resp2.txt
fi

echo ""
echo "---------------------------------------------------------------"
echo "🎯 [4/4] 测试 3：暴风资源被封锁短剧《黑月光上线》"
TARGET_URL3="https://s3.bfllvip.com/video/heiyueguangshangxian/a3b8ad3120d2/index.m3u8"
echo "请求地址: $TARGET_URL3"

HTTP_STATUS3=$(curl -s -o /tmp/resp3.txt -w "%{http_code}" --connect-timeout 10 "$TARGET_URL3" || true)
echo "HTTP 状态码: $HTTP_STATUS3"
head -n 20 /tmp/resp3.txt || true

echo ""
echo "==============================================================="
echo "🏁 测试执行完毕！"
echo "==============================================================="
