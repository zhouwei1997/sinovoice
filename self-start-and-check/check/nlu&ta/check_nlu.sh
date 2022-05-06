#!/bin/bash

# 本脚本适合于9232的nlu服务器使用
# 使用hcicloud用户执行

source /home/hcicloud/.bash_profile
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 检测服务进程" >>/app/check/logs/check_$(date +%Y-%m-%d).log

for i in redis zookeeper activemq servicefx_license_server servicefx_http_server servicefx_slb servicefx_nlu
servicefx_nlu_sync; do
    num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
    if [ $num -eq 0 ]; then
        if [ $i == "redis" ];then
            cd /app/redis/
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) redis 服务不存在，现在马上启动redis服务" >>/app/check/logs/check_$(date
            +%Y-%m-%d).log
            ./redis-server ./redis.conf
        elif [ $i == "zookeeper" ]; then
            cd /app/zookeeper-3.4.9/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) zookeeper服务不存在，现在马上启动zookeeper服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./zkServer.sh start
        elif [ $i == "activemq" ]; then
            cd /app/apache-activemq-5.15.9/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) activemq服务不存在，现在马上启动activemq服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./activemq start
        elif [ $i == "servicefx_license_server" ]; then
            cd /home/hcicloud/cloud/license_server/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) license_server服务不存在，现在马上启动license_server服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./servicefx_license_server -d >>/dev/null 2>&1 &
        elif [ $i == "servicefx_http_server" ]; then
            cd /home/hcicloud/cloud/http_server/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) http_server服务不存在，现在马上启动http_server服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./servicefx_http_server -d >>/dev/null 2>&1 &
        elif [ $i == "servicefx_slb" ]; then
            cd /home/hcicloud/cloud/slb/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) slb服务不存在，现在马上启动slb服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./servicefx_slb -d >>/dev/null 2>&1 &
        elif [ $i == "servicefx_nlu" ]; then
            cd /home/hcicloud/cloud/nlu/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu服务不存在，现在马上启动nlu服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./servicefx_nlu -d >>/dev/null 2>&1 &
        else
            cd /home/hcicloud/cloud/nlu_sync/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu_sync服务不存在，现在马上启动nlu_sync服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./servicefx_license_server -d >>/dev/null 2>&1 &
        fi
    else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务正常" >>/app/check/logs/check_$(date +%Y-%m-%d).log
    fi
done
