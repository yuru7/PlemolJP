#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
PREFIX="$1"

function mvBuild() {
  mkdir -p "${BASE_DIR}/build/PlemolJP"
  mkdir -p "${BASE_DIR}/build/PlemolJPConsole"
  mkdir -p "${BASE_DIR}/build/PlemolJP35"
  mkdir -p "${BASE_DIR}/build/PlemolJP35Console"
  mv -f "${BASE_DIR}/"PlemolJP35Console*.ttf "${BASE_DIR}/build/PlemolJP35Console/"
  mv -f "${BASE_DIR}/"PlemolJP35*.ttf "${BASE_DIR}/build/PlemolJP35/"
  mv -f "${BASE_DIR}/"PlemolJPConsole*.ttf "${BASE_DIR}/build/PlemolJPConsole/"
  mv -f "${BASE_DIR}/"PlemolJP*.ttf "${BASE_DIR}/build/PlemolJP/"
}

"${BASE_DIR}/plemoljp_generator.sh" "$PREFIX" \
&& "${BASE_DIR}/os2_patch.sh" "$PREFIX" \
&& mvBuild
