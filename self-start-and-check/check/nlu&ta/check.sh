#!/bin/bash

# root执行，在定时任务中配置每15分钟执行一次

su - hcicloud -s /bin/bash /app/check/check_nlu.sh
sleep 60

echo "------- $(date +%Y-%m-%d) $(date +%H:%M:%S) start check hcicloud_ta servers-------" >>/app/check/logs/check_$(date +%Y-%m-%d).log
su - hcicloud_ta -s /bin/bash /app/check/check_ta.sh
sleep 60

echo "------- $(date +%Y-%m-%d) $(date +%H:%M:%S) begin to check all servers-------" >>/app/check/logs/check_$(date +%Y-%m-%d).log
source /etc/profile
echo "------- $(date +%Y-%m-%d) $(date +%H:%M:%S) start check root servers-------" >>/app/check/logs/check_$(date +%Y-%m-%d).log
for i in fdfs_trackerd fdfs_storaged; do
    num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
    if [ $num -eq 0 ]; then
        if [ $i = "fdfs_trackerd" ]; then
            cd /etc/init/
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) tracker服务不存在，现在马上启动tracker服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./fdfs_trackerd start
        else
            cd /etc/init/
            echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) storage服务不存在，现在马上启动storage服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
            ./fdfs_storaged start
        fi
    else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务正常" >>/app/check/logs/check_$(date +%Y-%m-%d).log
    fi
done

echo "------- $(date +%Y-%m-%d) $(date +%H:%M:%S) all servers is checked -------" >>/app/check/logs/check_$(date +%Y-%m-%d).log

echo "========================================================================================================================="

exit 0
