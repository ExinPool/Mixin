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
import yaml
from email.mime.text import MIMEText
from email.utils import formataddr

config = yaml.safe_load(open("config.yml"))

def log_config():
    log_file = config["log_file"]
    logging.basicConfig(filename=log_file,
                                filemode='a',
                                format='%(asctime)s.%(msecs)d %(name)s %(levelname)s %(message)s',
                                datefmt='%Y-%m-%d %H:%M:%S',
                                level=logging.DEBUG)

def send_mixin(content):
    value = {'category':'PLAIN_TEXT', 'data':content}
    webhook_url = config["webhook"].["webhook_url"]
    access_token = config["webhook"].["access_token"]
    response = requests.post(webhook_url.format(access_token), data=value)
    if response.status_code == 200:
        logging.info("Send mixin successfully.")
    else:
        logging.info("Send mixin failed.")

def send_mail(content):
    node_name = config["node_name"]
    sender = config["mail"].["sender"]
    password = config["mail"].["password"]
    receiver = config["mail"].["receiver"]
    subject = config["mail"].["subject"]
    smtp_url = config["mail"].["smtp_url"]
    smtp_port = config["mail"].["smtp_port"]

    ret = True

    try:
        msg = MIMEText(content,'plain', 'utf-8')
        msg['From'] = formataddr([node_name, sender])
        msg['To'] = formataddr([node_name, receiver])
        msg['Subject'] = node_name + subject

        server = smtplib.SMTP_SSL(smtp_url, smtp_port)
        server.login(sender, password)
        server.sendmail(sender, [receiver,], msg.as_string())
        server.quit()
    except Exception:
        ret = False

    if ret:
        logging.info("Mail send successfully")
    else:
        logging.error("Mail send failed")

def check_node(node):
    api_url = config["node"].["api_url"]
    response = requests.get(api_url + node)
    data = json.loads(response.text)
    height = data['data']['graph']['topology']

    return height

def check_sync():
    node_tag = config["node"].["node_tag"]
    local_node = config["node"].["local_node"]
    remote_node_1 = config["node"].["remote_node_1"]
    remote_node_2 = config["node"].["remote_node_2"]

    localHeight = check_node(local_node)
    remoteHeight1 = check_node(remote_node_1)

    if abs(localHeight - remoteHeight1) < 100:
        logging.info("Mixin " + node_tag + " Node: " + local_node + " is full sync.")
    else:
        remoteHeight2 = check_node(remote_node_2)
        if abs(localHeight - remoteHeight2) < 100:
            logging.info("Mixin " + node_tag + " Node: " + local_node + " is full sync.")
        else:
            logging.error("Mixin " + node_tag + " Node: " + local_node + " is not full sync.")
            send_mixin("Mixin " + node_tag + " Node: " + local_node + " is not full sync.")

def main():
    log_config()
    check_sync()

if __name__ == "__main__":
    main()