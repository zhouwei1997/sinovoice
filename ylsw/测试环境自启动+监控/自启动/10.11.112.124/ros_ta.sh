#!/bin/bash

# su - hcicloud_ta -s /bin/bash /data/shell/ros_ta.sh

BASE_DIR=/data/shell/logs
LOGS_NAME=ros_ta_$(date +%Y-%m-%d).log

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
    chown -R hcicloud:hcicloud ${BASE_DIR}
    chmod 777 ${BASE_DIR}
fi

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