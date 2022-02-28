# Asterisk
Purpose-built Asterisk docker image for personal use as a GSM gateway
## Includes
* asterisk 18.2.2
* chan_dongle

## Usage
### Compose
```yaml
version: "3.0"
services:
  "asterisk":
    image: ghcr.io/alekna/asterisk:latest
    container_name: asterisk
    restart: always
    network_mode: host
    privileged: true
    volumes:
      - /data/asterisk:/etc/asterisk
    devices:
      - /dev/bus/usb:/dev/bus/usb
      - /dev/ttyUSB1:/dev/ttyUSB1
      - /dev/ttyUSB2:/dev/ttyUSB2
    logging:
      driver: "none"
```

### Sample configuration
* dongle.conf
```
[defaults]
context=mobile
 
[Pildyk]
imei=<...>
exten=+370<...>
rxgain=-2
txgain=-4
```

* extensions.conf
```
[mobile]
exten => +370<...>,1,Set(CALLERID(name)=${CALLERID(num)})
exten => +370<...>,n,Dial(SIP/<...>)
exten => +370<...>,n,Hangup()
```

### CLI
```bash
$ docker exec -ti asterisk rasterisk -vvvvvc
Asterisk 18.2.1, Copyright (C) 1999 - 2018, Digium, Inc. and others.
Created by Mark Spencer <markster@digium.com>
Asterisk comes with ABSOLUTELY NO WARRANTY; type 'core show warranty' for details.
This is free software, with components licensed under the GNU General Public
License version 2 and other licenses; you are welcome to redistribute it under
certain conditions. Type 'core show license' for details.
=========================================================================
Connected to Asterisk 18.2.1 currently running on titikaka (pid = 1)
titikaka*CLI> 
titikaka*CLI> dongle show device state Pildyk
-------------- Status -------------
  Device                  : Pildyk
  State                   : Free
  Audio                   : /dev/ttyUSB1
  Data                    : /dev/ttyUSB2
  Voice                   : Yes
  SMS                     : Yes
  Manufacturer            : huawei
  Model                   : E173
  Firmware                : 11.126.85.00.209
  IMEI                    : <...>
  IMSI                    : 24603<...>
  GSM Registration Status : Registered, home network
  RSSI                    : 20, -73 dBm
  Mode                    : No Service
  Submode                 : No service
  Provider Name           : PILDYK
  Location area code      : <...>
  Cell ID                 : <...>
  Subscriber Number       : +370<...>
  SMS Service Center      : +37068499199
  Use UCS-2 encoding      : No
  Tasks in queue          : 0
  Commands in queue       : 0
  Call Waiting            : Disabled
  Current device state    : start
  Desired device state    : start
  When change state       : now
  Calls/Channels          : 0
    Active                : 0
    Held                  : 0
    Dialing               : 0
    Alerting              : 0
    Incoming              : 0
    Waiting               : 0
    Releasing             : 0
    Initializing          : 0

titikaka*CLI>
```
