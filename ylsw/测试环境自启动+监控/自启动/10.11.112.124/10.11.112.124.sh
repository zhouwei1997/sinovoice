#!/bin/bash
# 10.11.112.124 服务器自启动脚本
# root   fastdfs
# hcicloud   nlu/consul
# hcicloud_ta  text_analyze/ros

BASE_DIR=/data/shell/logs
LOGS_NAME=self_start_$(date +%Y-%m-%d).log

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
    chown -R hcicloud:hcicloud ${BASE_DIR}
    chmod 777 ${BASE_DIR}
fi

# 启动fastdfs
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 开始执行脚本" >> ${BASE_DIR}/${LOGS_NAME}
/etc/init.d/fdfs_trackerd start
sleep 5
/etc/init.d/fdfs_storaged start
fdfs_trackerd_num=$(ps -ef | grep -v grep | grep -w fdfs_trackerd | wc -l)
fdfs_storaged_num=$(ps -ef | grep -v grep | grep -w fdfs_storaged | wc -l)
if [ ${fdfs_trackerd_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) fdfs_trackerd 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
    if [ ${fdfs_storaged_num} -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) fdfs_storaged 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) fastdfs 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
    else
        cd /etc/init.d/
        ./fdfs_storaged start
    fi
else
    ps -ef | grep fdfs_storaged | grep -v grep | awk '{print $2}' | xargs kill -9
    cd /etc/init.d/
    ./fdfs_trackerd start
    sleep 5
    ./fdfs_storaged start
fi

su - hcicloud_ta
# 启动ros/ta
cd /home/hcicloud_ta/ros/bin
./servicefx_ros -d
sleep 10
servicefx_ros_num=$(ps -ef | grep -v grep | grep -w servicefx_ros | wc -l)
if [ ${servicefx_ros_num} -eq 1 ];then
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) servicefx_ros 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
    cd /home/hcicloud_ta/cloud/text_analyze/bin
    ./servicefx_text_analyze -d
    sleep 10
    servicefx_text_analyze_num=$(ps -ef | grep -v grep | grep -w servicefx_text_analyze | wc -l)
    if [ ${servicefx_text_analyze_num} -eq 1 ];then
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) servicefx_text_analyze 启动成功" >> ${BASE_DIR}/${LOGS_NAME}
    else
        cd /home/hcicloud_ta/cloud/text_analyze/bin
        ./servicefx_text_analyze -d
    fi
else
    ps -ef | grep servicefx_text_analyze | grep -v grep | awk '{print $2}' | xargs kill -9
    cd /home/hcicloud_ta/ros/bin
    ./servicefx_ros -d
    sleep 10
    cd /home/hcicloud_ta/cloud/text_analyze/bin
    ./servicefx_text_analyze -d
    sleep 10
fi

su - hcicloud
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