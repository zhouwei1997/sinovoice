#!/bin/bash

# su - hcicloud -s /bin/bash /data/shell/aicp_nlu.sh

BASE_DIR=/data/shell/logs
LOGS_NAME=aicp_nlu_$(date +%Y-%m-%d).log

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
    chown -R hcicloud:hcicloud ${BASE_DIR}
    chmod 777 ${BASE_DIR}
fi

# 启动nlu/aicp
cd /home/hcicloud/cloud/shell
./service.sh -sa
sleep 30
license_server_num=$(ps -ef | grep -v grep | grep -w servicefx_license_server | wc -l)
http_server_num=$(ps -ef | grep -v grep | grep -w servicefx_http_server | wc -l)  
slb_num=$(ps -ef | grep -v grep | grep -w servicefx_slb | wc -l)  
nlu_num=$(ps -ef | grep -v grep | grep -w servicefx_nlu | wc -l)  
nlu_sync_num=$(ps -ef | grep -v grep | grep -w servicefx_nlu_sync | wc -l) 
if [ ${license_server_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) servicefx_license_server 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /home/hcicloud/cloud/license_server/bin
    ./servicefx_license_server -d
    sleep 10
fi

if [ ${http_server_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) sservicefx_http_server 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /home/hcicloud/cloud/http_server/bin
    ./servicefx_http_server -d
    sleep 10
fi

if [ ${slb_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) servicefx_slb 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /home/hcicloud/cloud/slb/bin
    ./servicefx_slb -d
    sleep 10
fi

if [ ${nlu_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) servicefx_nlu 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /home/hcicloud/cloud/nlu/bin
    ./servicefx_nlu -d
    sleep 10
fi

if [ ${nlu_sync_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) servicefx_nlu_sync 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /home/hcicloud/cloud/nlu_sync/bin
    ./servicefx_nlu_sync -d
    sleep 10
fi

cd /data/aicp/bin
consul_num=$(ps -ef | grep -v grep | grep -w consul | wc -l)
if [ ${consul_num} -ne 0 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) servicefx_nlu_sync 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
else
    cd /data/aicp/bin
    for i in aicp_apigw aicp_license aicp_asr_ft aicp_asr_dizhi aicp_asr_16k aicp_asr_mrcp aicp_tts aicp_tts_mrcp;do 
        ./$i -k
        sleep 10
    done
    for i in consul aicp_apigw aicp_license aicp_asr_ft aicp_asr_dizhi aicp_asr_16k aicp_asr_mrcp aicp_tts aicp_tts_mrcp;do 
        ./$i -d
        sleep 10
    done
fi