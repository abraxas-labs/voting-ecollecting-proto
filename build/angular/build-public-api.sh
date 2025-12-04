#! /bin/bash

set -Eeuo pipefail

API_FILE="public_api.ts"


mv "./src/grpc-gen/admin/"* "./admin/src/"
mv "./src/grpc-gen/citizen/"* "./citizen/src/"

update_shared_imports() {
  # replace relative shared import paths with the package name
  # this results in a lot more beeing imported than needed
  # but the shared package doesn't contain too much code
  # so it shouldn't be a problem.
  find "$1" -type f -name "*.ts" | while read -r file; do
    if [[ $(uname) == "Darwin" ]]; then
      sed -i '' -E "s|'\.\.?\/(\.\.?\/)*shared\/.+'|'@abraxas/voting-ecollecting-proto'|g" "$file"
    else
      sed -i -E "s|'\.\.?\/(\.\.?\/)*shared\/.+'|'@abraxas/voting-ecollecting-proto'|g" "$file"
    fi
  done
}

generate_public_api() {
  local cwd="$PWD"
  cd "$1"

  # shellcheck disable=SC2227
  find "." -type f -name "*.ts" -exec echo "export * from '"'{}'"';" >> "$API_FILE" \;

  # strip src_dir prefix and .ts suffix
  if [[ $(uname) == "Darwin" ]]; then
    sed -i '' -e 's/\.ts//g' "$API_FILE"
  else
    sed -i 's/\.ts//g' "$API_FILE"
  fi

  cd "$cwd"
}

update_shared_imports "./admin/src/"
update_shared_imports "./citizen/src/"

generate_public_api "./src"
generate_public_api "./admin/src"
generate_public_api "./citizen/src"
