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

FILE="ssmtp.log"
LOG_FILE="cosigner_state.log"
RECV="YOUR_EMAIL"
SSMTP="/usr/sbin/ssmtp"
PROCESS="co-signer"
PROCESS_NUM=0
SERVICE="Mixin Coop"
DIR="/home/ubuntu/go/src/github.com/fox-one/mint-withdraw/co-signer"

sendMail() {
    echo -n "" > $FILE
    echo "To: $RECV" >> $FILE
    echo "From: $RECV" >> $FILE
    echo "Subject: ${SERVICE} co-signer Monitor" >> $FILE
    echo "" >> $FILE
}

process=`ps -ef | grep ${PROCESS} | grep -v grep | wc -l`

if [ $process -eq ${PROCESS_NUM} ]
then
    cd $DIR && nohup ./co-signer >> co-signer.log &
    if [ $? -eq 0 ]
    then
        LOG="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` INFO ${SERVICE} co-signer start successfully."
        echo $LOG >> $LOG_FILE
        sendMail
        echo $LOG >> $FILE
        $SSMTP $RECV < $FILE
    else
        LOG="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` INFO ${SERVICE} co-signer start failed."
        echo $LOG >> $LOG_FILE
    fi
else
    LOG="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` ERROR ${SERVICE} co-signer is already started."
    echo $LOG >> $LOG_FILE
fi