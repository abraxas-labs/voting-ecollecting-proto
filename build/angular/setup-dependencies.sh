#!/usr/bin/env bash

set -Eeuo pipefail

# someday there should be a docker image with all these things pre-installed
# but there is no such infrastructure @ abraxas yet...

PROTOC_VERSION=21.2
PROTOC_GRPC_WEB_VERSION=1.3.1
PROTOC_GEN_DOC_VERSION=1.5.1

PROTOC_DOWNLOAD_URL="https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip"
PROTOC_GRPC_WEB_DOWNLOAD_URL="https://github.com/grpc/grpc-web/releases/download/${PROTOC_GRPC_WEB_VERSION}/protoc-gen-grpc-web-${PROTOC_GRPC_WEB_VERSION}-linux-x86_64"
PROTOC_GEN_DOC_DOWNLOAD_URL="https://github.com/pseudomuto/protoc-gen-doc/releases/download/v${PROTOC_GEN_DOC_VERSION}/protoc-gen-doc_${PROTOC_GEN_DOC_VERSION}_linux_amd64.tar.gz"

BIN=/usr/bin
PROTOC_BIN=/usr/share/protoc

apt-get update

apt-get install -y --no-install-recommends \
    gnupg2 \
    unzip \
    ca-certificates \
    curl

rm -rf /var/lib/apt/lists/*

echo "--------------"
echo "install protoc"
echo "--------------"
echo "url: ${PROTOC_DOWNLOAD_URL}"
curl --fail -L ${PROTOC_DOWNLOAD_URL} -o protoc.zip
unzip protoc.zip -d ./protoc-tmp
mkdir -p ${PROTOC_BIN}
mv ./protoc-tmp/include ${PROTOC_BIN}/
mv ./protoc-tmp/bin/protoc ${PROTOC_BIN}/
chmod +x ${PROTOC_BIN}/protoc
rm -rf protoc.zip ./protoc-tmp
ln -s ${PROTOC_BIN}/protoc ${BIN}/protoc

echo "---------------------------"
echo "install protoc-gen-grpc-web"
echo "---------------------------"
echo "url: ${PROTOC_GRPC_WEB_DOWNLOAD_URL}"
curl --fail -L ${PROTOC_GRPC_WEB_DOWNLOAD_URL} -o ${PROTOC_BIN}/protoc-gen-grpc-web
chmod +x ${PROTOC_BIN}/protoc-gen-grpc-web
ln -s ${PROTOC_BIN}/protoc-gen-grpc-web ${BIN}/protoc-gen-grpc-web

echo "----------------------"
echo "install protoc-gen-doc"
echo "----------------------"
echo "url: ${PROTOC_GEN_DOC_DOWNLOAD_URL}"
curl --fail -L ${PROTOC_GEN_DOC_DOWNLOAD_URL} -o protoc-gen-doc.tar.gz
mkdir ./protoc-gen-doc-tmp
tar -xf protoc-gen-doc.tar.gz -C ./protoc-gen-doc-tmp
mv ./protoc-gen-doc-tmp/protoc-gen-doc ${PROTOC_BIN}/
chmod +x ${PROTOC_BIN}/protoc-gen-doc
rm -rf protoc-gen-doc.tar.gz ./protoc-gen-doc-tmp
ln -s ${PROTOC_BIN}/protoc-gen-doc ${BIN}/protoc-gen-doc
