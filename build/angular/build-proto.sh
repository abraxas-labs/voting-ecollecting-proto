#! /bin/bash

set -Eeuo pipefail

echo "------------------"
echo "setup dependencies"
echo "------------------"

# source: https://stackoverflow.com/a/246128/3302887
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck source=build/angular/setup-dependencies.sh
source "${DIR}/setup-dependencies.sh"

OUT="${PWD}/src/grpc-gen"
DOCS_OUT="${PWD}/../../docs"
PROTO_PATH="${PWD}/../../src"
PROTOC_EXEC="$(which protoc)"
PROTOC_WEB_EXEC="$(which protoc-gen-grpc-web)"
PROTOC_DOC_EXEC="$(which protoc-gen-doc)"
PROTO_VALIDATION_PACKAGE_PATH="${PWD}/../../voting-library-validation-proto/src"

echo "----------------"
echo "Generate GRPCWeb"
echo "----------------"

rm -rf "${OUT}"
mkdir -p "${OUT}"
mkdir -p "${DOCS_OUT}"

# doesnt make sense here, since wee need to expand the files
# shellcheck disable=SC2046
${PROTOC_EXEC} \
    --plugin=protoc-gen-grpc-web="${PROTOC_WEB_EXEC}" \
    -I="${PROTO_PATH}" \
    -I="${PROTO_VALIDATION_PACKAGE_PATH}" \
    --plugin=protoc-gen-ng=./node_modules/.bin/protoc-gen-ng --ng_out="${OUT}" \
    --plugin=proto-gen-doc="${PROTOC_DOC_EXEC}" \
    --doc_out="${DOCS_OUT}" \
    --doc_opt=html,index.html:google/* \
    $(find "${PROTO_PATH}" "${PROTO_VALIDATION_PACKAGE_PATH}" -name '*.proto')
