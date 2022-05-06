#!/bin/bash

# 应用自启动脚本

# 指定位置存放日志文件
LOGS_DIR=/home/hcicloud/shell/logs/
LOGS_File=$LOGS_DIR/self_start_$(date +%Y-%m-%d).log
# 创建日志文件并修改其权限
touch $LOGS_File
chmod 666 $LOGS_File

echo "==========================================" >>$LOGS_File

echo "------- $(date +%Y-%m-%d) $(date +%H:%M:%S) 启动服务 -------" >>$LOGS_File

##################################################################################
#                                                                                #
#    以下全部为root用户启动的进程                                                  #
#                                                                                #
##################################################################################

# 启动nginx
echo "------- $(date +%Y-%m-%d) $(date +%H:%M:%S) 启动Nginx服务 -------" >>$LOGS_File
nginx_pid=$(ps -ef | grep -v grep | grep -w nginx | wc -l)
if [ $nginx_pid -ne 2 ]; then
    cd /usr/local/nginx/sbin
    ./nginx
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) Nginx服务运行正常"
fi

# 启动FastDFS
echo "------- $(date +%Y-%m-%d) $(date +%H:%M:%S) 启动FastDFS服务 -------" >>$LOGS_File
tracker_pid=$(ps -ef | grep -v grep | grep -w fdfs_trackered | wc -l)
storage_pid=$(ps -ef | grep -v grep | grep -w fdfs_storaged | wc -l)
# 先判断fdfs_trackered进程是否存在
# 如果fdfs_trackered进程存在，则直接启动fdfs_storaged
if [ $tracker_pid -eq 0 ]; then
    #fdfs_trackered进程不存在，判断fdfs_storaged的进程是否存在
    if [ $storage_pid -eq 0 ]; then
        # fdfs_storaged的进程不存在，先启动tracker进程，在启动storage进程
        /etc/init.d/fdfs_trackered start
        /etc/init.d/fdfs_storaged start
    else
        # fdfs_storaged的进程存在，先将storage的进程kill掉，然后启动tracker和storage进程
        kill -9 $storage_pid
        /etc/init.d/fdfs_trackered start
        /etc/init.d/fdfs_storaged start
    fi
else
    /etc/init.d/fdfs_storaged start
fi

# 启动MySQL服务
mysql_pid=$(ps aux | grep -v grep | grep -wi mysql | wc -l)
if [ $mysql_pid -eq 0 ]; then
    syetemctl start mysqld
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) MySQL服务运行正常" >>$LOGS_File
fi

##################################################################################
#                                                                                #
#    以下全部为hcicloud用户启动的进程                                              #
#                                                                                #
##################################################################################

su - hcicloud

# 启动redis服务
redis_pid=$(ps aux | grep -w redis | grep -v grep | wc -l)
if [ $redis_pid -eq 0 ]; then
    cd /home/hcicloud/redis
    ./redis-server ./redis.conf
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) Redis服务运行正常" >>$LOGS_File
fi

# 启动ES
ES_pid=$(ps aux | grep -w elasticsearch | grep -v grep | wc -l)
if [ $ES_pid -eq 0 ]; then
    cd /home/hcicloud/elasticsearch-6.6.2
    ./elasticsearch -d
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) elasticsearch服务运行正常" >>$LOGS_File
fi

# 启动zookeeper
zk_pid=$(ps aux | grep -v grep | grep -wi zookeeper | wc -l)
if [ $zk_pid -eq 0 ]; then
    cd /home/hcicloud/zookeeper3.4.9/bin
    ./zkServer.sh start
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) zookeeper服务运行正常" >>$LOGS_File
fi

# 启动ActiveMQ
mq_pid=$(ps aux | grep -v grep | grep -w activemq)
if [ $mq_pid -eq 0 ]; then
    cd /home/hcicloud/apache-activemq-5.15.9/bin
    ./activemq start
else
    echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) activemq服务运行正常" >>$LOGS_File
fi

# 启动nlu
for i in servicefx_license_server servicefx_http_server servicefx_slb servicefx_nlu servicefx_nlu_sync; do
    num=$(ps -ef | grep -v grep | grep -w $i | wc -l)
    if [ $num -eq 0 ]; then
        if [ $i == "servicefx_license_server" ]; then
            cd /home/hcicloud/cloud/license_server/bin
            ./servicefx_license_server -d >>/dev/null 2>&1 &
        elif [ $i == "servicefx_http_server" ]; then
            cd /home/hcicloud/cloud/http_server/bin
            ./servicefx_http_server -d >>/dev/null 2>&1 &
        elif [ $i == "servicefx_slb" ]; then
            cd /home/hcicloud/cloud/slb/bin
            ./servicefx_slb -d >>/dev/null 2>&1 &
        elif [ $i == "servicefx_nlu" ]; then
            cd /home/hcicloud/cloud/nlu/bin
            ./servicefx_nlu -d >>/dev/null 2>&1 &
        else
            cd /home/hcicloud/cloud/nlu_sync
            ./servicefx_nlu_sync -d >>/dev/null 2>&1 &
        fi
    else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务正常" >>$LOGS_File
    fi
done

logout

su - hcicloud_ta

# 启动ros和ta
for i in servicefx_ros servicefx_text_analyze; do
    num=$(ps aux | grep -v grep | grep -w $i | wc -l)
    if [ $num -eq 0 ]; then
        if [ $i == "servicefx_ros" ]; then
            cd /home/hcicloud_ta/ros/ros/bin
            ./servicefx_ros -d >>/dev/null 2>&1 &
        else
            cd /home/hcicloud_ta/cloud/text_analyze/bin
            ./servicefx_text_analyze -d >>/dev/null 2>&1 &
        fi
    else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务正常" >>$LOGS_File
    fi
done

logout

# 切换到hcicloud用户，然后启动jar包程序

su - hcicloud

for i in aicc-config-server aicc-fileserver aicc-system-server aicc-robot-service aicc-robot-server aicc-znkf-server; do
    num=$(ps aux | grep -v grep | grep -w $i | wc -l)
    if [ $num -eq 0 ]; then
        if [ $i == "aicc-config-server" ]; then
            cd /app/aicc/aicc-config/
            bash startup.sh
            sleep 10
        elif [ $i == "aicc-fileserver" ]; then
            cd /app/aicc/aicc-fileserver
            bash startup.sh
            sleep 15
        elif [ $i == "aicc-system-server" ]; then
            cd /app/aicc/aicc-system-server/
            bash startup.sh
            sleep 30
        elif [ $i == "aicc-robot-service" ]; then
            cd /app/aicc/aicc-robot-service
            bash startup.sh
            sleep 20
        elif [ $i == "aicc-robot-server" ]; then
            cd /app/aicc/aicc-robot-server/
            bash startup.sh
            sleep 30
        else
            cd /app/aicc/aicc-znkf-server/
            bash startup.sh
            sleep 20
        fi
    else
        echo "$(date +%Y-%m-%d) $(date +%H:%M:%S) $i 服务正常" >>$LOGS_File
    fi
done

exit 0

echo "==========================================" >>$LOGS_File
