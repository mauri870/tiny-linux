This is the Linux emulator served from linux.mauri870.com.

It is a simple Linux distro built from scratch with busybox and emulated with v86 and xterm.

```
git clone --recurse-submodules --shallow-submodules
```

```
make devenv
./setup.sh
make build
make serve # to serve the emulator in a browser
make qemu # to test the bzImage and initramfs
```
