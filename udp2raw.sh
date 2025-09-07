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
    'mips64')   ARCH='mips64';;
    'mips')     ARCH='mips';;
    *)          echo "Unsupported architecture: ${ARCH_RAW}"; exit 1;;
esac

VERSION=$(curl -s https://api.github.com/repos/wangyu-/udp2raw/releases/latest \
    | grep tag_name \
    | cut -d ":" -f2 \
    | sed 's/\"//g;s/\,//g;s/\ //g')

echo "udp2raw version: ${VERSION}"

UDP2RAW_VERSION_NAME="udp2raw_binaries"

curl -Lo "udp2raw.tar.gz" "https://github.com/wangyu-/udp2raw/releases/download/${VERSION}/${UDP2RAW_VERSION_NAME}.tar.gz"

rm -rf udp2raw-tmp
mkdir udp2raw-tmp
tar -zxvf "udp2raw.tar.gz" -C udp2raw-tmp

# 查找对应架构的二进制文件
BINARY_NAME="udp2raw_${ARCH}"
if [ -f "udp2raw-tmp/${BINARY_NAME}" ]; then
    mv "udp2raw-tmp/${BINARY_NAME}" /usr/bin/udp2raw
    chmod +x /usr/bin/udp2raw
    rm -rf udp2raw-tmp udp2raw.tar.gz
    echo "udp2raw installed successfully to /usr/bin/udp2raw"
else
    echo "udp2raw binary for architecture ${ARCH} not found"
    echo "Available binaries:"
    ls -la udp2raw-tmp/
    rm -rf udp2raw-tmp udp2raw.tar.gz
    exit 1
fi

# 显示使用说明
echo ""
echo "udp2raw 安装完成！"
echo ""
echo "使用示例："
echo "服务器端："
echo "  udp2raw -s -l 0.0.0.0:4096 -r 127.0.0.1:7777 -k \"password\" --raw-mode faketcp -a"
echo ""
echo "客户端："
echo "  udp2raw -c -l 127.0.0.1:3333 -r server_ip:4096 -k \"password\" --raw-mode faketcp"
echo ""
echo "更多选项请使用: udp2raw --help"
echo ""

# bash <(curl -fsSL https://raw.githubusercontent.com/yzxiu/common-script/refs/heads/main/udp2raw.sh)
