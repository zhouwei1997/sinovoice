#!/bin/bash

# 质检测试环境重启脚本
# 使用hcicloud用户执行

BASE_DIR=/home/hcicloud/aicc-yyfx

cd ${BASE_DIR}/aicc-config-server
ps -ef | grep aicc-config-server-1.0.0.jar | grep -v grep | awk '{print $2}' | xargs kill -9
sh startup.sh
sleep 10

cd ${BASE_DIR}/aicc-yyfx-fileserver
ps -ef | grep aicc-fileserver-1.0.1.jar | grep -v grep | awk '{print $2}' | xargs kill -9
sh startup.sh
sleep 10

cd ${BASE_DIR}/aicc-system-server
ps -ef | grep aicc-system-server-9.0.3.jar | grep -v grep | awk '{print $2}' | xargs kill -9
sh startup.sh
sleep 30

cd ${BASE_DIR}/aicc-yyfx-server
ps -ef | grep aicc-yyfx-server-2.0.0.jar | grep -v grep | awk '{print $2}' | xargs kill -9
sh startup.sh
sleep 30

cd ${BASE_DIR}/aicc-yyfx-edas
ps -ef | grep aicc-yyfx-edas-1.0.0.jar | grep -v grep | awk '{print $2}' | xargs kill -9
sh startup.sh
sleep 30

cd ${BASE_DIR}/aicc-yyfx-vts
ps -ef | grep aicc-yyfx-vts-1.0.0.jar | grep -v grep | awk '{print $2}' | xargs kill -9
sh startup.sh
sleep 45