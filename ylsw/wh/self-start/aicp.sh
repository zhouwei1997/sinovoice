#!/bin/bash

# 使用hcicloud用户执行

BASE_DIR=/hcicloud/shell/logs

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
fi

# 启动redis

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 开始执行脚本" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log

cd /hcicloud/redis/
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 启动redis" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
./redis-server ./redis.conf
./redis-sentinel ./sentinel.conf

redis_num=$(ps -ef | grep -v grep | grep -w redis-server | wc -l)
if [ ${redis_num} -eq 1 ];then
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) redis-server 启动成功" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
else
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) redis-server 启动失败，请手动启动redis-server" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
fi

sentinel_num=$(ps -ef | grep -v grep | grep -w redis-sentinel | wc -l)
if [ ${sentinel_num} -eq 1 ]; then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) redis-sentinel 启动成功" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) redis-sentinel 启动失败，请手动启动redis-server" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
fi

cd /hcicloud/aicp/bin/
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 启动consul" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
./consul -d
consul_num=$(ps -ef | grep -v grep | grep -w consul | wc -l)
if [ ${consul_num} -eq 2 ];then
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) consul 启动成功" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
else
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) consul 启动失败，请手动启动redis-server" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
fi

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 完成脚本执行" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log

