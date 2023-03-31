#!/bin/bash

# nginx每天0点备份一分access日志和error日志，并清空当前目录下access.log和error.log
# 配合linux的crontab使用
# 0 0 * * * /bin/bash /app/shell/nginx_logback.sh

YESTERDAY=$(date -d "yesterday" +"%Y-%m-%d")
# Nginx 日志目录
LOGPATH=/hcicloud/nginx/logs
DATE=$(date +%Y-%m-%d)
# 脚本日志目录
LOGS_DIR=/hcicloud/shell/logs
# 日志保留时间
SAVE_TIME=30


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

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++" >>${LOGS_DIR}/backup_${DATE}.log
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 备份日志文件--start" >>${LOGS_DIR}/backup_${DATE}.log
cp ${LOGPATH}/access.log ${LOGPATH}/access-${YESTERDAY}.log
cp ${LOGPATH}/error.log ${LOGPATH}/error-${YESTERDAY}.log
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 备份日志文件--end" >>${LOGS_DIR}/backup_${DATE}.log
echo "----------------------------------------------------" >>${LOGS_DIR}/backup_${DATE}.log
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清空日志文件--start" >>${LOGS_DIR}/backup_${DATE}.log
echo "" >${LOGPATH}/access.log
echo "" >${LOGPATH}/error.log
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 清空日志文件--end" >>${LOGS_DIR}/backup_${DATE}.log
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++" >>${LOGS_DIR}/backup_${DATE}.log

# 清理30天以前的的日志文件
find ${LOGS_DIR} -mtime +${SAVE_TIME} -name "*.log" >> ${LOGS_DIR}/backup_${DATE}.log
find ${LOGS_DIR} -mtime +${SAVE_TIME} -name "*.log" -exec rm -rf {} \;
find ${LOGPATH} -mtime +${SAVE_TIME} -name "*.log" >> ${LOGS_DIR}/backup_${DATE}.log
find ${LOGPATH} -mtime +${SAVE_TIME} -name "*.log" -exec rm -rf {} \;

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 今日备份&清理工作完成" >>${LOGS_DIR}/backup_${DATE}.log
