#!/bin/bash

# root执行，在定时任务中配置每15分钟执行一次
# 检查root用户启动的fastdfs的任务进程
# */15 * * * * bash /app/check/check_root.sh

BASE_DIR=/app/check/logs

# 判断logs目录是否存在，不存在则新建
if [ ! -d "${BASE_DIR}" ]; then
    mkdir -p ${BASE_DIR}
    chown -R hcicloud:hcicloud ${BASE_DIR}
fi

source /etc/profile
echo "------- $(date +%Y-%m-%d) $(date +%H:%M:%S) start check root servers-------" >> ${BASE_DIR}/check_root_$(date +%Y-%m-%d).log
for i in fdfs_trackerd fdfs_storaged; do
    num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
    if [ $num -eq 0 ]; then
        if [ $i = "fdfs_trackerd" ]; then
            cd /etc/init/
            echo "$(date +%H:%M:%S) tracker服务不存在，现在马上启动tracker服务" >>${BASE_DIR}/check_root_$(date +%Y-%m-%d).log
            ./fdfs_trackerd start
        else
            cd /etc/init/
            echo "$(date +%H:%M:%S) storage服务不存在，现在马上启动storage服务" >>${BASE_DIR}/check_root_$(date +%Y-%m-%d).log
            ./fdfs_storaged start
        fi
    else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务正常" >>${BASE_DIR}/check_root_$(date +%Y-%m-%d).log
    fi
done

echo "------- $(date +%Y-%m-%d) $(date +%H:%M:%S) all servers is checked -------" >>/app/check/logs/check_$(date +%Y-%m-%d).log

echo "========================================================================================================================="

exit 0
