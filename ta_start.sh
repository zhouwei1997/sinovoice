#!/bin/bash

# ta重启
# 1、检查fastDFS是否启动，没有启动直接结束
# 2、fastdfs启动  则检查ros，启动ros
# 3、检查ros是否启动， ros启动，检查有几个ros进程，存在一个，则启动ta，否则重启ros
# 4、启动ta,检查有几个ta,一个ta,启动完成，大于一个  重启ta

if [ $(ps aux | grep -v grep | grep -i fdfs_tracker) -eq 1 ];then 
    echo "tracker 进程正常。。。。。检查stroage进程"
    if [ $(ps aux | grep -v grep | grep -i fdfs_storage) -eq 1 ];then 
        echo "storage 进程正常。。。。。"
        # 启动ROS
        while [ $(ps aux | grep -v grep | grep -i servicefx_ros) -ne 1 ]
        do 
            if [ $(ps aux | grep -v grep | grep -i servicefx_ros) -eq 0 ];then
                cd /home/hcicloud_ta/ros/ros/bin
                ./servicefx_ros -d
                sleep 30
            elif [ $(ps aux | grep -v grep | grep -i servicefx_ros) -gt 1 ];then
                ps -ef | grep servicefx_ros | grep -v grep | awk '{print $2}' | xargs kill -9
                sleep 5
                cd /home/hcicloud_ta/ros/ros/bin
                ./servicefx_ros -d
                sleep 30
            fi
        done
        # 启动TA
        while [ $(ps aux | grep -v grep | grep -i servicefx_ros) -ne 1 ] 
        do
            if [ $(ps aux | grep -v grep | grep -i servicefx_ros) -eq 0 ];then
                cd /home/hcicloud_ta/cloud/text_analyze/bin
                ./servicefx_text_analyze -d
                sleep 30
            elif [ $(ps aux | grep -v grep | grep -i servicefx_ros) -gt 1 ];then 
                ps -ef | grep servicefx_text_analyze | grep -v grep | awk '{print $2}' | xargs kill -9
                sleep 5
                cd /home/hcicloud_ta/cloud/text_analyze/bin
                ./servicefx_text_analyze -d
                sleep 30
            fi
        done 
    else
        echo "storage 进程检测失败，退出"
        exit 0
    fi
else
    echo "fastDFS 进程检测失败，退出"
    exit 0
fi
