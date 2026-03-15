V86_VERSION = 0.5.44
SEABIOS_VERSION = 1.10.0

pre:
	mkdir -p build

deps: pre
	# x86 emulator
	wget -O build/libv86.js https://cdn.jsdelivr.net/npm/v86@$(V86_VERSION)/build/libv86.js
	wget -O build/v86.wasm https://cdn.jsdelivr.net/npm/v86@$(V86_VERSION)/build/v86.wasm

	# bios
	mkdir -p bios
	curl -L https://www.seabios.org/downloads/bios.bin-$(SEABIOS_VERSION).gz | gzip -d > bios/seabios.bin

build: build-linux

build-linux: pre
	cp .config linux
	cd linux && make -j $(nproc) && cp arch/x86/boot/bzImage ../build/bzImage

clean:
	rm -rf build

serve:
	python3 -m http.server
