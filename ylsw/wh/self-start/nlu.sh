#!/bin/bash

# 使用hcicloud用户执行

# 存放log日志目录
BASE_DIR=/hcicloud/shell/logs
# nlu的安装路径
CLOUD_DIR=/hcicloud/cloud

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
fi

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 开始执行脚本" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
# 启动zookeeper
cd /hcicloud/apache-zookeeper-3.5.6-bin/bin
./zkServer.sh start
zoo_num=$(ps -ef | grep -v grep | grep -w zookeeper | wc -l)
if [ ${zoo_num} -eq 1 ];then
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) zookeeper 启动成功" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
else
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) zookeeper 启动失败，请手动启动 zookeeper " >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
fi

# 启动activemq
cd /hcicloud/apache-activemq-5.15.9/bin
./activemq start
activemq_num=$(ps -ef | grep -v grep | grep -w activemq | wc -l)
if [ ${activemq_num} -eq 1 ];then
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) activemq 启动成功" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
else
  echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) activemq 启动失败，请手动启动activemq" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
fi

# 启动nlu
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 开始启动nlu的服务进程" >>${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
cd ${CLOUD_DIR}/license_server/bin
./servicefx_license_server -d
sleep 10

cd ${CLOUD_DIR}/http_server/bin
./servicefx_http_server -d
sleep 10

cd ${CLOUD_DIR}/slb/bin
./servicefx_slb -d
sleep 10

cd ${CLOUD_DIR}/nlu/bin
./servicefx_nlu -d
sleep 10

cd ${CLOUD_DIR}/nlu_sync/bin
./servicefx_nlu_sync -d
sleep 10

for i in servicefx_license_server servicefx_http_server servicefx_slb servicefx_nlu servicefx_nlu_sync; do
  num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
  if [ ${num} -eq 0 ];then
    if [ $i == "servicefx_license_server" ]; then
      cd ${CLOUD_DIR}/license_server/bin
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) license_server服务启动失败，现在重新启动license_server服务" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      ./servicefx_license_server -d >>/dev/null 2>&1 &
      license=$(ps -ef | grep -v grep | grep -w servicefx_license_server | wc -l)
      if [ ${license} -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) license_server 服务重新启动成功" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) license_server 服务重新启动失败，请查看日志并手动启动 license_server 服务" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "servicefx_http_server" ]; then
      cd ${CLOUD_DIR}/http_server/bin
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) http_server服务启动，现在重新启动http_server服务" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      ./servicefx_http_server -d >>/dev/null 2>&1 &
      http_num=$(ps -ef | grep -v grep | grep -w servicefx_http_server | wc -l)
      if [ ${http_num} -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) http_server 服务重新启动成功" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) http_server 服务重新启动失败，请查看日志并手动启动 http_server 服务" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "servicefx_slb" ]; then
      cd ${CLOUD_DIR}/slb/bin
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) slb服务启动失败，现在重新启动slb服务" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      ./servicefx_slb -d >>/dev/null 2>&1 &
      slb=$(ps -ef | grep -v grep | grep -w servicefx_slb)
      if [ ${slb} -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) slb 服务重新启动成功" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      else
         echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) slb 服务重新启动失败，请查看日志并手动启动 slb 服务" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      fi
    elif [ $i == "servicefx_nlu" ]; then
      cd ${CLOUD_DIR}/nlu/bin
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu服务启动失败，现在重新启动nlu服务" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      ./servicefx_nlu -d >>/dev/null 2>&1 &
      nlu_num=$(ps -ef | grep -v grep | grep -w servicefx_nlu | wc -l)
      if [ ${nlu_num} -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) slb 服务重新启动成功" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) slb 服务重新启动失败，请查看日志并手动启动 slb 服务" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      fi
    else
      cd ${CLOUD_DIR}/nlu_sync/bin
      echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu_sync服务启动失败，现在重新启动nlu_sync服务" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      ./servicefx_license_server -d >>/dev/null 2>&1 &
      nlu_sync=$(ps -ef | grep -v grep | grep -w servicefx_nlu_sync | wc -l)
      if [ ${nlu_num} -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu_sync 服务重新启动成功" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nlu_sync 服务重新启动失败，请查看日志并手动启动 nlu_sync 服务" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
      fi
    fi
  else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务启动成功" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log
  fi
done
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 本次启动完成" >> ${BASE_DIR}/self_start_$(date +%Y-%m-%d).log

