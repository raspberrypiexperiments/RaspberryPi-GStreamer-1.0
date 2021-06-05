# RaspberryPi-GStreamer-1.0

This repository includes installation procedure for GStreamer 1.18.1.

## Installation procedure

```bash
~ $ git clone --recurse-submodules https://github.com/raspberrypiexperiments/RaspberryPi-GStremaer-1.0.git
~ $ cd RaspberryPi-GStremaer-1.0
~/RaspberryPi-GStremaer-1.0 $ make install
~/RaspberryPi-GStremaer-1.0 $ echo "export PATH=~/.local/bin:/usr/local/bin:$PATH" >> ~/.basrc
~/RaspberryPi-GStremaer-1.0 $ echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
~/RaspberryPi-GStremaer-1.0 $ echo "export PYTHONPATH=~/.local/lib/python3.7/site-packages:/usr/local/lib/python3.7/site-packages:$PYTHONPATH" >> ~/.bashrc
~/RaspberryPi-GStremaer-1.0 $ source ~/.bashrc
```

## Unistallation procedure

```bash
~/RaspberryPi-GStremaer-1.0 $ make uninstall
~/RaspberryPi-GStremaer-1.0 $ cd ..
~ $ rm -rf RaspberryPi-GStremaer-1.0
```

## Known issues

1. __gst-plugins-plugins-bad__ does not build if __libwyaland-dev__ is installed. The package is a dependency of __libgtk-3-dev__ installed by RaspberryPi-OpenCV project. __libgtk-3-dev__ is optional. It is necesarry to investigate if __libgtk-3-dev__ is really required or how to fix undefined reference to __gst_gl_display_wayland_get_type__ in __GstGLWayland-1.0.c__

2. __cerbero__ build does not generate __deb__ packages:

    _-----> Creating package for gstreamer-1.0
WARNING: No specific packager available for the distro version debian_10_buster, using generic packager for distro debian
WARNING: Creation of Debian packages is currently broken, please see https://gitlab.freedesktop.org/gstreamer/cerbero/issues/56
Creating tarballs instead..._

    Maybe it is better to use __gst-build__ instead and use __cerbero__ to install all the optional dependencies.

3. __cerbero__ build uses prefix __/usr/local__ and is built with __sudo__. Maybe it is better to build it locally and install from tarballs instead.
