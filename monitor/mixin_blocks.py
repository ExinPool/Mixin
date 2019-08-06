#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright © 2019 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: Mixin node monitor script, alarm by QQ Mail.
# User: Robin@ExinPool
# Date: 2019-08-06
# Time: 17:28:30

import socket
import json
import sys
import logging
import smtplib
import requests
from email.mime.text import MIMEText
from email.utils import formataddr

NODE_NAME = "ExinPool"
NODE_TAG = sys.argv[1]
LOCAL_NODE = sys.argv[2]
REMOTE_NODE_1 = "mixin-node0.exinpool.com:8239"
REMOTE_NODE_2 = "node-42.f1ex.io:1443"

def log_config():
    logging.basicConfig(filename="mixin_blocks.log",
                                filemode='a',
                                format='%(asctime)s.%(msecs)d %(name)s %(levelname)s %(message)s',
                                datefmt='%Y-%m-%d %H:%M:%S',
                                level=logging.DEBUG)

def send_mail(content):
    sender='xxxxxxxx'
    password = 'xxxxxxxx'
    receiver='xxxxxxxx'

    ret = True

    try:
        msg = MIMEText(content,'plain', 'utf-8')
        msg['From'] = formataddr([NODE_NAME, sender])
        msg['To'] = formataddr([NODE_NAME, receiver])
        msg['Subject'] = NODE_NAME + " Mixin 监控"

        server = smtplib.SMTP_SSL("smtp.exmail.qq.com", 465)
        server.login(sender, password)
        server.sendmail(sender, [receiver,], msg.as_string())
        server.quit()
    except Exception:
        ret = False

    if ret:
        logging.info("邮件发送成功")
    else:
        logging.error("邮件发送失败")

def check_node(node):
    response = requests.get("https://api.mixinwallet.com/getinfo?node=" + node)
    data = json.loads(response.text)
    height = data['data']['graph']['topology']

    return height

def check_sync():
    localHeight = check_node(LOCAL_NODE)
    remoteHeight1 = check_node(REMOTE_NODE_1)

    if abs(localHeight - remoteHeight1) < 100:
        logging.info("Mixin " + NODE_TAG + " Node: " + LOCAL_NODE + " is full sync.")
    else:
        remoteHeight2 = check_node(REMOTE_NODE_2)
        if abs(localHeight - remoteHeight2) < 100:
            logging.info("Mixin " + NODE_TAG + " Node: " + LOCAL_NODE + " is full sync.")
        else:
            logging.error("Mixin " + NODE_TAG + " Node: " + LOCAL_NODE + " is not full sync.")
            send_mail("Mixin " + NODE_TAG + " Node: " + LOCAL_NODE + " is not full sync.")

def main():
    log_config()
    check_sync()

if __name__ == "__main__":
    main()