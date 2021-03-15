#!/bin/bash
#
# Copyright © 2019 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: Mixin process monitor script.
# User: Robin@ExinPool
# Date: 2019-08-08
# Time: 18:41:18

# load the config library functions
source config.shlib

# load configuration
service="$(config_get SERVICE)"
host="$(config_get HOST)"
node_id="$(config_get NODE_ID)"
mixin="$(config_get MIXIN)"
log_file="$(config_get LOG_FILE)"
webhook_url="$(config_get WEBHOOK_URL)"
access_token="$(config_get ACCESS_TOKEN)"

topology_first=`$mixin -n $host getinfo | jq '.' | grep topology | awk -F":" '{print $2}' | sed "s/ //g"`
log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO topology: ${topology_first}"
echo $log >> $log_file

sleep 600

topology_second=`$mixin -n $host getinfo | jq '.' | grep topology | awk -F":" '{print $2}' | sed "s/ //g"`
log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO topology: ${topology_second}"
echo $log >> $log_file

if [ ${topology_first} -eq ${topology_second} ]
then
    log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n 主机名: `hostname` \n 节点: $host \n 第一次 topology: ${topology_first} \n 第二次 topology: ${topology_second} \n 状态: 10 分钟没变化，已重启节点"
    echo $log >> $log_file
    success=`curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' | awk -F',' '{print $1}' | awk -F':' '{print $2}'`
    if [ "$success" = "true" ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
        echo $log >> $log_file
    else
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
        echo $log >> $log_file
    fi
    sudo systemctl restart mixin.service
else
    log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO ${service} $host status is normal."
    echo $log >> $log_file
fi