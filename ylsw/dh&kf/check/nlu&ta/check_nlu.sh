#!/bin/bash

# 本脚本适合于9232的nlu服务器使用
# 使用hcicloud用户执行

source /home/hcicloud/.bash_profile
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 检测服务进程" >>/app/check/logs/check_$(date +%Y-%m-%d).log

for i in zookeeper activemq redis servicefx_license_server servicefx_http_server servicefx_slb servicefx_nlu servicefx_nlu_sync; do
    num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
    if [ $num -eq 0 ]; then
        if [ $i == "zookeeper" ]; then
            cd /app/zookeeper-3.4.9/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) zookeeper服务不存在，现在马上启动zookeeper服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./zkServer.sh start
        elif [ $i == "activemq" ]; then
            cd /app/apache-activemq-5.15.9/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) activemq服务不存在，现在马上启动activemq服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./activemq start
        elif [ $i == "redis" ]; then
            cd /app/redis
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) redis服务不存在，现在马上启动redis服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./redis-server ./redis.conf
        elif [ $i == "servicefx_license_server" ]; then
            cd /home/hcicloud/cloud/license_server/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) license_server服务不存在，现在马上启动license_server服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./servicefx_license_server -d >>/dev/null 2>&1 &
            sleep 60
            if [ $(ps -ef | grep -v grep | grep -w servicefx_license_server | wc -l) -gt 1 ];then
                ps -ef | grep servicefx_license_server | grep -v grep | awk '{print $2}' | xargs kill -9
                cd /home/hcicloud/cloud/license_server/bin
                echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) license_server服务异常，进程数大于 1 ，现在重新启动license_server服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
                ./servicefx_license_server -d >>/dev/null 2>&1 &
            fi
        elif [ $i == "servicefx_http_server" ]; then
            cd /home/hcicloud/cloud/http_server/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) http_server服务不存在，现在马上启动http_server服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./servicefx_http_server -d >>/dev/null 2>&1 &
            sleep 60
            if [ $(ps -ef | grep -v grep | grep -w servicefx_http_server | wc -l) -gt 1 ];then
                ps -ef | grep servicefx_http_server | grep -v grep | awk '{print $2}' | xargs kill -9
                cd /home/hcicloud/cloud/http_server/bin
                echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) http_server服务异常，进程数大于 1 ，现在重新启动license_server服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
                ./servicefx_http_server -d >>/dev/null 2>&1 &
            fi
        elif [ $i == "servicefx_slb" ]; then
            cd /home/hcicloud/cloud/slb/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) slb服务不存在，现在马上启动slb服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./servicefx_slb -d >>/dev/null 2>&1 &
            if [ $(ps -ef | grep -v grep | grep -w servicefx_slb | wc -l) -gt 1 ];then
                ps -ef | grep servicefx_slb | grep -v grep | awk '{print $2}' | xargs kill -9
                cd /home/hcicloud/cloud/slb/bin
                echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) servicefx_slb服务异常，进程数大于 1 ，现在重新启动 slb 服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
                ./servicefx_slb -d >>/dev/null 2>&1 &
            fi
        elif [ $i == "servicefx_nlu" ]; then
            cd /home/hcicloud/cloud/nlu/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu服务不存在，现在马上启动nlu服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./servicefx_nlu -d >>/dev/null 2>&1 &
            if [ $(ps -ef | grep -v grep | grep -w servicefx_nlu | wc -l) -gt 1 ];then
                ps -ef | grep servicefx_nlu | grep -v grep | awk '{print $2}' | xargs kill -9
                cd /home/hcicloud/cloud/nlu/bin
                echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu 服务异常，进程数大于 1 ，现在重新启动 nlu 服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
                ./servicefx_nlu -d >>/dev/null 2>&1 &
            fi
        else
            cd /home/hcicloud/cloud/nlu_sync/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu_sync服务不存在，现在马上启动nlu_sync服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./servicefx_nlu_sync -d >>/dev/null 2>&1 &
            if [ $(ps -ef | grep -v grep | grep -w servicefx_nlu_sync | wc -l) -gt 1 ];then
                ps -ef | grep servicefx_nlu_sync | grep -v grep | awk '{print $2}' | xargs kill -9
                cd /home/hcicloud/cloud/nlu_sync/bin
                echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu_sync 服务异常，进程数大于 1 ，现在重新启动 nlu_sync 服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
                ./servicefx_nlu_sync -d >>/dev/null 2>&1 &
            fi
        fi
    else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务正常" >>/app/check/logs/check_$(date +%Y-%m-%d).log
    fi
done
