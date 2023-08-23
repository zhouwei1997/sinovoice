#!/bin/bash

# root   freeswitch
# hcicloud  web

# su - hcicloud -s /bin/bash /hcicloud/shell/web.sh

BASE_DIR=/hcicloud/shell/logs
LOGS_NAME=web_$(date +%Y-%m-%d).log
DIR_HOME=/hcicloud/aicc-znwh/

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
    chown -R hcicloud:hcicloud ${BASE_DIR}
    chmod 777 ${BASE_DIR}
fi

sh ${DIR_HOME}/aicc-config-server/startup.sh && sleep 15
sh ${DIR_HOME}/aicc-gateway/startup.sh && sleep 30
sh ${DIR_HOME}/aicc-system-server/startup.sh && sleep 30
sh ${DIR_HOME}/aicc-fileserver/startup.sh && sleep 15
sh ${DIR_HOME}/aicc-im-server/startup.sh && sleep 30
sh ${DIR_HOME}/aicc-znwh-sas/startup.sh && sleep 45
sh ${DIR_HOME}/aicc-znwh-server/startup.sh && sleep 90
sh ${DIR_HOME}/aicc-znwh-rtcs/startup.sh && sleep 30

aicc-config-server_num=$(ps -ef | grep -v grep | grep -v aicc-config-server-1.0.0.jar | wc -l)
aicc-gateway_num=$(ps -ef | grep -v grep | grep -v aicc-gateway-1.0.0.jar | wc -l)
aicc-system-server_num=$(ps -ef | grep -v grep | grep -v aicc-system-server-9.0.5.jar | wc -l)
aicc-fileserver_num=$(ps -ef | grep -v grep | grep -v aicc-fileserver-1.0.1.jar | wc -l)
aicc-im-server_num=$(ps -ef | grep -v grep | grep -v aicc-im-server-1.0.0.jar | wc -l)
aicc-znwh-sas_num=$(ps -ef | grep -v grep | grep -v aicc-znwh-sas-9.6.0.9.jar | wc -l)
aicc-znwh-server_num=$(ps -ef | grep -v grep | grep -v aicc-znwh-server-9.6.0.9.jar | wc -l)
aicc-znwh-rtcs_num=$(ps -ef | grep -v grep | grep -v aicc-znwh-rtcs-9.6.0.9.jar | wc -l)

# 启动aicc-config-server
if [ ${aicc-config-server_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-config-server 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd ${DIR_HOME}/aicc-config-server
    sh startup.sh
    sleep 10
fi

# 启动aicc-gateway
if [ ${aicc-gateway_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-gateway 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd ${DIR_HOME}/aicc-gateway
    sh startup.sh
    sleep 30
fi

# 启动aicc-system-server
if [ ${aicc-system-server_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-system-server 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd ${DIR_HOME}/aicc-system-server
    sh startup.sh
    sleep 30
fi

# 启动aicc-fileserver
if [ ${aicc-fileserver_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-fileserver 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd ${DIR_HOME}/aicc-fileserver
    sh startup.sh
    sleep 30
fi

# 启动aicc-im-server
if [ ${aicc-im-server_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-im-server 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd ${DIR_HOME}/aicc-im-server
    sh startup.sh
    sleep 30
fi

# 启动aicc-znwh-sas
if [ ${aicc-znwh-sas_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-znwh-sas 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd ${DIR_HOME}/aicc-znwh-sas
    sh startup.sh
    sleep 30
fi

# 启动aicc-znwh-server
if [ ${aicc-znwh-server_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-znwh-server 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd ${DIR_HOME}/aicc-znwh-server
    sh startup.sh
    sleep 30
fi

# 启动aicc-znwh-rtcs
if [ ${aicc-znwh-rtcs_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-znwh-rtcs 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd ${DIR_HOME}/aicc-znwh-rtcs
    sh startup.sh
    sleep 30
fi