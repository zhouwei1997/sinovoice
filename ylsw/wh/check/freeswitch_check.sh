#!/bin/bash

# 定时任务
# */15 * * * * bash /hcicloud/shell/check.sh
# 使用root用户执行

BASE_DIR=/hcicloud/shell/logs

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
    chown -R hcicloud:hcicloud ${BASE_DIR}
fi

echo "$(date +%H:%M:%S) 开始检测服务进程" >> ${BASE_DIR}/check_freeswitch_$(date +%Y-%m-%d).log
# 检测freeswitch的进程是否存在
if [ $(ps aux | grep -v grep | grep -w freeswitch | wc -l) -eq 0 ];then
  echo "$(date +%H:%M:%S) freeswitch 服务进程不存在，现在去启动freeswitch进程" >> ${BASE_DIR}/check_freeswitch_$(date +%Y-%m-%d).log
  cd /usr/local/freeswitch/bin
  ./freeswitch -nonat -nc
  sleep 60
  if [ $(ps aux | grep -v grep | grep -w freeswitch | wc -l) -eq 1 ];then
    echo "$(date +%H:%M:%S) freeswitch服务启动成功" >> ${BASE_DIR}/check_freeswitch_$(date +%Y-%m-%d).log
  else
    echo "$(date +%H:%M:%S) freeswitch 服务启动失败，请查看日志并手动启动 freeswitch 服务" >> ${BASE_DIR}/check_freeswitch_$(date +%Y-%m-%d).log
  fi
else
  echo "$(date +%H:%M:%S) freeswitch 服务正常" >> ${BASE_DIR}/check_freeswitch_$(date +%Y-%m-%d).log
fi
echo "$(date +%H:%M:%S) 本次检测完成" >> ${BASE_DIR}/check_freeswitch_$(date +%Y-%m-%d).log