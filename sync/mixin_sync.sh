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
remote_host_first="$(config_get REMOTE_HOST_FIRST)"
remote_host_second="$(config_get REMOTE_HOST_SECOND)"
abs_num="$(config_get ABS_NUM)"
node_id="$(config_get NODE_ID)"
mixin="$(config_get MIXIN)"
log_file="$(config_get LOG_FILE)"
webhook_url="$(config_get WEBHOOK_URL)"
access_token="$(config_get ACCESS_TOKEN)"

local_topology=`$mixin -n $host getinfo | jq '.' | grep topology | awk -F":" '{print $2}' | sed "s/ //g"`
remote_first_topology=`$mixin -n ${remote_host_first} getinfo | jq '.' | grep topology | awk -F":" '{print $2}' | sed "s/ //g"`
remote_second_topology=`$mixin -n ${remote_host_second} getinfo | jq '.' | grep topology | awk -F":" '{print $2}' | sed "s/ //g"`
log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO local_topology: ${local_topology}, remote_first_topology: ${remote_first_topology}, remote_second_topology: ${remote_second_topology}"
echo $log >> $log_file

local_first=$((local_topology - remote_first_topology))
local_second=$((local_topology - remote_second_topology))

if [ ${local_first#-} -gt $ ${abs_num} ] && [ ${local_second#-} -gt $ ${abs_num} ]
then
    log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n 主机名: `hostname` \n 节点: $host, ${local_topology} \n 远端节点 1: ${remote_host_first}, ${remote_first_topology} \n 远端节点 2: ${remote_host_second}, ${remote_second_topology} \n 状态: 节点数据不同步。"
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
else
    log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO ${service} $host status is normal."
    echo $log >> $log_file
fi