#!/bin/bash

# 定时任务
# */15 * * * * bash /hcicloud/shell/check.sh
# 使用hcicloud用户执行

BASE_DIR=/hcicloud/shell/logs

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
    chown -R hcicloud:hcicloud ${BASE_DIR}
fi

source /hcicloud/.bash_profile
AICC_DIR=/hcicloud/aicc-znwh

echo "$(date +%H:%M:%S) 开始检测服务进程" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
for i in nginx aicc-config-server aicc-gateway aicc-system-server aicc-fileserver aicc-im-server aicc-znwh-sas aicc-znwh-server aicc-znwh-rtcs app.py; do
  num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
  if [ ${num} -eq 0 ];then
    if [ $i == "nginx" ];then
      cd /hcicloud/nginx/sbin
      echo "$(date +%H:%M:%S) nginx 服务不存在，现在马上启动 nginx 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      ./nginx
      sleep 10
      if [ $(ps -ef | grep -v grep | grep -c nginx | wc -l) -ne 0 ];then
        echo "$(date +%H:%M:%S) nginx 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) nginx 服务启动失败，请查看日志并手动启动nginx服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-config-server" ]; then
      cd ${AICC_DIR}/aicc-config-server
      echo "$(date +%H:%M:%S) aicc-config-server 服务不存在，现在马上启动 aicc-config-server 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      sh startup.sh
      sleep 30
      if [ $(ps -ef | grep -v grep | grep -w aicc-config-server | wc -l) -eq 1 ];then
        echo "$(date +%H:%M:%S) aicc-config-server 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-config-server 服务启动失败，请查看日志并手动启动 aicc-config-server 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-gateway" ]; then
      cd ${AICC_DIR}/aicc-gateway
      echo "$(date +%H:%M:%S) aicc-gateway 服务不存在，现在马上启动 aicc-gateway 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      sh startup.sh
      sleep 30
      if [ $(ps -ef | grep -v grep | grep -w aicc-gateway | wc -l) -eq 1 ];then
        echo "$(date +%H:%M:%S) aicc-gateway 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-gateway 服务启动失败，请查看日志并手动启动 aicc-gateway 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-system-server" ]; then
      cd ${AICC_DIR}/aicc-system-server
      echo "$(date +%H:%M:%S) aicc-system-server 服务不存在，现在马上启动 aicc-system-server 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      sh startup.sh
      sleep 45
      if [ $(ps -ef | grep -v grep | grep -w aicc-system-server | wc -l) -eq 1 ];then
        echo "$(date +%H:%M:%S) aicc-system-server 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-system-server 服务启动失败，请查看日志并手动启动 aicc-system-server 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-fileserver" ]; then
      cd ${AICC_DIR}/aicc-fileserver
      echo "$(date +%H:%M:%S)  aicc-fileserver 服务不存在，现在马上启动 aicc-fileserver 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      sh startup.sh
      sleep 30
      if [ $(ps -ef | grep -v grep | grep -w aicc-fileserver | wc -l) -eq 1 ];then
        echo "$(date +%H:%M:%S) aicc-fileserver 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-fileserver 服务启动失败，请查看日志并手动启动 aicc-fileserver 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-im-server" ]; then
      cd ${AICC_DIR}/aicc-im-server
      echo "$(date +%H:%M:%S) aicc-im-server 服务不存在，现在马上启动 aicc-im-server 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      sh startup.sh
      sleep 30
      if [ $(ps -ef | grep -v grep | grep -w aicc-im-server) -eq 1 ];then
        echo "$(date +%H:%M:%S) aicc-im-server 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-im-server 服务启动失败，请查看日志并手动启动 aicc-im-server 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-znwh-sas" ];then
      cd ${AICC_DIR}/aicc-znwh-sas
      echo "$(date +%H:%M:%S) aicc-znwh-sas 服务不存在，现在马上启动 aicc-znwh-sas 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      sh startup.sh
      sleep 45
      if [ $(ps -ef | grep -v grep | grep -w aicc-znwh-sas) -eq 1 ];then
        echo "$(date +%H:%M:%S) aicc-znwh-sas 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-znwh-sas 服务启动失败，请查看日志并手动启动 aicc-znwh-sas 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-znwh-server" ]; then
      cd ${AICC_DIR}/aicc-znwh-server
      echo "$(date +%H:%M:%S) aicc-znwh-server 服务不存在，现在马上启动 aicc-znwh-server 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      sh startup.sh
      sleep 60
      if [ $(ps -ef | grep -v grep | grep -w aicc-znwh-server | wc -l) -eq 1 ]; then
        echo "$(date +%H:%M:%S) aicc-znwh-server 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-znwh-server 服务启动失败，请查看日志并手动启动 aicc-znwh-server 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-znwh-rtcs" ]; then
      cd ${AICC_DIR}/aicc-znwh-rtcs
      if [ $(ps -ef | grep -v grep | grep -w aicc-znwh-server | wc -l) -eq 1 ] && [ $(netstat -anp | grep 17110 | wc -l) -ne 0 ]; then
        echo "$(date +%H:%M:%S) aicc-znwh-rtcs 服务不存在，现在马上启动 aicc-znwh-rtcs 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
        sh startup.sh
        sleep 60
        if [ $(ps -ef | grep -v grep | grep -w aicc-znwh-rtcs | wc -l) -eq 1 ]; then
          echo "$(date +%H:%M:%S) aicc-znwh-rtcs 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
        else
          echo "$(date +%H:%M:%S) aicc-znwh-rtcs 服务启动失败，请查看日志并手动启动 aicc-znwh-rtcs 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
        fi
      else
        echo "$(date +%H:%M:%S) aicc-znwh-server 的进程不存在，请查看日志并手动启动 aicc-znwh-server 服务后，再启动 aicc-znwh-rtcs 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    else
      cd ${AICC_DIR}/aicc-znkf-python
      echo "$(date +%H:%M:%S) 自学习模块 服务不存在，现在马上启动 自学习模块 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      python3 startup3.py
      if [ $(ps -ef | grep -v grep | grep -w app.py | wc -l) -eq 1 ];then
       echo "$(date +%H:%M:%S) 自学习模块 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) 自学习模块 服务启动失败，请查看日志并手动启动 自学习模块 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    fi
  else
    echo "$(date +%H:%M:%S) $i 服务正常" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
  fi
done
echo "$(date +%H:%M:%S) 本次检测完成" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
