#!/bin/bash

# su - hcicloud -s /bin/bash /hcicloud/shell/10.11.116.108.sh

BASE_DIR=/hcicloud/shell/logs
LOGS_NAME=aicp_nlu_$(date +%Y-%m-%d).log

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
    chown -R hcicloud:hcicloud ${BASE_DIR}
    chmod 777 ${BASE_DIR}
fi


cd /hcicloud/aicp/bin
consul_num=$(ps -ef | grep -v grep | grep -w consul | wc -l)
if [ ${consul_num} -ne 0 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) servicefx_nlu_sync 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /hcicloud/aicp/bin
    for i in aicp_apigw aicp_license aicp_asr_ft aicp_asr_ring aicp_tts;do 
        ./$i -k
        sleep 10
    done
    for i in consul aicp_apigw aicp_license aicp_asr_ft aicp_asr_ring aicp_tts;do 
        ./$i -d
        sleep 10
    done
fi