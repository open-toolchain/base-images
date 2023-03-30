#! /bin/sh
if [ ! -d /proc/sys/fs/binfmt_misc ]; then
    exit 1
fi

if [ ! -f /proc/sys/fs/binfmt_misc/register ]; then
    if ! mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc ; then
        exit 1
    fi
fi

if [ -z $(find /proc/sys/fs/binfmt_misc -type f -name 'qemu-*' -print -quit) ]; then
    /qemu-binfmt-conf.sh --qemu-suffix "-static" -p yes
fi