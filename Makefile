V86_VERSION = 0.5.44
SEABIOS_VERSION = 1.10.0
VGABIOS_VERSION = 0.4c

pre:
	mkdir -p build
	mkdir -p distro
	mkdir -p distro/fs

deps: pre
	# x86 emulator
	wget -O build/libv86.js https://cdn.jsdelivr.net/npm/v86@$(V86_VERSION)/build/libv86.js
	wget -O build/v86.wasm https://cdn.jsdelivr.net/npm/v86@$(V86_VERSION)/build/v86.wasm

	# bios
	mkdir -p bios
	curl -L https://www.seabios.org/downloads/bios.bin-$(SEABIOS_VERSION).gz | gzip -d > bios/seabios.bin

	# vga bios
	wget -O bios/vgabios.bin https://download-mirror.savannah.gnu.org/releases/vgabios/vgabios-$(VGABIOS_VERSION).bin

build: build-linux build-busybox

build-linux: pre
	cp linux.config linux/.config
	cd linux && make -j $(nproc) && cp arch/x86/boot/bzImage ../distro/bzImage

build-busybox: pre
	cp busybox.config busybox/.config
	cd busybox && patch -p1 < ../patches/busybox/*.patch || true
	cd busybox && make -j $(nproc) && cp busybox ../distro/busybox
	mkdir -p distro/fs/usr/bin
	./distro/busybox --install -s distro/fs/usr/bin

clean:
	rm -rf build

serve:
	python3 -m http.server
