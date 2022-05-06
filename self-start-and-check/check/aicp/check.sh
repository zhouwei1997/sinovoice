#!/bin/bash

# 本脚本适合于9232的asr服务器使用，aixp服务器只需要判断consul是否正常
# 使用hcicloud用户执行

source /home/hcicloud/.bash_profile
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 检测服务进程" >>/app/check/logs/check_$(date +%Y-%m-%d).log
num=$(ps -ef | grep -v grep | grep -w consul | wc -l)

if [ $num -ne 2 ]; then
    cd /home/hcicloud/aicp/bin
    ./consul
else
    "$(date +%Y-%m-%d) $(date +%H:%M:%S) consul 服务正常" >>/app/check/logs/check_$(date +%Y-%m-%d).log
fi
