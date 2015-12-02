#!/bin/bash

# Mount the disk image
mkdir /tmp/isomount
mount -t iso9660 -o loop VBoxGuestAdditions.iso /tmp/isomount

# Install the drivers
/tmp/isomount/VBoxLinuxAdditions.run --nox11

# Cleanup
umount /tmp/isomount
rm -rf /tmp/isomount VBoxGuestAdditions.iso
