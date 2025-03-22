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

VERSION=$(curl -s https://api.github.com/repos/slackhq/nebula/releases/latest \
    | grep tag_name \
    | cut -d ":" -f2 \
    | sed 's/\"//g;s/\,//g;s/\ //g;s/v//')

echo "nebula version: ${VERSION}"

NEBULA_VERSION_NAME="nebula-linux-${ARCH}"

curl -Lo "nebula.tar.gz" "https://github.com/slackhq/nebula/releases/download/v${VERSION}/${NEBULA_VERSION_NAME}.tar.gz"

rm -rf nebula-tmp
mkdir nebula-tmp
tar -zxvf "nebula.tar.gz" -C nebula-tmp

if [ -f "nebula-tmp/nebula" ]; then
    mv nebula-tmp/nebula /usr/bin/nebula
    chmod +x /usr/bin/nebula
    rm -rf nebula-tmp nebula.tar.gz
else
    echo "nebula file not found"
    return 1
fi


# bash <(curl -fsSL https://raw.githubusercontent.com/yzxiu/common-script/refs/heads/main/nebula.sh)
