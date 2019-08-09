#!/bin/bash
#
# Copyright © 2019 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: MassGrid process monitor script.
# User: Robin@ExinPool
# Date: 2019-08-08
# Time: 18:41:18

FILE="ssmtp.log"
LOG_FILE="process_state.log"
RECV="YOUR_EMAIL"
SSMTP="/usr/sbin/ssmtp"
PROCESS="mixin"
PROCESS_NUM=2
SERVICE="Mixin"

sendMail() {
    echo -n "" > $FILE
    echo "To: $RECV" >> $FILE
    echo "From: $RECV" >> $FILE
    echo "Subject: ${SERVICE} Node Process Monitor" >> $FILE
    echo "" >> $FILE
}

process=`ps -ef | grep ${PROCESS} | grep -v grep | wc -l`

if [ $process -eq ${PROCESS_NUM} ]
then
    LOG="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` INFO ${SERVICE} node process is normal."
    echo $LOG >> $LOG_FILE
else
    LOG="`date '+%Y-%m-%d %H:%M:%S'` `hostname` `whoami` ERROR ${SERVICE} node process is abnormal."
    echo $LOG >> $LOG_FILE
    sendMail
    echo $LOG >> $FILE
    $SSMTP $RECV < $FILE
fi