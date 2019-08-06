# Mixin Monitor

> Mixin node monitor tools.

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

- Python 2.7+ required

### Clone

- Clone this repo to your server using:

``` bash
cd /data/ExinPool && git clone https://github.com/ExinPool/Mixin
```

### Setup

Change QQ mail configurations in `send_mail` function.

``` bash
    sender='xxxxxxxx'
    password = 'xxxxxxxx'
    receiver='xxxxxxxx'
```

Change node url in `mixin_blocks_crontab.sh`.

Finally, add crontab like this.

``` bash
* * * * * nohup bash /data/ExinPool/Mixin/monitor/mixin_blocks_crontab.sh &
```

The crontab will run every minutes then you can check the log in `/home/${YOUR_USER}/mixin_blocks.log`.

When the node is not full sync with the remote node, you can receive QQ email. It's highly recommended bind the QQ email with WeChat, then you can receive the alarm email in time.

## Features

- Monitor multiple node like validator, sync and backup
- Alarm by QQ email when node is abnormal

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