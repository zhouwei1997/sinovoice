#!/bin/bash

# 10.11.116.125 服务器自启动脚本
# hcicloud   nginx/ES/zk/activemq
# su - hcicloud -s /bin/bash /hcicloud/shell/10.11.116.125.sh

BASE_DIR=/hcicloud/shell/logs
LOGS_NAME=self_$(date +%Y-%m-%d).log

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
    chown -R hcicloud:hcicloud ${BASE_DIR}
    chmod 777 ${BASE_DIR}
fi

# 启动nginx
/hcicloud/nginx/sbin/nginx
sleep 10
nginx_num=$(ps -ef | grep -v grep | grep -w nginx | wc -l)
if [ ${nginx_num} -eq 0 ];then
    cd /hcicloud/nginx/sbin/
    ./nginx
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nginx 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
fi

# 启动ES
cd /hcicloud/elasticsearch-6.8.22/bin
./elasticsearch -d
sleep 10
elasticsearch_num=$(ps -ef | grep -v grep | grep -w elasticsearch | wc -l)
if [ ${elasticsearch_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) elasticsearch 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /hcicloud/elasticsearch-6.8.22/bin
    ./elasticsearch -d
fi

# 启动zk
/hcicloud/apache-zookeeper-3.5.6-bin/bin/zkServer.sh start
sleep 10
zookeeper_num=$(ps -ef | grep -v grep | grep -w zookeeper | wc -l)
if [ ${zookeeper_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) zookeeper 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /hcicloud/apache-zookeeper-3.5.6-bin/bin/
    ./zkServer.sh start
fi

# 启动activemq
/hcicloud/apache-activemq-5.16.2/bin/activemq start
sleep 10
activemq_num=$(ps -ef | grep -v grep | grep -w activemq | wc -l)
if [ ${activemq_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) activemq 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /hcicloud/apache-activemq-5.16.2/bin/
    ./activemq start
fi