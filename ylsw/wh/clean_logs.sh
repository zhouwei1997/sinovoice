#!/bin/bash

# 定时任务
# * 2 * * * bash /hcicloud/shell/clean_logs.sh
# 使用hcicloud用户执行

# 日志清理

BASE_DIR=/hcicloud/aicc-znwh

# 日志文件路径
# aicc-config-server
CONFIG_SERVER_LOG_PATH=${BASE_DIR}/aicc-config-server/logs/
# aicc-gateway
GATEWAY_LOG_PATH=${BASE_DIR}/aicc-gateway/logs/
# aicc-system-server
SYSTEM_SERVER_LOG_PATH=${BASE_DIR}/aicc-system-server/logs/
# aicc-fileserver
FILESERVER_LOG_PATH=${BASE_DIR}/aicc-fileserver/logs/
# aicc-im-server
IM_SERVER_LOG_PATH=${BASE_DIR}/aicc-im-server/logs/
# aicc-znwh-server
ZNWH_SERVER_LOG_PATH=${BASE_DIR}/aicc-znwh-server/logs/
# aicc-znwh-sas
ZNWH_SAS_LOG_PATH=${BASE_DIR}/aicc-znwh-sas/logs/
# aicc-znwh-rtcs
ZNWH_RTCS_LOG_PATH=${BASE_DIR}/aicc-znwh-rtcs/logs/

# 日志保留时间
SAVE_TIME=30
# 日志文件存放目录
LOGS_DIR=/hcicloud/shell/logs
# 格式化日期
DATE=$(date +%Y-%m-%d)

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${LOGS_DIR}" ]; then
    mkdir -p ${LOGS_DIR}
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 日志文件目录不存在，新建日志文件目录" >> ${LOGS_DIR}/clean_${DATE}.log
    if  [ ! -d "${LOGS_DIR}" ]; then
      echo "$(date +%H:%M:%S) 日志文件目新建成功" >> ${LOGS_DIR}/clean_${DATE}.log
    fi
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 日志文件目录存在" >> ${LOGS_DIR}/clean_${DATE}.log
fi

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++" >> ${LOGS_DIR}/clean_${DATE}.log
echo "----------清理应用日志-start----------" >> ${LOGS_DIR}/clean_${DATE}.log
for i in ${CONFIG_SERVER_LOG_PATH} ${GATEWAY_LOG_PATH} ${SYSTEM_SERVER_LOG_PATH} ${FILESERVER_LOG_PATH} ${IM_SERVER_LOG_PATH} ${ZNWH_SERVER_LOG_PATH} ${ZNWH_SAS_LOG_PATH} ${ZNWH_RTCS_LOG_PATH};do
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理 $i 的日志文件--start" >> ${LOGS_DIR}/clean_${DATE}.log
find $i -mtime +${SAVE_TIME} -name "*.gz" >> ${LOGS_DIR}/clean_${DATE}.log
find $i -mtime +${SAVE_TIME} -name "*.gz" -exec rm -rf {} \;
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理 $i 的日志文件--end" >> ${LOGS_DIR}/clean_${DATE}.log
echo "#####################################################" >> ${LOGS_DIR}/clean_${DATE}.log
done
echo "----------清理应用日志-end----------" >> ${LOGS_DIR}/clean_${DATE}.log

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++" >> ${LOGS_DIR}/clean_${DATE}.log
