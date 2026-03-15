#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt update -yq
apt install -yq libncurses-dev xz-utils bzip2 qemu-system-x86 flex bison bc libelf-dev libssl-dev \
    syslinux dosfstools gcc strace ltrace manpages-dev make gcc-i686-linux-gnu