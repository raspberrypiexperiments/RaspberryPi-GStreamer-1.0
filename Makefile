dependencies:
	sudo apt update
	sudo apt upgrade -y
	sudo apt install ninja-build
	pip3 install --user meson
	cd cerbero && git checkout 1.18.1

install: dependencies
	if ! patch -R -p1 -s -f --dry-run <0001_gst-omx-1.0.recipe.patch; then patch -p1 < 0001_gst-omx-1.0.recipe.patch; fi
	if ! patch -R -p1 -s -f --dry-run <0002_linux.config.patch; then patch -p1 < 0002_linux.config.patch; fi
	wget https://raw.githubusercontent.com/GStreamer/cerbero/a3468728489f2fcaa7fcdaddba446468b1f00dfb/recipes/libsrtp/0001-Fix-building-with-gcc-10.patch -O cerbero/recipes/libsrtp/0001-Fix-building-with-gcc-10.patch
	wget https://raw.githubusercontent.com/GStreamer/cerbero/a3468728489f2fcaa7fcdaddba446468b1f00dfb/recipes/libsrtp/0002-ios-Remove-flags-incompatible-with-fembed-bitcode.patch -O cerbero/recipes/libsrtp/0002-ios-Remove-flags-incompatible-with-fembed-bitcode.patch
	wget https://raw.githubusercontent.com/GStreamer/cerbero/a3468728489f2fcaa7fcdaddba446468b1f00dfb/recipes/libsrtp.recipe -O cerbero/recipes/libsrtp.recipe
	if ! patch -R -p1 -s -f --dry-run <0003_libsrtp.recipe.patch; then patch -p1 < 0003_libsrtp.recipe.patch; fi
	mkdir -p cerbero/recipes/libgstomx
	cp 0001_gstomx.pc.in.patch cerbero/recipes/libgstomx
	cp 0002_meson.build.patch cerbero/recipes/libgstomx
	cd cerbero && sudo ./cerbero-uninstalled bootstrap
	cd cerbero && sudo ./cerbero-uninstalled -c config/linux.config -v rpi package gstreamer-1.0 || true
	sudo ldconfig
	cd pygobject && git checkout 3.38.0
	cd pygobject && meson --prefix=/usr/local build && ninja -C build && sudo -E ninja -C build install
	cd gst-python && git checkout 1.18.1
	cd gst-python && meson --prefix=/usr/local build && ninja -C build && sudo -E ninja -C build install

uninstall: dependencies
	cd cerbero && sudo ./cerbero-uninstalled wipe