# MIT License
#
# Copyright (c) 2021 Marcin Sielski <marcin.sielski@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

dependencies:
	sudo apt update
	sudo apt upgrade -y
	sudo apt install ninja-build libv4l2
	pip3 install --user meson
	cd cerbero && git checkout 1.18.1

install: dependencies
	if ! patch -R -p1 -s -f --dry-run < 0001_gst-omx-1.0.recipe.patch; then patch -p1 < 0001_gst-omx-1.0.recipe.patch; fi
	if ! patch -R -p1 -s -f --dry-run < 0001_linux.config.patch; then patch -p1 < 0001_linux.config.patch; fi
	if ! patch -R -p1 -s -f --dry-run < 0002_enums.py.patch; then patch -p1 < 0002_enums.py.patch; fi
	if ! patch -R -p1 -s -f --dry-run < 0003___init__.py.patch; then patch -p1 < 0003___init__.py.patch; fi
	wget https://raw.githubusercontent.com/GStreamer/cerbero/a3468728489f2fcaa7fcdaddba446468b1f00dfb/recipes/libsrtp/0001-Fix-building-with-gcc-10.patch -O cerbero/recipes/libsrtp/0001-Fix-building-with-gcc-10.patch
	wget https://raw.githubusercontent.com/GStreamer/cerbero/a3468728489f2fcaa7fcdaddba446468b1f00dfb/recipes/libsrtp/0002-ios-Remove-flags-incompatible-with-fembed-bitcode.patch -O cerbero/recipes/libsrtp/0002-ios-Remove-flags-incompatible-with-fembed-bitcode.patch
	wget https://raw.githubusercontent.com/GStreamer/cerbero/a3468728489f2fcaa7fcdaddba446468b1f00dfb/recipes/libsrtp.recipe -O cerbero/recipes/libsrtp.recipe
	if ! patch -R -p1 -s -f --dry-run < 0002_libsrtp.recipe.patch; then patch -p1 < 0002_libsrtp.recipe.patch; fi
	mkdir -p cerbero/recipes/libgstomx
	cp 0001_gstomx.pc.in.patch cerbero/recipes/libgstomx
	cp 0002_meson.build.patch cerbero/recipes/libgstomx
	cp 0003_gstomx.pc.in.patch cerbero/recipes/libgstomx
	cp 0004_meson.build.patch cerbero/recipes/libgstomx
	if ! patch -R -p1 -s -f --dry-run < 0003_gst-plugins-good-1.0.recipe.patch; then patch -p1 < 0003_gst-plugins-good-1.0.recipe.patch; fi
	mkdir -p cerbero/recipes/gst-plugins-good-1.0
	cp 0001_RaspiCapture.c.patch cerbero/recipes/gst-plugins-good-1.0
	cp 0002_gstrpicamsrc.c.patch cerbero/recipes/gst-plugins-good-1.0
	cp 0003_gstmultifilesink.c.patch cerbero/recipes/gst-plugins-good-1.0
	cp 0004_gstmultifilesink.h.patch cerbero/recipes/gst-plugins-good-1.0
	cp 0005_RaspiCapture.h.patch cerbero/recipes/gst-plugins-good-1.0
	cp 0006_RaspiCapture.c.patch cerbero/recipes/gst-plugins-good-1.0
	cp 0007_gstrpicamsrc.c.patch cerbero/recipes/gst-plugins-good-1.0
	cp 0008_gstmultifilesink.c.patch cerbero/recipes/gst-plugins-good-1.0
	cp 0009_gstmultifilesink.h.patch cerbero/recipes/gst-plugins-good-1.0
	cp 0010_RaspiCapture.h.patch cerbero/recipes/gst-plugins-good-1.0
	if ! patch -R -p1 -s -f --dry-run < 0004_libvpx.recipe.patch; then patch -p1 < 0004_libvpx.recipe.patch; fi
	cp 0001_configure.patch cerbero/recipes/libvpx
	if ! patch -R -p1 -s -f --dry-run < 0005_openssl.recipe.patch; then patch -p1 < 0005_openssl.recipe.patch; fi
	if ! patch -R -p1 -s -f --dry-run < 0006_wavpack.recipe.patch; then patch -p1 < 0006_wavpack.recipe.patch; fi
	cd cerbero && sudo ./cerbero-uninstalled bootstrap
	cd cerbero && sudo ./cerbero-uninstalled -c config/linux.config -v rpi package gstreamer-1.0 || true
	sudo ldconfig
	cd pygobject && git checkout 3.38.0
	cd pygobject && ~/.local/bin/meson --prefix=/usr/local build && ninja -C build && sudo -E ninja -C build install
	cd gst-python && git checkout 1.18.1
	cd gst-python && ~/.local/bin/meson --prefix=/usr/local build && ninja -C build && sudo -E ninja -C build install

uninstall: dependencies
	cd cerbero && sudo ./cerbero-uninstalled wipe

rebuild:
	sudo dphys-swapfile swapoff
	sudo dphys-swapfile swapon
	diff -Naur a/build/sources/linux_armv7/gst-plugins-good-1.0-1.18.1/sys/rpicamsrc/RaspiCapture.c b/build/sources/linux_armv7/gst-plugins-good-1.0-1.18.1/sys/rpicamsrc/RaspiCapture.c > 0001_RaspiCapture.c.patch || true
	diff -Naur a/build/sources/linux_armv7/gst-plugins-good-1.0-1.18.1/sys/rpicamsrc/gstrpicamsrc.c b/build/sources/linux_armv7/gst-plugins-good-1.0-1.18.1/sys/rpicamsrc/gstrpicamsrc.c > 0002_gstrpicamsrc.c.patch || true
	diff -Naur a/build/sources/linux_armv7/gst-plugins-good-1.0-1.18.1/sys/rpicamsrc/RaspiCapture.h b/build/sources/linux_armv7/gst-plugins-good-1.0-1.18.1/sys/rpicamsrc/RaspiCapture.h > 0005_RaspiCapture.h.patch || true
	diff -Naur a/cerbero/recipes/gst-plugins-good-1.0.recipe b/cerbero/recipes/gst-plugins-good-1.0.recipe > 0003_gst-plugins-good-1.0.recipe.patch || true
	cp 0001_RaspiCapture.c.patch cerbero/recipes/gst-plugins-good-1.0
	cp 0002_gstrpicamsrc.c.patch cerbero/recipes/gst-plugins-good-1.0
	cp 0005_RaspiCapture.h.patch cerbero/recipes/gst-plugins-good-1.0
	cp a/cerbero/recipes/gst-plugins-good-1.0.recipe cerbero/recipes/gst-plugins-good-1.0.recipe
	if ! patch -R -p1 -s -f --dry-run <0003_gst-plugins-good-1.0.recipe.patch; then patch -p1 < 0003_gst-plugins-good-1.0.recipe.patch; fi
	cd cerbero && sudo ./cerbero-uninstalled -c config/linux.config -v rpi buildone gst-plugins-good-1.0
	sudo dphys-swapfile swapoff
