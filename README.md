This is a linux emulator served from emu.mauri870.com

```
git clone --recurse-submodules --shallow-submodules
```

```
docker run -it -w /var/build -v $(pwd):/var/build ubuntu:24.04 bash
# inside the container
./setup.sh
```

```
make
make serve
```