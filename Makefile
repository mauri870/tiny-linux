pre:
	mkdir -p build build/initramfs/bin

deps: pre
	# bios
	wget -O build/seabios.bin https://github.com/copy/v86/raw/b8a39b11dd2076870699e6cac053556271b9bfab/bios/seabios.bin
	wget -O build/vgabios.bin https://github.com/copy/v86/raw/b8a39b11dd2076870699e6cac053556271b9bfab/bios/vgabios.bin

build: deps build-linux build-busybox initramfs
	cp index.html build/index.html

build-linux: pre
	cp linux.config linux/.config
	cd linux && make LLVM=1 -j $(nproc) && cp arch/x86/boot/bzImage ../build/bzImage

build-busybox: pre
	cp busybox.config busybox/.config
	cd busybox && make CC=clang -j $(nproc)

build-strace: pre
	cd strace && ./bootstrap
	cd strace && ./configure --host=i686-linux-gnu --enable-static --disable-shared LDFLAGS="-static" CFLAGS="-m32" CXXFLAGS="-m32"
	cd strace && make -j $(nproc)

initramfs: clean-initramfs pre
	cp -r rootfs/. build/initramfs/
	mkdir -p build/initramfs/bin
	cp busybox/busybox build/initramfs/busybox
	# cp strace/src/strace build/initramfs/bin/strace
	cd build/initramfs && ln -f busybox sh
	cd build/initramfs && find . -type f -exec file {} + | grep ELF | cut -d: -f1 | xargs strip --strip-debug
	cd build/initramfs && find . | cpio -H newc -o | lzma > ../init.cpio.lzma

qemu:
	qemu-system-x86_64 -kernel build/bzImage -initrd build/init.cpio.lzma

DEVENV_CONTAINER ?= tiny-linux-devenv

devenv:
	@if ! docker ps -a --format '{{.Names}}' | grep -qx '$(DEVENV_CONTAINER)'; then \
		echo "Creating $(DEVENV_CONTAINER) and running setup..."; \
		docker run -d --name $(DEVENV_CONTAINER) -w /var/build -v "$(PWD):/var/build" ubuntu:24.04 tail -f /dev/null; \
		docker exec $(DEVENV_CONTAINER) bash -lc "./setup.sh"; \
	fi
	@docker start $(DEVENV_CONTAINER) >/dev/null
	@docker exec -it $(DEVENV_CONTAINER) bash

clean:
	rm -rf build

clean-initramfs:
	rm -rf build/initramfs/*

serve:
	cd build && npx http-server
