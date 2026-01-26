#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q powermanga | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/pixmaps/powermanga.png
export DESKTOP=/usr/share/applications/powermanga.desktop

# Deploy dependencies
quick-sharun /usr/bin/powermanga
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/share/games/powermanga' >> ./AppDir/.env

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
