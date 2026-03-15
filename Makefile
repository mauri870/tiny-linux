V86_VERSION = 0.5.44
SEABIOS_VERSION = 1.10.0

all: deps

deps:
	# x86 emulator
	mkdir -p build
	wget -O build/libv86.js https://cdn.jsdelivr.net/npm/v86@$(V86_VERSION)/build/libv86.js
	wget -O build/v86.wasm https://cdn.jsdelivr.net/npm/v86@$(V86_VERSION)/build/v86.wasm

	# seabios
	mkdir -p bios
	curl -L https://www.seabios.org/downloads/bios.bin-$(SEABIOS_VERSION).gz | gzip -d > bios/seabios.bin

clean:
	rm -rf build

serve:
	python3 -m http.server
