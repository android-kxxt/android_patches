#!/bin/bash

set -e

[ $UID -eq 0 ] && echo "Running as root is not supported!" && exit 1

# Mounting devices repos from @/android/... to ${ANDROID_BUILD_TOP}/...
ORIGINAL=~/Workspaces/android

entries=(
vendor/{xiaomi/{mondrian,sm8450-common},pfa,extra}
device/xiaomi/{mondrian,sm8450-common}
kernel/xiaomi/sm8450{,-devicetrees,-modules}
external/{kernelsu,prebuilt_bsdtar}
packages/apps/F-Droid{,PrivilegedExtension}
)

for dir in "${entries[@]}"
do
	echo "mounting $dir"
	mkdir -p "$ANDROID_BUILD_TOP/$dir"
	sudo mount --bind "$ORIGINAL/$dir" "$ANDROID_BUILD_TOP/$dir"
done
