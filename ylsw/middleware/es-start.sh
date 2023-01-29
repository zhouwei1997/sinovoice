#!/bin/bash

#auto ES restart
###########################################################
proc_name="Elasticsearch"                #进程名
TIME=$(date +%Y-%m-%d_%H)             #定义时间
ES_DIR="/data/elasticsearch-6.8.22/bin/" # ES的启动目录
BASE_DIR=/data/shell     # ES启动脚本的路径

#定义es的java变量,这里如果不定义，在定时任务执行时会报错.crontab会以用户的身份执行配置的命令，但是不会加载用户的环境变量
export JAVA_HOME=/usr/local/jdk1.8.0_141/

proc_num() { #查询进程数量
    num=$(ps -ef | grep $proc_name | grep -v grep | wc -l)
    return $num
}

proc_num
number=$? #获取进程数量
#如果进程数量为0 ，重新启动服务，或者扩展其它内容。
if [ $number -eq 0 ]; then
    echo "$TIME 进程不存在，重启服务！！！" >> ${BASE_DIR}/$(date +%Y-%m-%d)_start.logs
    cd $ES_DIR
    ./elasticsearch -d
else
    echo "进程存在，拜佛！" >> ${BASE_DIR}/$(date +%Y-%m-%d)_start.logs
fi
