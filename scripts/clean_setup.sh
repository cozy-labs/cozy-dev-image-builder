#!/bin/bash

apt-get -y -qq clean

find /var/log -type f -exec rm {} \;
# cat /dev/zero > /tmp/zero.fill
# rm /tmp/zero.fill
