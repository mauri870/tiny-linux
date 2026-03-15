V86_VERSION = 0.5.44
XTERMJS_VERSION = 5.5.0

pre:
	mkdir -p build
	mkdir -p distro
	mkdir -p distro/fs

deps: pre
	# x86 emulator
	wget -O build/libv86.js https://cdn.jsdelivr.net/npm/v86@$(V86_VERSION)/build/libv86-debug.js
	wget -O build/v86.wasm https://cdn.jsdelivr.net/npm/v86@$(V86_VERSION)/build/v86-debug.wasm

	# xterm
	wget -O build/xterm.js https://cdnjs.cloudflare.com/ajax/libs/xterm/$(XTERMJS_VERSION)/xterm.js

	# bios
	mkdir -p bios
	wget -O bios/seabios.bin https://github.com/copy/v86/raw/refs/heads/master/bios/seabios.bin
	wget -O bios/vgabios.bin https://github.com/copy/v86/raw/refs/heads/master/bios/vgabios.bin

build: build-linux build-busybox

build-linux: pre
	cp linux.config linux/.config
	cd linux && make -j $(nproc) && cp arch/x86/boot/bzImage ../distro/bzImage

build-busybox: pre
	cp busybox.config busybox/.config
	cd busybox && patch -p1 < ../patches/busybox/*.patch || true
	cd busybox && make -j $(nproc) && cp busybox ../distro/busybox
	mkdir -p distro/fs

clean:
	rm -rf build

serve:
	npx http-server
