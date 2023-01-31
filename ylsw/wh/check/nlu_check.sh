#!/bin/bash

# 定时任务
# */15 * * * * bash /hcicloud/shell/check.sh
# 使用hcicloud用户执行

source /hcicloud/.bash_profile
BASE_DIR=/hcicloud/shell/logs
CLOUD_DIR=/hcicloud/cloud

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
fi

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 开始检测服务进程" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
for i in zookeeper activemq servicefx_license_server servicefx_http_server servicefx_slb servicefx_nlu servicefx_nlu_sync; do
  num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
  if [ ${num} -eq 0 ];then
    if [ $i == "zookeeper" ];then
      cd /hcicloud/apache-zookeeper-3.5.6-bin/bin
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) zookeeper 服务不存在，现在马上启动zookeeper服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      ./zkServer.sh start
      if [ $(ps -ef | grep -v grep | grep -w zookeeper | wc -l) -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) zookeeper 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) zookeeper 服务启动失败，请查看日志并手动启动zookeeper服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "activemq" ]; then
      cd /hcicloud/apache-activemq-5.15.9/bin
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) activemq 服务不存在，现在马上启动 activemq 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      ./activemq start
      if [ $(ps -ef | grep -v grep | grep -w avtivemq | wc -l) -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) activemq 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) activemq 服务启动失败，请查看日志并手动启动 activemq 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "servicefx_license_server" ]; then
      cd ${CLOUD_DIR}/license_server/bin
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) license_server服务不存在，现在马上启动license_server服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      ./servicefx_license_server -d >>/dev/null 2>&1 &
      if [$(ps -ef | grep -v grep | grep -w servicefx_license_server | wc -l) -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) license_server 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) license_server 服务启动失败，请查看日志并手动启动 license_server 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "servicefx_http_server" ]; then
      cd ${CLOUD_DIR}/http_server/bin
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) http_server服务不存在，现在马上启动http_server服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      ./servicefx_http_server -d >>/dev/null 2>&1 &
      if [ $(ps -ef | grep -v grep | grep -w servicefx_http_server | wc -l) -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) http_server 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) http_server 服务启动失败，请查看日志并手动启动 http_server 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "servicefx_slb" ]; then
      cd ${CLOUD_DIR}/slb/bin
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) slb服务不存在，现在马上启动slb服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      ./servicefx_slb -d >>/dev/null 2>&1 &
      if [ $(ps -ef | grep -v grep | grep -w servicefx_slb) -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) slb 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) slb 服务启动失败，请查看日志并手动启动 slb 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "servicefx_nlu" ]; then
      cd ${CLOUD_DIR}/nlu/bin
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu服务不存在，现在马上启动nlu服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      ./servicefx_nlu -d >>/dev/null 2>&1 &
      if [ $(ps -ef | grep -v grep | grep -w servicefx_nlu | wc -l) -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) slb 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) slb 服务启动失败，请查看日志并手动启动 slb 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    else
      cd ${CLOUD_DIR}/nlu_sync/bin
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu_sync服务不存在，现在马上启动nlu_sync服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      ./servicefx_license_server -d >>/dev/null 2>&1 &
      if [ $(ps -ef | grep -v grep | grep -w servicefx_nlu_sync | wc -l) -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu_sync 服务启动成功" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu_sync 服务启动失败，请查看日志并手动启动 nlu_sync 服务" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
      fi
    fi
  else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务正常" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
  fi
done
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 本次检测完成" >> ${BASE_DIR}/check_$(date +%Y-%m-%d).log
