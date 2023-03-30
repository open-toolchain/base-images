#! /bin/sh
if [ -n "$(df -t virtiofs /var/lib/docker | tail -n +2)" ] && [ -z "$(mount -t ext4 | grep /var/lib/docker)" ]
then 
    apk -e info e2fsprogs || apk add e2fsprogs
    truncate -s 50G /tmp/disk.img
    mkfs.ext4 /tmp/disk.img
    mount /tmp/disk.img /var/lib/docker
fi