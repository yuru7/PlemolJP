#!/bin/bash

BASE_DIR="$(cd $(dirname $0); pwd)"

PREFIX="$1"

FONT_PATTERN=${PREFIX}'PlemolJP*.ttf'

COPYRIGHT='[IBM Plex]
Copyright © 2017 IBM Corp.

[Nerd Fonts]
Copyright (c) 2014, Ryan L McIntyre (https://ryanlmcintyre.com).

[PlemolJP]
Copyright (c) 2021, Yuko OTAWARA'

for P in ${BASE_DIR}/${FONT_PATTERN}
do
  ttx -t name -t post "$P"
  mv "${P%%.ttf}.ttx" ${BASE_DIR}/tmp.ttx
  cat ${BASE_DIR}/tmp.ttx | perl -pe "s?###COPYRIGHT###?$COPYRIGHT?" > "${P%%.ttf}.ttx"

  mv "$P" "${P}_orig"
  ttx -m "${P}_orig" "${P%%.ttf}.ttx"
done

rm -f "${BASE_DIR}/"*.ttx "${BASE_DIR}/"*_orig
