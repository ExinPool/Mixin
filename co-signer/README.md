# Mixin Coop Node Process Monitor

> Mixin Coop Node process monitor tools.

[![Build Status](http://img.shields.io/travis/badges/badgerbadgerbadger.svg?style=flat-square)](https://travis-ci.org/badges/badgerbadgerbadger) [![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

## Table of Contents 

- [Installation](#installation)
- [Features](#features)
- [Contributing](#contributing)
- [Team](#team)
- [FAQ](#faq)
- [Support](#support)
- [License](#license)

## Installation

- Ubuntu 16.04.1 LTS
- Written in bash

### Clone

- Clone this repo to your server using:

``` bash
sudo mkdir -p /data/monitor/exinpool
cd /data/monitor/exinpool
sudo git clone https://github.com/ExinPool/Mixin
```

### Setup

Install related dependencies.

``` bash
sudo apt-get -y install ssmtp
```

Update `ssmtp.conf`.

``` bash
sudo vim /etc/ssmtp/ssmtp.conf

sudo grep "^#" -v /etc/ssmtp/ssmtp.conf
```

The `ssmtp.conf` like this.

``` bash
root=YOUR_EMAIL

mailhub=smtp.exmail.qq.com:465

rewriteDomain=qq.com
AuthUser=YOUR_EMAIL
AuthPass=YOUR_PASSWORD
FromLineOverride=YES
UseTLS=YES
```

Change some varibles like in `start.sh`.

``` bash
FILE="ssmtp.log"
LOG_FILE="cosigner_state.log"
RECV="YOUR_EMAIL"
SSMTP="/usr/sbin/ssmtp"
PROCESS="co-signer"
PROCESS_NUM=0
SERVICE="Mixin Coop"
DIR="/home/ubuntu/go/src/github.com/fox-one/mint-withdraw/co-signer"
```

Change some varibles like in `stop.sh`.

``` bash
FILE="ssmtp.log"
LOG_FILE="cosigner_state.log"
RECV="YOUR_EMAIL"
SSMTP="/usr/sbin/ssmtp"
PROCESS="co-signer"
PROCESS_NUM=1
SERVICE="Mixin Coop"
```

Add crontab like this.

``` bash
# Mixin Coop Node process start monitor
0 18 * * * nohup bash /data/monitor/exinpool/Mixin/co-signer/start.sh >> /data/monitor/exinpool/Mixin/co-signer/cosigner_state.log &

# Mixin Coop Node process stop monitor
0 19 * * * nohup bash /data/monitor/exinpool/Mixin/co-signer/stop.sh >> /data/monitor/exinpool/Mixin/co-signer/cosigner_state.log &
```

The crontab will run every minute then you can check the log in `cosigner_state.log`.

## Features

- Monitor Mixin Coop node process
- Send alarm email when node is started or stoped
- Send email via ssmtp and QQ email

## Contributing

To be continued.

## Team

@ExinPool

## FAQ

To be continued.

## Support

Reach out to us at one of the following places!

- Website at <a href="https://exinpool.com" target="_blank">`exinpool.com`</a>
- Twitter at <a href="http://twitter.com/ExinPool" target="_blank">`@ExinPool`</a>
- Email at `robin@exin.one`

## License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- **[MIT license](https://opensource.org/licenses/mit-license.php)**
- Copyright 2019 © <a href="https://exinpool.com" target="_blank">ExinPool</a>.