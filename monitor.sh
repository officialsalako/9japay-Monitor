#!/bin/bash

# File to output the HTML dashboard
LOG_FILE="/var/www/html/9japay/server-monitor/system_monitor.html"

# Email recipient
EMAIL="victorsalako98@gmail.com"

# System monitoring variables
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEMORY_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
DISK_USAGE=$(df -h | awk '$NF=="/"{printf "%s", $5}')
UPTIME=$(uptime -p)

# Thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=75
DISK_THRESHOLD=85

# Start creating the HTML file
echo "<html><head><title>9jaPay Monitor Interface</title></head><body>" > $LOG_FILE
echo "<h1>9jaPay Monitor Interface</h1>" >> $LOG_FILE
echo "<p><strong>Date:</strong> $(date)</p>" >> $LOG_FILE
echo "<p><strong>CPU Usage:</strong> ${CPU_USAGE}%</p>" >> $LOG_FILE
echo "<p><strong>Memory Usage:</strong> ${MEMORY_USAGE}%</p>" >> $LOG_FILE
echo "<p><strong>Disk Usage:</strong> ${DISK_USAGE}</p>" >> $LOG_FILE
echo "<p><strong>Uptime:</strong> ${UPTIME}</p>" >> $LOG_FILE
echo "</body></html>" >> $LOG_FILE

# Email alert logic
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "Alert: CPU usage is ${CPU_USAGE}% (Threshold: ${CPU_THRESHOLD}%)" | mail -s "Server Alert: High CPU Usage" $EMAIL
fi

if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    echo "Alert: Memory usage is ${MEMORY_USAGE}% (Threshold: ${MEMORY_THRESHOLD}%)" | mail -s "Server Alert: High Memory Usage" $EMAIL
fi

if [[ ${DISK_USAGE%?} -gt $DISK_THRESHOLD ]]; then
    echo "Alert: Disk usage is ${DISK_USAGE} (Threshold: ${DISK_THRESHOLD}%)" | mail -s "Server Alert: High Disk Usage" $EMAIL
fi














































