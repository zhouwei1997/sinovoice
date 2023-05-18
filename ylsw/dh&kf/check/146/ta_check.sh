#!/bin/bash

# 定时任务
# */10 * * * * bash /app/check/ta_check.sh
# 使用hcicloud用户执行

source /home/hcicloud_ta/.bash_profile
BASE_DIR=/app/check/logs
CLOUD_DIR=/hcicloud_ta/cloud

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
fi

# servicefx_ros
if [ $(ps -ef | grep -v grep | grep servicefx_ros | wc -l ) -eq 0 ];then
    # 启动servicefx_ros 
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_ros 进程不存在，现在启动 servicefx_ros " >> ${BASE_DIR}/check_ta_$(date +%Y-%m-%d).log
    cd /home/hcicloud_ta/ros/bin
    ./servicefx_ros -d
elif [ $(ps -ef | grep -v grep | grep servicefx_ros | wc -l ) -gt 1 ];then
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_ros 进程异常，重新启动 servicefx_ros " >> ${BASE_DIR}/check_ta_$(date +%Y-%m-%d).log
    ps -ef | grep servicefx_ros | grep -v grep | awk '{print $2}' | xargs kill -9
    cd /home/hcicloud_ta/ros/bin
    ./servicefx_ros -d
else
    echo "$(date +%H:%M:%S) 【INFO】 servicefx_ros 进程 正常 " >> ${BASE_DIR}/check_ta_$(date +%Y-%m-%d).log
fi


# servicefx_text_analyze
if [ $(ps -ef | grep -v grep | grep servicefx_text_analyze | wc -l ) -eq 0 ];then
    # 启动servicefx_text_analyze
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_text_analyze 进程不存在，现在启动 servicefx_text_analyze " >> ${BASE_DIR}/check_ta_$(date +%Y-%m-%d).log
    cd /home/hcicloud_ta/cloud/text_analyze/bin
    ./servicefx_text_analyze -d
elif [ $(ps -ef | grep -v grep | grep servicefx_text_analyze | wc -l) -gt 1 ];then
    echo "$(date +%H:%M:%S) 【ERROR】 servicefx_text_analyze 进程异常，重新启动 servicefx_text_analyze " >> ${BASE_DIR}/check_ta_$(date +%Y-%m-%d).log
    ps -ef | grep servicefx_text_analyze | grep -v grep | awk '{print $2}' | xargs kill -9
    cd /home/hcicloud_ta/cloud/text_analyze/bin
    ./servicefx_text_analyze -d
e   lse
    echo "$(date +%H:%M:%S) 【INFO】 servicefx_text_analyze 进程 正常 " >> ${BASE_DIR}/check_ta_$(date +%Y-%m-%d).log
fi