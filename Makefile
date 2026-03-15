pre:
	mkdir -p build build/initramfs

deps: pre
	# bios
	wget -O build/seabios.bin https://github.com/copy/v86/raw/b8a39b11dd2076870699e6cac053556271b9bfab/bios/seabios.bin
	wget -O build/vgabios.bin https://github.com/copy/v86/raw/b8a39b11dd2076870699e6cac053556271b9bfab/bios/vgabios.bin

build: deps build-linux build-busybox initramfs
	cp index.html build/index.html

build-linux: pre
	cp linux.config linux/.config
	cd linux && make -j $(nproc) && cp arch/x86/boot/bzImage ../build/bzImage

build-busybox: pre
	cp busybox.config busybox/.config
	cd busybox && patch -p1 < ../patches/busybox/*.patch || true
	cd busybox && make -j $(nproc) && cp busybox ../build/initramfs/busybox

initramfs: pre
	cp -r rootfs/. build/initramfs/
	cd build/initramfs && ln -f busybox sh
	cd build/initramfs && find . | cpio -H newc -o | lzma > ../init.cpio.lzma

qemu:
	qemu-system-x86_64 -kernel build/bzImage -initrd build/init.cpio.lzma

devenv:
	docker run -it -w /var/build -v "$(PWD):/var/build" ubuntu:24.04 bash

clean:
	rm -rf build

serve:
	cd build && npx http-server
