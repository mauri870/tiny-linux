#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt update -yq
apt install -yq autoconf libncurses-dev xz-utils bzip2 qemu-system-x86 flex bison bc cpio wget curl libelf-dev libssl-dev \
    syslinux dosfstools gcc strace ltrace manpages-dev make gcc-i686-linux-gnu git file gawk

# musl i686 cross-compiler
wget -qO /tmp/i686-musl.tgz https://musl.cc/i686-linux-musl-cross.tgz
tar -C /usr/local -xf /tmp/i686-musl.tgz
ln -sf /usr/local/i686-linux-musl-cross/bin/i686-linux-musl-gcc /usr/local/bin/i686-linux-musl-gcc
rm /tmp/i686-musl.tgz
