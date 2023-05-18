#!/bin/bash

# 定时任务
# */10 * * * * bash /app/check/nlu_check.sh
# 使用hcicloud用户执行

source /home/hcicloud/.bash_profile
BASE_DIR=/app/check/logs
CLOUD_DIR=/hcicloud/cloud

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
fi

# zookeeper
if [ $(ps -ef | grep -v grep | grep zookeeper | wc -l ) -eq 0 ];then
    # 启动zookeeper
    echo "$(date +%H:%M:%S) 【ERROR】 zookeeper 进程不存在，现在启动 zookeeper " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    cd /app/zookeeper-3.4.9/bin/
    ./zkServer.sh start
elif [ $(ps -ef | grep -v grep | grep zookeeper | wc -l ) -gt 1 ];then
    # 进程大于1 kill进程然后重新启动
    echo "$(date +%H:%M:%S) 【ERROR】 zookeeper 进程异常，重新启动 zookeeper " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    ps -ef | grep zookeeper | grep -v grep | awk '{print $2}' | xargs kill -9
    cd /app/zookeeper-3.4.9/bin/
    ./zkServer.sh start
else
    # 输出日志  进程存在，不做任何操作
    echo "$(date +%H:%M:%S) 【INFO】 zookeeper 进程 正常" >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
fi

# activemq 
if [ $(ps -ef | grep -v grep | grep activemq | wc -l ) -eq 0 ];then
    # 启动activemq
    echo "$(date +%H:%M:%S) 【ERROR】 activemq 进程不存在，现在启动 activemq " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    cd /app/apache-activemq-5.15.9/bin/
    ./activemq start
elif [ $(ps -ef | grep -v grep | grep activemq | wc -l ) -gt 1 ];then
    # 进程大于1 kill进程然后重新启动
    echo "$(date +%H:%M:%S) 【ERROR】 activemq 进程异常，重新启动 activemq " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    ps -ef | grep activemq | grep -v grep | awk '{print $2}' | xargs kill -9
    cd /app/apache-activemq-5.15.9/bin/
    ./activemq start
else
    # 输出日志  进程存在，不做任何操作
    echo "$(date +%H:%M:%S) 【INFO】 activemq 进程 正常" >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
fi

# servicefx_license_server 
if [ $(ps -ef | grep -v grep | grep servicefx_license_server | wc -l ) -eq 0 ];then
    # 启动servicefx_license_server 
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_license_server 进程不存在，现在启动 servicefx_license_server " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    cd /home/hcicloud/cloud/license_server/bin/
    ./servicefx_license_server -d
elif [ $(ps -ef | grep -v grep | grep servicefx_license_server | wc -l ) -gt 1 ];then
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_license_server 进程异常，重新启动 servicefx_license_server " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    ps -ef | grep servicefx_license_server | grep -v grep | awk '{print $2}' | xargs kill -9
    cd /home/hcicloud/cloud/license_server/bin/
    ./servicefx_license_server -d
else
    echo "$(date +%H:%M:%S) 【INFO】 servicefx_license_server 进程 正常 " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
fi

# servicefx_http_server 
if [ $(ps -ef | grep -v grep | grep servicefx_http_server | wc -l ) -eq 0 ];then
    # 启动servicefx_http_server
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_http_server 进程不存在，现在启动 servicefx_http_server " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    cd /home/hcicloud/cloud/http_server/bin
    ./servicefx_http_server -d
elif [ $(ps -ef | grep -v grep | grep servicefx_http_server | wc -l ) -gt 1 ];then
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_http_server 进程异常，重新启动 servicefx_http_server " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    ps -ef | grep servicefx_http_server | grep -v grep | awk '{print $2}' | xargs kill -9
    cd /home/hcicloud/cloud/http_server/bin
    ./servicefx_http_server -d
else
    echo "$(date +%H:%M:%S) 【INFO】 servicefx_http_server 进程 正常 " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
fi

# servicefx_slb 
if [ $(ps -ef | grep -v grep | grep servicefx_slb | wc -l ) -eq 0 ];then
    # 启动servicefx_slb 
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_slb 进程不存在，现在启动 servicefx_slb  " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    cd /home/hcicloud/cloud/slb/bin
    ./servicefx_slb -d
elif [ $(ps -ef | grep -v grep | grep servicefx_slb | wc -l ) -gt 1 ];then
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_slb 进程异常，重新启动 servicefx_slb  " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    ps -ef | grep servicefx_slb | grep -v grep | awk '{print $2}' | xargs kill -9
    cd /home/hcicloud/cloud/slb/bin
    ./servicefx_slb -d
else
    echo "$(date +%H:%M:%S) 【INFO】 sservicefx_slb 进程 正常 " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
fi

# servicefx_nlu 
if [ $(ps -ef | grep -v grep | grep 'servicefx_nlu -d' | wc -l ) -eq 0 ];then
    # servicefx_nlu 
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_nlu 进程不存在，现在启动 servicefx_nlu " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    cd /home/hcicloud/cloud/nlu/bin
    ./servicefx_nlu -d
elif [ $(ps -ef | grep -v grep | grep 'servicefx_nlu -d' | wc -l ) -gt 1 ];then
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_nlu 进程异常，重新启动 servicefx_nlu " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    ps -ef | grep 'servicefx_nlu -d' | grep -v grep | awk '{print $2}' | xargs kill -9
    cd /home/hcicloud/cloud/nlu/bin
    ./servicefx_nlu -d
else
    echo "$(date +%H:%M:%S) 【INFO】 servicefx_nlu  进程 正常 " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
fi

# servicefx_nlu_sync
if [ $(ps -ef | grep -v grep | grep servicefx_nlu_sync | wc -l ) -eq 0 ];then
    # 启动servicefx_nlu_sync
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_nlu_sync 进程不存在，现在启动 servicefx_nlu_sync " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    cd /home/hcicloud/cloud/nlu_sync/bin
    ./servicefx_nlu_sync -d
elif [ $(ps -ef | grep -v grep | grep servicefx_nlu_sync | wc -l ) -gt 1 ];then
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_nlu_sync 进程异常，重新启动 servicefx_nlu_sync " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
    ps -ef | grep servicefx_nlu_sync | grep -v grep | awk '{print $2}' | xargs kill -9
    cd /home/hcicloud/cloud/nlu_sync/bin
    ./servicefx_nlu_sync -d
else
    echo "$(date +%H:%M:%S) 【INFO】 sservicefx_nlu_sync 进程 正常 " >> ${BASE_DIR}/check_nlu_$(date +%Y-%m-%d).log
fi