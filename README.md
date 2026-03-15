This is a linux emulator served from emu.mauri870.com

```
git clone --recurse-submodules --shallow-submodules
```

```
docker run -it -w /var/build -v $(pwd):/var/build ubuntu:24.04 bash
# inside the container
./setup.sh
make build-linux
make build-busybox

# outside
cd distro/fs
find | cpio -o -H newc > ../init.cpio
cd ..
qemu-system-x86_64 -kernel bzImage -initrd init.cpio -append "rdinit=/sh mitigations=off"
```

```
make deps
make serve
```

```

```