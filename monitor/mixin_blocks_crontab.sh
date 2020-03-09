#!/bin/bash
#
# Copyright © 2019 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: Mixin node monitor crontab script.
# User: Robin@ExinPool
# Date: 2019-08-06
# Time: 18:29:30

nohup /usr/bin/python /data/monitor/exinpool/Mixin/monitor/mixin_blocks.py &
