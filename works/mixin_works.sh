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

leader_works_first=`curl -s http://api.mixinwallet.com/getinfo | jq '.' | grep ${node_id} -A 7 | grep works -A 2 | grep -v works | sed "s/,//g" | sed -n '1p' | sed "s/ //g"`
signer_works_first=`curl -s http://api.mixinwallet.com/getinfo | jq '.' | grep ${node_id} -A 7 | grep works -A 2 | grep -v works | sed "s/,//g" | sed -n '2p' | sed "s/ //g"`
works_first=$((leader_works_first + signer_works_first))
log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO leader_works: ${leader_works_first}, signer_works: ${signer_works_first}, works_first: ${works_first}"
echo $log >> $log_file

sleep 600

leader_works_second=`curl -s http://api.mixinwallet.com/getinfo | jq '.' | grep ${node_id} -A 7 | grep works -A 2 | grep -v works | sed "s/,//g" | sed -n '1p' | sed "s/ //g"`
signer_works_second=`curl -s http://api.mixinwallet.com/getinfo | jq '.' | grep ${node_id} -A 7 | grep works -A 2 | grep -v works | sed "s/,//g" | sed -n '2p' | sed "s/ //g"`
works_second=$((leader_works_second + signer_works_second))
log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO leader_works: ${leader_works_second}, signer_works: ${signer_works_second}, works_second: ${works_second}"
echo $log >> $log_file

if [ ${works_first} -eq ${works_second} ]
then
    log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n 主机名: `hostname` \n 节点: $host \n 第一次 works 累计: ${works_first} \n 第二次 works 累计: ${works_second} \n 状态: works 10 分钟没变化"
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
