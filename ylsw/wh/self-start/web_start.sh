#!/bin/bash

# 使用root用户执行

BASE_DIR=/hcicloud/shell/logs
AICC_DIR=/hcicloud/aicc-znwh

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
fi

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 开始执行脚本" >>${BASE_DIR}/web_start_$(date +%Y-%m-%d).log

# 启动nginx
cd /hcicloud/nginx/sbin
./nginx
if [ $(ps -ef | grep -v grep | grep -w nginx | wc -l) -ne 0 ];then
  echo "$(date +%H:%M:%S) nginx 启动成功" >>${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
else
  echo "$(date +%H:%M:%S) nginx 启动失败，请手动启动 nginx " >>${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
fi


# 启动jar包
echo "$(date +%H:%M:%S) 开始启动外呼的服务进程" >>${BASE_DIR}/web_start_$(date +%Y-%m-%d).log

for i in aicc-config-server aicc-gateway aicc-system-server aicc-fileserver aicc-im-server aicc-znwh-sas aicc-znwh-server aicc-znwh-rtcs; do
  num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
  if [ ${num} -eq 0 ];then
    if [ $i == "aicc-config-server" ]; then
      cd ${AICC_DIR}/aicc-config-server
      sh startup.sh
      sleep 15
      if [ $(ps -ef | grep -v grep | grep -w aicc-config-server | wc -l) -eq 1 ];then
        echo "$(date +%H:%M:%S) aicc-config-server 服务启动成功" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-config-server 服务启动失败，请查看日志并手动启动 aicc-config-server 服务" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-gateway" ]; then
      cd ${AICC_DIR}/aicc-gateway
      sh startup.sh
      sleep 20
      if [ $(ps -ef | grep -v grep | grep -w aicc-gateway | wc -l) -eq 1 ];then
        echo "$(date +%H:%M:%S) aicc-gateway 服务启动成功" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-gateway 服务启动失败，请查看日志并手动启动 aicc-gateway 服务" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-system-server" ]; then
      cd ${AICC_DIR}/aicc-system-server
      sh startup.sh
      sleep 45
      if [ $(ps -ef | grep -v grep | grep -w aicc-system-server | wc -l) -eq 1 ];then
        echo "$(date +%H:%M:%S) aicc-system-server 服务启动成功" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-system-server 服务启动失败，请查看日志并手动启动 aicc-system-server 服务" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-fileserver" ]; then
      cd ${AICC_DIR}/aicc-fileserver
      sh startup.sh
      sleep 45
      if [ $(ps -ef | grep -v grep | grep -w aicc-fileserver | wc -l) -eq 1 ];then
        echo "$(date +%H:%M:%S) aicc-fileserver 服务启动成功" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-fileserver 服务启动失败，请查看日志并手动启动 aicc-fileserver 服务" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-im-server" ]; then
      cd ${AICC_DIR}/aicc-im-server
      sh startup.sh
      sleep 60
      if [ $(ps -ef | grep -v grep | grep -w aicc-im-server | wc -l) -eq 1 ];then
        echo "$(date +%H:%M:%S) aicc-im-server 服务启动成功" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-im-server 服务启动失败，请查看日志并手动启动 aicc-im-server 服务" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-znwh-sas" ];then
      cd ${AICC_DIR}/aicc-znwh-sas
      sh startup.sh
      sleep 60
      if [ $(ps -ef | grep -v grep | grep -w aicc-znwh-sas | wc -l) -eq 1 ];then
        echo "$(date +%H:%M:%S) aicc-znwh-sas 服务启动成功" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-znwh-sas 服务启动失败，请查看日志并手动启动 aicc-znwh-sas 服务" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "aicc-znwh-server" ]; then
      cd ${AICC_DIR}/aicc-znwh-server
      sh startup.sh
      sleep 60
      if [ $(ps -ef | grep -v grep | grep -w aicc-znwh-server | wc -l) -eq 1 ]; then
        echo "$(date +%H:%M:%S) aicc-znwh-server 服务启动成功" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      else
        echo "$(date +%H:%M:%S) aicc-znwh-server 服务启动失败，请查看日志并手动启动 aicc-znwh-server 服务" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      fi
    else [ $i == "aicc-znwh-rtcs" ]
      cd ${AICC_DIR}/aicc-znwh-rtcs
      sleep 30
      if [ $(ps -ef | grep -v grep | grep -w aicc-znwh-server | wc -l) -eq 1 ] && [ $(netstat -anp | grep 17110 | wc -l) -ne 0 ]; then
        sh startup.sh
        sleep 60
        if [ $(ps -ef | grep -v grep | grep -w aicc-znwh-rtcs | wc -l) -eq 1 ]; then
          echo "$(date +%H:%M:%S) aicc-znwh-rtcs 服务启动成功" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
        else
          echo "$(date +%H:%M:%S) aicc-znwh-rtcs 服务启动失败，请查看日志并手动启动 aicc-znwh-rtcs 服务" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
        fi
      else
        echo "$(date +%H:%M:%S) aicc-znwh-server 的进程不存在，请查看日志并手动启动 aicc-znwh-server 服务后，再启动 aicc-znwh-rtcs 服务" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
      fi
    fi
  else
    echo "$(date +%H:%M:%S) $i 服务正常" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
  fi
done

# 启动自学习模块
echo "$(date +%H:%M:%S) 开始启动 自学习 模块" >>${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
cd ${AICC_DIR}/aicc-znkf-python
python3 startup3.py
if [ $(ps -ef | grep -v grep | grep -w app.py | wc -l) -eq 1 ];then
  echo "$(date +%H:%M:%S) 自学习模块 服务启动成功" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
else
  echo "$(date +%H:%M:%S) 自学习模块 服务启动失败，请查看日志并手动启动 自学习模块 服务" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log
fi
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 本次脚本执行完成" >> ${BASE_DIR}/web_start_$(date +%Y-%m-%d).log