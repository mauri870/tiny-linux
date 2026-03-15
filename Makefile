V86_VERSION = 0.5.44
XTERMJS_VERSION = 5.5.0

pre:
	mkdir -p build build/initramfs

deps: pre
	# x86 emulator
	wget -O build/libv86.js https://cdn.jsdelivr.net/npm/v86@$(V86_VERSION)/build/libv86.js
	wget -O build/v86.wasm https://cdn.jsdelivr.net/npm/v86@$(V86_VERSION)/build/v86.wasm

	# xterm
	wget -O build/xterm.js https://cdnjs.cloudflare.com/ajax/libs/xterm/$(XTERMJS_VERSION)/xterm.js

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
	chmod +x build/initramfs/init
	cd build/initramfs && ln -f busybox sh
	cd build/initramfs && find . | cpio -H newc -o > ../init.cpio
	rm -rf build/initramfs

clean:
	rm -rf build

serve:
	cd build && npx http-server
