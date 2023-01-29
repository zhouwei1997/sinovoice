#!/bin/bash

# jtts和mrcp的守护进程，配合定时任务使用，每5分钟扫描一次，并将日志输出到文件中
# */5 * * * * bash /hcicloud/check/check_jtts.sh
# 需要将应用放置在指定的路径下


source /hcicloud/.bash_profile

# 脚本存在的路径
BASE_DIR=/hcicloud/check
# 脚本日志文件路径
BASE_DIR_LOGS=${BASE_DIR}/logs
# 应用程序路径
SINOVOICE=/hcicloud/Sinovoice6.6.9
# 格式化日期
DATE=$(date +%Y-%m-%d)

echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 检测服务进程-start" >> ${BASE_DIR_LOGS}/check_${DATE}.log
# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR_LOGS}" ]; then
    mkdir -p ${BASE_DIR_LOGS}
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 日志文件目录不存在，新建日志文件目录" >> ${BASE_DIR_LOGS}/check_${DATE}.log
    if  [ ! -d "${BASE_DIR_LOGS}" ]; then
        echo "$(date +%H:%M:%S) 日志文件目新建成功" >> ${BASE_DIR_LOGS}/check_${DATE}.log
    fi
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 日志文件目录存在" >> ${BASE_DIR_LOGS}/check_${DATE}.log
fi

for i in jTTSService4.exe unimrcpserver; do
    num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
    if [ $num -eq 0 ]; then
        if [ $i == "jTTSService4.exe" ]; then
            cd ${SINOVOICE}/jTTS6.6.9/bin
            echo "$(date +%H:%M:%S) jTTSService4服务不存在，现在马上启动jTTSService4服务" >> ${BASE_DIR_LOGS}/check_${DATE}.log
            ./jtts.sh start >> /dev/null 2>&1 &
        else
            cd ${SINOVOICE}/unimrcp/bin
            echo "$(date +%H:%M:%S) unimrcpserver服务不存在，现在马上启动unimrcpserver服务" >> ${BASE_DIR_LOGS}/check_${DATE}.log
            ./mrcp.sh start >> /dev/null 2>&1
        fi
    else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务正常" >> ${BASE_DIR_LOGS}/check_${DATE}.log
    fi
done
echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) 检测服务进程-end" >> ${BASE_DIR_LOGS}/check_${DATE}.log
