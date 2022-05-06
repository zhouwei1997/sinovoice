#!/bin/bash

# 本脚本适合于9232的web服务器使用
# 使用hcicloud用户执行

source /home/hcicloud/.bash_profile
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 检测服务进程" >>/app/check/logs/check_$(date +%Y-%m-%d).log

for i in aicc-config-server aicc-fileserver aicc-system-server aicc-robot-service aicc-robot-server aicc-znkf-server; do
    num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
    if [ $num -eq 0 ]; then
        if [ $i == "aicc-config-server" ]; then
            cd /app/aicc/aicc-robot/aicc-config-server
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-config-server服务不存在，现在马上启动aicc-config-server服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            sh startup.sh
            sleep 10
        elif [ $i == "aicc-fileserver" ]; then
            cd /app/aicc/aicc-robot/aicc-fileserver
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-fileserver服务不存在，现在马上启动aicc-fileserver服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            sh startup.sh
            sleep 15
        elif [ $i == "aicc-system-server" ]; then
            cd /app/aicc/aicc-robot/aicc-system-server
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-system-server服务不存在，现在马上启动aicc-system-server服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            sh startup.sh
            sleep 30
        elif [ $i == "aicc-robot-service" ]; then
            cd /app/aicc/aicc-robot/aicc-robot-service
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-robot-service服务不存在，现在马上启动aicc-robot-service服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            sh startup.sh
            sleep 30
        elif [ $i == "aicc-robot-server" ]; then
            cd /app/aicc/aicc-robot/aicc-robot-server
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-robot-server服务不存在，现在马上启动aicc-robot-server服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            sh startup.sh
            sleep 30
        elif [ $i == "aicc-znkf-server" ]; then
            cd /app/aicc/aicc-znkf/aicc-znkf-server
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-znkf-server服务不存在，现在马上启动aicc-znkf-server服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            sh startup.sh
            sleep 30
        fi
    else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务正常" >>/app/check/logs/check_$(date +%Y-%m-%d).log
    fi
done
