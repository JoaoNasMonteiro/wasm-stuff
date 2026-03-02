#!/bin/bash

set -e

WASI_VERSION="30"
WASI_VERSION_FULL="30.0"
OS="linux"
ARCH="x86_64"
TARBALL="wasi-sdk-${WASI_VERSION_FULL}-${ARCH}-${OS}.tar.gz"
DOWNLOAD_URL="https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_VERSION}/${TARBALL}"

INSTALL_DIR="$(pwd)/wasi-sdk-${WASI_VERSION_FULL}-${ARCH}-${OS}"

echo "Downloading WASI SDK ${WASI_VERSION_FULL}..."
wget -q --show-progress "$DOWNLOAD_URL"

echo "Extracting $TARBALL..."
tar -xf "$TARBALL"

echo "Cleaning up the tarball..."
rm "$TARBALL"

echo "Configuring ~/.bashrc..."
if grep -q "export WASI_SDK_PATH=" ~/.bashrc; then
    echo "WASI_SDK_PATH is already set in ~/.bashrc. Updating the path..."
    sed -i "s|export WASI_SDK_PATH=.*|export WASI_SDK_PATH=\"$INSTALL_DIR\"|" ~/.bashrc
else
    echo "Adding WASI_SDK_PATH to ~/.bashrc..."
    echo "" >> ~/.bashrc
    echo "# WASM-4 C Compiler Toolchain" >> ~/.bashrc
    echo "export WASI_SDK_PATH=\"$INSTALL_DIR\"" >> ~/.bashrc
fi

echo "======================================================"
echo "Setup complete! The WASI SDK is ready in:"
echo "$INSTALL_DIR"
echo "======================================================"
echo "IMPORTANT: To apply the environment variable to this terminal, run:"
echo "source ~/.bashrc"
