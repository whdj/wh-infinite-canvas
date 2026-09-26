#!/bin/bash
cd "$(dirname "$0")"
LAN_IP="$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)"
if [ -z "$LAN_IP" ]; then
  LAN_IP="$(hostname -I 2>/dev/null | awk '{print $1}')"
fi
if [ -z "$LAN_IP" ]; then
  LAN_IP="127.0.0.1"
fi
export WH_CANVAS_PORT="${WH_CANVAS_PORT:-3001}"
APP_URL="http://${LAN_IP}:${WH_CANVAS_PORT}/"

echo "Starting WH Infinite Canvas..."
echo "Visit: ${APP_URL}"
echo "Local: http://127.0.0.1:${WH_CANVAS_PORT}/"
echo "Press Ctrl+C to stop."
echo ""

# Open browser after 3 seconds
sleep 3 && open "${APP_URL}" &

python3 main.py

echo ""
echo "Server stopped."
