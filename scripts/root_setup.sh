#!/bin/bash

set -e

# Updating and Upgrading dependencies
sudo apt-get purge -y -qq apt-xapian-index aptitude aptitude-common command-not-found laptop-detect language-pack-en language-pack-en-base language-pack-gnome-en language-pack-gnome-en-base lvm2 manpages manpages-dev nano ntfs-3g parted popularity-contest powermgmt-base ppp pppconfig pppoeconf tasksel tasksel-data tcpdump telnet

sudo apt-get update -y -qq > /dev/null
sudo apt-get upgrade -y -qq > /dev/null

# Install necessary libraries for guest additions and Vagrant NFS Share
sudo apt-get -y -q install linux-headers-$(uname -r) build-essential dkms nfs-common

# Setup sudo to allow no-password sudo for "admin"
groupadd -r admin
usermod -a -G admin vagrant
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers
