#!/bin/bash

set -e -o pipefail

apk add ufw vim curl bash

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


curl -Lo sing-box.pkg.tar.zst "https://github.com/SagerNet/sing-box/releases/download/v${VERSION}/sing-box-${VERSION}_linux_${ARCH}.tar.gz"


# 
