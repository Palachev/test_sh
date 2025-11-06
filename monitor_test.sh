#!/bin/bash

LOG_FILE="/var/log/monitoring.log"
PID_FILE="/tmp/test.pid"
PROCESS_NAME="test"
MONITOR_URL="https://test.com/monitoring/test/api"

touch "$LOG_FILE"

CURRENT_PID=$(pgrep -x "$PROCESS_NAME") #CURRENT_PID=$(systemctl show -p MainPID dummy_test.service | cut -d= -f2) если мы запускаем через docker

if [ -n "$CURRENT_PID" ]; then 
    if [ -f "$PID_FILE" ]; then
        OLD_PID=$(cat "$PID_FILE")
        if [ "$OLD_PID" != "$CURRENT_PID" ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Процесс $PROCESS_NAME был перезапущен (PID изменился с $OLD_PID на $CURRENT_PID)" >> "$LOG_FILE"
        fi 
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Процесс $PROCESS_NAME запущен впервые (PID=$CURRENT_PID)" >> "$LOG_FILE"
    fi
    echo "$CURRENT_PID" > "$PID_FILE"

    if ! curl -fsS --max-time 5 "$MONITOR_URL" > /dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Сервер мониторинга недоступен: $MONITOR_URL" >> "$LOG_FILE"
    fi
fi