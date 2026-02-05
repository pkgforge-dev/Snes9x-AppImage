#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    pipewire-audio \
    pipewire-jack  \
    cairo          \
    cmake          \
    alsa-lib       \
    gdk-pixbuf2    \
    gtk3           \
    gtkmm3         \
    hicolor-icon-theme \
    intltool       \
    libdecor       \
    libepoxy       \
    libpng         \
    libpulse       \
    libx11         \
    libxext        \
    libxml2        \
    libxrandr      \
    libxv          \
    meson          \
    minizip        \
    nasm           \
    portaudio      \
    sdl2           \
    zlib
    #glib2 \

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of Snes9x-GTK..."
echo "---------------------------------------------------------------"
REPO="https://github.com/snes9xgit/snes9x"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./snes9x
echo "$VERSION" > ~/version

cd ./snes9x
pushd "unix"
    ./configure \
        --prefix='/usr' \
        --enable-netplay
make -j$(nproc)
popd

cd gtk
mkdir -p build && cd build
cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_C_FLAGS="-Wno-error=format-security" \
    -DCMAKE_CXX_FLAGS="-Wno-error=format-security"
make -j$(nproc)
make install
