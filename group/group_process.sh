#!/bin/bash
#
# Copyright © 2019 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: Mixin process monitor script.
# User: Robin@ExinPool
# Date: 2021-06-01
# Time: 09:37:19

# load the config library functions
source config.shlib

# load configuration
service="$(config_get SERVICE)"
process_num="$(config_get PROCESS_NUM)"
exin_process="$(config_get EXIN_PROCESS)"
exindca_process="$(config_get EXINDCA_PROCESS)"
exinearn_process="$(config_get EXINEARN_PROCESS)"
exinpool_process="$(config_get EXINPOOL_PROCESS)"
fcoin_process="$(config_get FCOIN_PROCESS)"
localcn_process="$(config_get LOCALCN_PROCESS)"
localen_process="$(config_get LOCALEN_PROCESS)"
locald_process="$(config_get LOCALD_PROCESS)"
exin_process_num_var=`sudo netstat -langput | grep LISTEN | grep -w ${exin_process} | wc -l`
exindca_process_num_var=`sudo netstat -langput | grep LISTEN | grep -w ${exindca_process} | wc -l`
exinearn_process_num_var=`sudo netstat -langput | grep LISTEN | grep -w ${exinearn_process} | wc -l`
exinpool_process_num_var=`sudo netstat -langput | grep LISTEN | grep -w ${exinpool_process} | wc -l`
fcoin_process_num_var=`sudo netstat -langput | grep LISTEN | grep -w ${fcoin_process} | wc -l`
localcn_process_num_var=`sudo netstat -langput | grep LISTEN | grep -w ${localcn_process} | wc -l`
localen_process_num_var=`sudo netstat -langput | grep LISTEN | grep -w ${localen_process} | wc -l`
locald_process_num_var=`sudo netstat -langput | grep LISTEN | grep -w ${locald_process} | wc -l`
log_file="$(config_get LOG_FILE)"
webhook_url="$(config_get WEBHOOK_URL)"
access_token="$(config_get ACCESS_TOKEN)"

exin(){
    if [ ${exin_process_num_var} -eq ${process_num} ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO ${service} ${exin_process} process is normal."
        echo $log >> $log_file
    else
        log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n 主机名: `hostname` \n 节点: ${exin_process} \n 状态: 进程不存在，请尽快检查。"
        echo -e $log >> $log_file
        success=`curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' | awk -F',' '{print $1}' | awk -F':' '{print $2}'`
        if [ "$success" = "true" ]
        then
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
            echo $log >> $log_file
        else
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
            echo $log >> $log_file
        fi
    fi
}

exindca(){
    if [ ${exindca_process_num_var} -eq ${process_num} ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO ${service} ${exindca_process} process is normal."
        echo $log >> $log_file
    else
        log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n 主机名: `hostname` \n 节点: ${exindca_process} \n 状态: 进程不存在，请尽快检查。"
        echo -e $log >> $log_file
        success=`curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' | awk -F',' '{print $1}' | awk -F':' '{print $2}'`
        if [ "$success" = "true" ]
        then
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
            echo $log >> $log_file
        else
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
            echo $log >> $log_file
        fi
    fi
}

exinearn(){
    if [ ${exinearn_process_num_var} -eq ${process_num} ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO ${service} ${exinearn_process} process is normal."
        echo $log >> $log_file
    else
        log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n 主机名: `hostname` \n 节点: ${exinearn_process} \n 状态: 进程不存在，请尽快检查。"
        echo -e $log >> $log_file
        success=`curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' | awk -F',' '{print $1}' | awk -F':' '{print $2}'`
        if [ "$success" = "true" ]
        then
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
            echo $log >> $log_file
        else
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
            echo $log >> $log_file
        fi
    fi
}

exinpool(){
    if [ ${exinpool_process_num_var} -eq ${process_num} ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO ${service} ${exinpool_process} process is normal."
        echo $log >> $log_file
    else
        log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n 主机名: `hostname` \n 节点: ${exinpool_process} \n 状态: 进程不存在，请尽快检查。"
        echo -e $log >> $log_file
        success=`curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' | awk -F',' '{print $1}' | awk -F':' '{print $2}'`
        if [ "$success" = "true" ]
        then
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
            echo $log >> $log_file
        else
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
            echo $log >> $log_file
        fi
    fi
}

fcoin(){
    if [ ${fcoin_process_num_var} -eq ${process_num} ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO ${service} ${fcoin_process} process is normal."
        echo $log >> $log_file
    else
        log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n 主机名: `hostname` \n 节点: ${fcoin_process} \n 状态: 进程不存在，请尽快检查。"
        echo -e $log >> $log_file
        success=`curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' | awk -F',' '{print $1}' | awk -F':' '{print $2}'`
        if [ "$success" = "true" ]
        then
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
            echo $log >> $log_file
        else
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
            echo $log >> $log_file
        fi
    fi
}

localcn(){
    if [ ${localcn_process_num_var} -eq ${process_num} ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO ${service} ${localcn_process} process is normal."
        echo $log >> $log_file
    else
        log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n 主机名: `hostname` \n 节点: ${localcn_process} \n 状态: 进程不存在，请尽快检查。"
        echo -e $log >> $log_file
        success=`curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' | awk -F',' '{print $1}' | awk -F':' '{print $2}'`
        if [ "$success" = "true" ]
        then
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
            echo $log >> $log_file
        else
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
            echo $log >> $log_file
        fi
    fi
}

localen(){
    if [ ${localen_process_num_var} -eq ${process_num} ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO ${service} ${localen_process} process is normal."
        echo $log >> $log_file
    else
        log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n 主机名: `hostname` \n 节点: ${localen_process} \n 状态: 进程不存在，请尽快检查。"
        echo -e $log >> $log_file
        success=`curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' | awk -F',' '{print $1}' | awk -F':' '{print $2}'`
        if [ "$success" = "true" ]
        then
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
            echo $log >> $log_file
        else
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
            echo $log >> $log_file
        fi
    fi
}

locald(){
    if [ ${locald_process_num_var} -eq ${process_num} ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO ${service} ${locald_process} process is normal."
        echo $log >> $log_file
    else
        log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n 主机名: `hostname` \n 节点: ${locald_process} \n 状态: 进程不存在，请尽快检查。"
        echo -e $log >> $log_file
        success=`curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' | awk -F',' '{print $1}' | awk -F':' '{print $2}'`
        if [ "$success" = "true" ]
        then
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
            echo $log >> $log_file
        else
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
            echo $log >> $log_file
        fi
    fi
}

exin
exindca
exinearn
exinpool
fcoin
localcn
localen
locald