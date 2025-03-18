#!/bin/bash

set -e -x -o pipefail

# apk add ufw vim curl bash

ARCH_RAW=$(uname -m)
case "${ARCH_RAW}" in
    'x86_64')    ARCH='amd64';;
    'x86' | 'i686' | 'i386')     ARCH='386';;
    'aarch64' | 'arm64') ARCH='arm64';;
    'armv7l')   ARCH='armv7';;
    's390x')    ARCH='s390x';;
    *)          echo "Unsupported architecture: ${ARCH_RAW}"; exit 1;;
esac

VERSION=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases/latest \
    | grep tag_name \
    | cut -d ":" -f2 \
    | sed 's/\"//g;s/\,//g;s/\ //g;s/v//')

echo "sing-box version: ${VERSION}"

SINGBOX_VERSION_NAME="sing-box-${VERSION}-linux-${ARCH}"

curl -Lo "sing-box.tar.gz" "https://github.com/SagerNet/sing-box/releases/download/v${VERSION}/${SINGBOX_VERSION_NAME}.tar.gz"

tar -zxvf "sing-box.tar.gz"

if [ -f "${SINGBOX_VERSION_NAME}/sing-box" ]; then
    mv "${SINGBOX_VERSION_NAME}/sing-box" /usr/bin/sing-box
    chmod +x /usr/bin/sing-box
else
    echo "sing-box file not found"
    return 1
fi


# bash <(curl -fsSL https://raw.githubusercontent.com/yzxiu/common-script/refs/heads/main/sing-box.sh)
