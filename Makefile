dependencies:
	sudo apt update
	sudo apt upgrade -y
	cd cerbero && git checkout 1.18.1

install: dependencies
	if ! patch -R -p1 -s -f --dry-run <0001_gst-omx-1.0.recipe.patch; then patch -p1 < 0001_gst-omx-1.0.recipe.patch; fi
	if ! patch -R -p1 -s -f --dry-run <0002_linux.config.patch; then patch -p1 < 0002_linux.config.patch; fi
	wget https://raw.githubusercontent.com/GStreamer/cerbero/a3468728489f2fcaa7fcdaddba446468b1f00dfb/recipes/libsrtp/0001-Fix-building-with-gcc-10.patch -O cerbero/recipes/libsrtp/0001-Fix-building-with-gcc-10.patch
	wget https://raw.githubusercontent.com/GStreamer/cerbero/a3468728489f2fcaa7fcdaddba446468b1f00dfb/recipes/libsrtp/0002-ios-Remove-flags-incompatible-with-fembed-bitcode.patch -O cerbero/recipes/libsrtp/0002-ios-Remove-flags-incompatible-with-fembed-bitcode.patch
	wget https://raw.githubusercontent.com/GStreamer/cerbero/a3468728489f2fcaa7fcdaddba446468b1f00dfb/recipes/libsrtp.recipe -O cerbero/recipes/libsrtp.recipe
	if ! patch -R -p1 -s -f --dry-run <0003_libsrtp.recipe.patch; then patch -p1 < 0003_libsrtp.recipe.patch; fi
	if [ -f /etc/lsb-release ]; then sudo mv /etc/lsb-release /etc/lsb-release.bak; fi
	cd cerbero && sudo ./cerbero-uninstalled bootstrap
	cd cerbero && sudo ./cerbero-uninstalled -c config/linux.config -v rpi package gstreamer-1.0 || true
	sudo ldconfig
	if [ -f /etc/lsb-release.bak ]; then sudo mv /etc/lsb-release.bak /etc/lsb-release; fi
	cd pygobject && git checkout 3.38.0
	cd pygobject && meson --prefix=/usr/local build && ninja -C build && sudo ninja -C build install
	cd gst-python && git checkout 1.18.1
	cd gst-python && meson --prefix=/usr/local build && ninja -C build && sudo ninja -C build install

uninstall: dependencies
	cd cerbero && sudo ./cerbero-uninstalled wipe