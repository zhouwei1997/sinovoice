#!/bin/bash
# 10.11.112.125 服务器自启动脚本
# hcicloud   nginx/es/zk/activemq/web应用
# su - hcicloud -s /bin/bash /data/shell/10.11.112.125.sh

BASE_DIR=/data/shell/logs
LOGS_NAME=self_start_$(date +%Y-%m-%d).log

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
    chown -R hcicloud:hcicloud ${BASE_DIR}
    chmod 777 ${BASE_DIR}
fi

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 开始执行脚本" >> ${BASE_DIR}/${LOGS_NAME}
# 启动nginx
/data/nginx/sbin/nginx
sleep 5
nginx_num=$(ps -ef | grep -v grep | grep -w nginx | wc -l)
if [ ${nginx_num} -eq 0 ];then
    cd /data/nginx/sbin/
    ./nginx
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nginx 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
fi

# 启动ES
cd /data/elasticsearch-6.8.22/bin
./elasticsearch -d
sleep 10
elasticsearch_num=$(ps -ef | grep -v grep | grep -w elasticsearch | wc -l)
if [ ${elasticsearch_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) elasticsearch 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /data/elasticsearch-6.8.22/bin
    ./elasticsearch -d
fi

# 启动zk
/data/zookeeper-3.4.9/bin/zkServer.sh start
sleep 10
zookeeper_num=$(ps -ef | grep -v grep | grep -w zookeeper | wc -l)
if [ ${zookeeper_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) zookeeper 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /data/zookeeper-3.4.9/bin
    ./zkServer.sh start
fi

# 启动activemq
/data/apache-activemq-5.15.9/bin/activemq start
sleep 10
activemq_num=$(ps -ef | grep -v grep | grep -w activemq | wc -l)
if [ ${activemq_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) activemq 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /data/apache-activemq-5.15.9/bin
    ./activemq start
fi

# 启动应用
sh /data/aicc/v9502/aicc-config-server/startup.sh
sleep 10

sh /data/aicc/v9502/aicc-fileserver/startup.sh
sleep 10

sh /data/aicc/v9502/aicc-system-server/startup.sh
sleep 30

sh /data/aicc/v9502/aicc-robot-service/startup.sh
sleep 30

sh /data/aicc/v9502/aicc-robot-server/startup.sh
sleep 30

sh /data/aicc/v9162/aicc-znkf-server/startup.sh
sleep 30

sh /data/aicc/v9232/aicc-zndh-server/startup.sh
sleep 30

aicc-config-server_num=$(ps -ef | grep -v grep | grep -v aicc-config-server-1.0.0.jar | wc -l)
aicc-fileserver_num=$(ps -ef | grep -v grep | grep -v aicc-fileserver-1.0.2.jar | wc -l)
aicc-system-server_num=$(ps -ef | grep -v grep | grep -v aicc-system-server-9.0.5-ylsw.jar | wc -l)
aicc-robot-service_num=$(ps -ef | grep -v grep | grep -v aicc-robot-service-9502-ylsw.jar | wc -l)
aicc-robot-server_num=$(ps -ef | grep -v grep | grep -v aicc-robot-server-9502-ylsw.jar | wc -l)
aicc-znkf-server_num=$(ps -ef | grep -v grep | grep -v aicc-znkf-server-9.1.6.2-ylsw.jar | wc -l)
aicc-zndh-server_num=$(ps -ef | grep -v grep | grep -v aicc-zndh-server-9.2.3.2-ylsw.jar | wc -l)

# aicc-config-server
if [ ${aicc-config-server_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-config-server 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /data/aicc/v9502/aicc-config-server
    sh startup.sh
    sleep 10
fi

# aicc-fileserver
if [ ${aicc-fileserver_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-fileserver 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /data/aicc/v9502/aicc-fileserver/
    sh startup.sh
    sleep 10
fi

# aicc-system-server
if [ ${aicc-system-server_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-system-server 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /data/aicc/v9502/aicc-system-server/
    sh startup.sh
    sleep 30
fi

# aicc-robot-service
if [ ${aicc-robot-service_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-robot-service 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /data/aicc/v9502/aicc-robot-service
    sh startup.sh
    sleep 30
fi

# aicc-robot-server
if [ ${aicc-robot-server_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-robot-server 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /data/aicc/v9502/aicc-robot-server
    sh startup.sh
    sleep 30
fi

# aicc-znkf-server
if [ ${aicc-znkf-server_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-znkf-server 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /data/aicc/v9162/aicc-znkf-server/
    sh startup.sh
    sleep 30
fi

# aicc-zndh-server
if [ ${aicc-zndh-server_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) aicc-zndh-server 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /data/aicc/v9232/aicc-zndh-server/
    sh startup.sh
    sleep 30
fi

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 完成执行脚本" >> ${BASE_DIR}/${LOGS_NAME}