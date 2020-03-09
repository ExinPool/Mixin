#!/bin/bash
#
# Copyright © 2019 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: Mixin co-signer.
# User: Robin@ExinPool
# Date: 2019-12-05
# Time: 10:56:39

# load the config library functions
source config.shlib

# load configuration
service="$(config_get SERVICE)"
process="$(config_get PROCESS)"
process_start_num="$(config_get PROCESS_START_NUM)"
process_num_var=`ps -ef | grep ${process} | grep -v grep | wc -l`
coop_dir="$(config_get COOP_DIR)"
log_file="$(config_get LOG_FILE)"
webhook_url="$(config_get WEBHOOK_URL)"
access_token="$(config_get ACCESS_TOKEN)"

if [ ${process_start_num} -eq ${process_num_var} ]
then
    cd ${coop_dir} && nohup ./co-signer >> co-signer.log &
    if [ $? -eq 0 ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` INFO ${service} co-signer start successfully."
        echo $log >> $log_file
        curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' > /dev/null 2>&1
        if [ $? -eq 0 ]
        then
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
            echo $log >> $log_file
        else
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
            echo $log >> $log_file
        fi
    else
        log="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` INFO ${service} co-signer start failed."
        echo $log >> $log_file
        curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' > /dev/null 2>&1
        if [ $? -eq 0 ]
        then
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
            echo $log >> $log_file
        else
            log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
            echo $log >> $log_file
        fi
    fi
else
    log="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` ERROR ${service} co-signer is already started."
    echo $log >> $log_file
    curl ${webhook_url}=${access_token} -XPOST -H 'Content-Type: application/json' -d '{"category":"PLAIN_TEXT","data":"'"$log"'"}' > /dev/null 2>&1
    if [ $? -eq 0 ]
    then
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin successfully."
        echo $log >> $log_file
    else
        log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO send mixin failed."
        echo $log >> $log_file
    fi
fi