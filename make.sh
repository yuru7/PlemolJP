#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)

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

function mvBuildHS() {
  mkdir -p "${BASE_DIR}/build/PlemolJP_HS"
  mkdir -p "${BASE_DIR}/build/PlemolJPConsole_HS"
  mkdir -p "${BASE_DIR}/build/PlemolJP35_HS"
  mkdir -p "${BASE_DIR}/build/PlemolJP35Console_HS"
  mv -f "${BASE_DIR}/"PlemolJP35Console*.ttf "${BASE_DIR}/build/PlemolJP35Console_HS/"
  mv -f "${BASE_DIR}/"PlemolJP35*.ttf "${BASE_DIR}/build/PlemolJP35_HS/"
  mv -f "${BASE_DIR}/"PlemolJPConsole*.ttf "${BASE_DIR}/build/PlemolJPConsole_HS/"
  mv -f "${BASE_DIR}/"PlemolJP*.ttf "${BASE_DIR}/build/PlemolJP_HS/"
}

"${BASE_DIR}/plemoljp_generator.sh" \
&& "${BASE_DIR}/os2_patch.sh" \
&& mvBuild

"${BASE_DIR}/plemoljp_generator.sh" -h \
&& "${BASE_DIR}/os2_patch.sh" \
&& mvBuildHS
