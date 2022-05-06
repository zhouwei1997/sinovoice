#!/bin/bash
# 本脚本适合于9232的ros和服务器使用
# 使用hcicloud_ta用户执行

source /home/hcicloud_ta/.bash_profile
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 检测服务进程" >>/app/check/logs/check_$(date +%Y-%m-%d).log
for i in servicefx_ros servicefx_text_analyze; do
    num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
    if [ $num -eq 0 ]; then
        if [ $i -eq 0 ]; then
            cd /home/hcicloud_ta/ros/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) ros服务不存在，现在马上启动ros服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./servicefx_ros -d >>/dev/null 2>&1 &
        else
            cd /home/hcicloud_ta/cloud/text_analyze/bin
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) text_analyze服务不存在，现在马上启动text_analyze服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./servicefx_text_analyze -d >>/dev/null 2>&1 &
        fi
    else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务正常" >>/app/check/logs/check_$(date +%Y-%m-%d).log
    fi
done
