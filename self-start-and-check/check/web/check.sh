#!/bin/bash

# root执行，在定时任务中配置每15分钟执行一次

source /etc/profile
su - hcicloud -s /bin/bash /app/check/check_hcicloud.sh
sleep 60

echo "------- $(date +%Y-%m-%d) $(date +%H:%M:%S) start check root servers-------" >>/app/check/logs/check_$(date +%Y-%m-%d).log

num=$(ps -ef | grep -v grep | grep -w nginx | wc -l)
if [ $num -ne 2 ]; then
    cd /usr/local/nginx/sbin
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) nginx服务不存在，现在马上启动nginx服务" >>/app/check/logs/check_$(date +%Y-%m-%d).log
    ./nginx
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) Nginx 服务正常" >>/app/check/logs/check_$(date +%Y-%m-%d).log

fi

echo "------- $(date +%Y-%m-%d) $(date +%H:%M:%S) all servers is checked -------" >>/app/check/logs/check_$(date +%Y-%m-%d).log

echo "=========================================================================================================================" >>/app/check/logs/check_$(date +%Y-%m-%d).log

exit 0
