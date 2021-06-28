#!/bin/bash
#
# Copyright © 2019 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: Mixin process monitor script.
# User: Robin@ExinPool
# Date: 2021-04-30
# Time: 17:28:18

# load the config library functions
source config.shlib

# load configuration
service="$(config_get SERVICE)"
port="$(config_get PORT)"
declare -a node_arr="$(config_get NODE_ARRAY)"
log_file="$(config_get LOG_FILE)"
webhook_url="$(config_get WEBHOOK_URL)"
access_token="$(config_get ACCESS_TOKEN)"

for node in "${node_arr[@]}"
do
    connect=`nc -w 30 $node $port < /dev/null; echo $?`
    if [ ${connect} -eq 0 ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO ${service} $node:$port status is normal."
        echo $log >> $log_file
    else
        log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n 主机名: `hostname` \n 节点: $node:$port \n 状态: 节点异常，请尽快检查。"
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
done
