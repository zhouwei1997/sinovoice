#!/bin/bash

source /hcicloud/.bash_profile
BASE_DIR=/hcicloud/shell/logs

# 定时任务
# */15 * * * * bash /hcicloud/shell/check.sh

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
fi

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 检测服务进程" >>${BASE_DIR}/check_$(date +%Y-%m-%d).log

for i in redis-server redis-sentinel consul; do
  num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
  if [ $num -eq 0 ]; then
          if [ $i == "redis-server" ];then
              cd /hcicloud/redis/
              echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) redis-server服务不存在，现在马上启动redis服务" >>${BASE_DIR}/check_$(date +%Y-%m-%d).log
              ./redis-server ./redis.conf
          elif [ $i == "redis-sentinel" ]; then
              cd /hcicloud/redis/
              echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) redis-sentinel服务不存在，现在马上启动redis-sentinel服务" >>${BASE_DIR}/check_$(date +%Y-%m-%d).log
               ./redis-sentinel ./sentinel.conf
          else
               cd /hcicloud/aicp/bin
               echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) consul服务不存在，现在启动consul服务" >>${BASE_DIR}/check_$(date +%Y-%m-%d).log
               ./consul -d
          fi
      else
          echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务正常" >>${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
  done
