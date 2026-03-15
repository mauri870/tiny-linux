# tiny-linux

This is a **Linux emulator** served from [linux.mauri870.com](https://linux.mauri870.com).

It runs a **minimal Linux distro built from scratch** using **BusyBox**, emulated with **v86** and **xterm**.

## Getting Started

```bash
git clone --recurse-submodules --shallow-submodules

make devenv
./setup.sh
make build
make serve # to serve the emulator in a browser
make qemu # to test the bzImage and initramfs
```
