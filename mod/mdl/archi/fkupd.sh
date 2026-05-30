#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_ARG="${1:-}"
if [[ -n "${SRC_ARG}" ]]; then
  if [[ "${SRC_ARG}" = /* ]]; then
    SRC_DIR="${SRC_ARG%/}"
  else
    SRC_DIR="${ROOT_DIR}/${SRC_ARG%/}"
  fi
else
  SRC_DIR="${SRC_DIR:-${ROOT_DIR}/trunk}"
fi

DEST_APP="${DEST_APP:-/Users/normenmueller/Applications/Archi.app}"
JRE_DIR="${JRE_DIR:-${ROOT_DIR}/acc/jre}"
BUILD_DIR_REL="com.archimatetool.editor.product/target/products/com.archimatetool.editor.product/macosx/cocoa/aarch64/Archi.app"

log() {
  printf "[fkupd] %s\n" "$1"
}

fail() {
  printf "[fkupd] ERROR: %s\n" "$1" >&2
  exit 1
}

log "Using project root: ${ROOT_DIR}"
log "Using source dir: ${SRC_DIR}"
log "Using destination app: ${DEST_APP}"
log "Using bundled JRE: ${JRE_DIR}"

if [[ ! -d "${SRC_DIR}" ]]; then
  fail "Source directory not found: ${SRC_DIR}"
fi

if [[ ! -d "${JRE_DIR}" ]]; then
  fail "JRE directory not found: ${JRE_DIR}"
fi

cd "${SRC_DIR}"

log "Build product (macOS Apple Silicon)"
mvn -Pproduct -DskipTests clean verify

BUILD_APP="${SRC_DIR}/${BUILD_DIR_REL}"
if [[ ! -d "${BUILD_APP}" ]]; then
  fail "Built app not found: ${BUILD_APP}"
fi

log "Install built app to destination"
rm -rf "${DEST_APP}"
/usr/bin/ditto "${BUILD_APP}" "${DEST_APP}"

log "Embed bundled JRE"
rm -rf "${DEST_APP}/Contents/jre"
/usr/bin/ditto "${JRE_DIR}" "${DEST_APP}/Contents/jre"

log "Done"
