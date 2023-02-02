#!/bin/bash

# 清理web方案层的日志信息
# 清理30天以前的日志

# 日志文件路径
# aicc-config-server
CONFIG_SERVER_LOG_PATH=/app/aicc/aicc-robot/aicc-config-server/logs/
# aicc-system-server
SYSTEM_SERVER_LOG_PATH=/app/aicc/aicc-robot/aicc-system-server/logs/
# aicc-fileserver
FILESERVER_LOG_PATH=/app/aicc/aicc-robot/aicc-fileserver/logs/
# aicc-robot-service
ROBOT_SERVICE_LOG_PATH=/app/aicc/aicc-robot/aicc-robot-service/logs/
# aicc-robot-service
ROBOT_SERVER_LOG_PATH=/app/aicc/aicc-robot/aicc-robot-server/logs/
# aicc-znkf-server
ZNKF_SERVER_LOG_PATH=/app/aicc/aicc-znkf/aicc-znkf-server/logs/
# aicc-znkf-server
ZNDH_SERVER_LOG_PATH=/app/aicc/aicc-zndh/aicc-zndh-server/logs/

# 脚本工作目录
SCRIPT_PATH=/app/shell
# 脚本工作日志目录
SCRIPT_LOGS_PATH=${SCRIPT_PATH}/clean_logs/

# 判断clean_logs目录是否存在，不存在则新建
if [ ! -d "${SCRIPT_LOGS_PATH}" ]; then
    mkdir ${SCRIPT_LOGS_PATH}
fi

DATE=$(date +%Y-%m-%d)

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
# 清理config-server日志文件
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理config-server的日志文件--start" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
echo "删除的文件列表：" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${CONFIG_SERVER_LOG_PATH} -mtime +30 -name "*.gz" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${CONFIG_SERVER_LOG_PATH} -mtime +30 -name "*.gz" -exec rm -rf {} \;
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理config-server的日志文件--end" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log

# 清理system-server日志文件
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理system-server的日志文件--start" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
echo "删除的文件列表：" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${SYSTEM_SERVER_LOG_PATH} -mtime +30 -name "*.gz" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${SYSTEM_SERVER_LOG_PATH} -mtime +30 -name "*.gz" -exec rm -rf {} \;
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理system-server的日志文件--end" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log

# 清理fileserver日志文件
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理fileserver的日志文件--start" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
echo "删除的文件列表：" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${FILESERVER_LOG_PATH} -mtime +30 -name "*.gz" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${FILESERVER_LOG_PATH} -mtime +30 -name "*.gz" -exec rm -rf {} \;
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理fileserver的日志文件--end" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log

# 清理robot-service日志文件
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理robot-service的日志文件--start" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
echo "删除的文件列表：" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${ROBOT_SERVICE_LOG_PATH} -mtime +30 -name "*.gz" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${ROBOT_SERVICE_LOG_PATH} -mtime +30 -name "*.gz" -exec rm -rf {} \;
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理robot-service的日志文件--end" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log

# 清理robot-server日志文件
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理robot-server的日志文件--start" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
echo "删除的文件列表：" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${ROBOT_SERVER_LOG_PATH} -mtime +30 -name "*.gz" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${ROBOT_SERVER_LOG_PATH} -mtime +30 -name "*.gz" -exec rm -rf {} \;
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理robot-server的日志文件--end" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log

# 清理znkf-server日志文件
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理znkf-server的日志文件--start" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
echo "删除的文件列表：" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${ZNKF_SERVER_LOG_PATH} -mtime +30 -name "*.gz" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${ZNKF_SERVER_LOG_PATH} -mtime +30 -name "*.gz" -exec rm -rf {} \;
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理znkf-server的日志文件--end" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log

# 清理zndh-server日志文件
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理zndh-server的日志文件--start" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
echo "删除的文件列表：" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${ZNDH_SERVER_LOG_PATH} -mtime +30 -name "*.gz" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
find ${ZNDH_SERVER_LOG_PATH} -mtime +30 -name "*.gz" -exec rm -rf {} \;
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清理zndh-server的日志文件--end" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log

find ${SCRIPT_LOGS_PATH} -mtime +30 -name "*.log" -exec rm -rf {} \;

find /app/check/logs -mtime +15 -name "*.log" -exec rm -rf {} \;

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 日志清理完成" >>${SCRIPT_LOGS_PATH}clean_${DATE}.log
