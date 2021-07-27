#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
PREFIX="$1"

xAvgCharWidth_SETVAL=528
FIRGE_PATTERN=${PREFIX}'PlemolJP[^3]*.ttf'

xAvgCharWidth35_SETVAL=1000
FIRGE35_PATTERN=${PREFIX}'PlemolJP35*.ttf'

for P in ${BASE_DIR}/${FIRGE_PATTERN}; do
  ttx -t OS/2 -t post "$P"

  xAvgCharWidth_value=$(grep xAvgCharWidth "${P%%.ttf}.ttx" | awk -F\" '{print $2}')
  sed -i.bak -e 's,xAvgCharWidth value="'$xAvgCharWidth_value'",xAvgCharWidth value="'${xAvgCharWidth_SETVAL}'",' "${P%%.ttf}.ttx"

  fsSelection_value=$(grep fsSelection "${P%%.ttf}.ttx" | awk -F\" '{print $2}')
  if [ `echo $P | grep Regular` ]; then
    fsSelection_sed_value='00000001 01000000'
  elif [ `echo $P | grep BoldOblique` ]; then
    fsSelection_sed_value='00000001 00100001'
  elif [ `echo $P | grep Bold` ]; then
    fsSelection_sed_value='00000001 00100000'
  elif [ `echo $P | grep Oblique` ]; then
    fsSelection_sed_value='00000001 00000001'
  else
    fsSelection_sed_value='00000001 00000000'
  fi
  sed -i.bak -e 's,fsSelection value="'"$fsSelection_value"'",fsSelection value="'"$fsSelection_sed_value"'",' "${P%%.ttf}.ttx"

  #sed -i.bak -e 's,version value="1",version value="4",' "${P%%.ttf}.ttx"
  
  underlinePosition_value=$(grep 'underlinePosition value' "${P%%.ttf}.ttx" | awk -F\" '{print $2}')
  #sed -i.bak -e 's,underlinePosition value="'$underlinePosition_value'",underlinePosition value="-125",' "${P%%.ttf}.ttx"
  sed -i.bak -e 's,underlinePosition value="'$underlinePosition_value'",underlinePosition value="-70",' "${P%%.ttf}.ttx"

  mv "$P" "${P}_orig"
  ttx -m "${P}_orig" "${P%%.ttf}.ttx"
  
  if [ $? -eq 0 ]; then
    mv -f "${P}_orig" "${BASE_DIR}/bak/"
    mv -f "${P%%.ttf}.ttx" "${BASE_DIR}/bak/"
    rm -f "${P%%.ttf}.ttx.bak"
  fi
done

for P in ${BASE_DIR}/${FIRGE35_PATTERN}; do
  ttx -t OS/2 -t post "$P"

  xAvgCharWidth_value=$(grep xAvgCharWidth "${P%%.ttf}.ttx" | awk -F\" '{print $2}')
  sed -i.bak -e 's,xAvgCharWidth value="'$xAvgCharWidth_value'",xAvgCharWidth value="'${xAvgCharWidth35_SETVAL}'",' "${P%%.ttf}.ttx"

  fsSelection_value=$(grep fsSelection "${P%%.ttf}.ttx" | awk -F\" '{print $2}')
  if [ `echo $P | grep Regular` ]; then
    fsSelection_sed_value='00000001 01000000'
  elif [ `echo $P | grep BoldOblique` ]; then
    fsSelection_sed_value='00000001 00100001'
  elif [ `echo $P | grep Bold` ]; then
    fsSelection_sed_value='00000001 00100000'
  elif [ `echo $P | grep Oblique` ]; then
    fsSelection_sed_value='00000001 00000001'
  else
    fsSelection_sed_value='00000001 00000000'
  fi
  sed -i.bak -e 's,fsSelection value="'"$fsSelection_value"'",fsSelection value="'"$fsSelection_sed_value"'",' "${P%%.ttf}.ttx"

  #sed -i.bak -e 's,version value="1",version value="4",' "${P%%.ttf}.ttx"
  
  underlinePosition_value=$(grep 'underlinePosition value' "${P%%.ttf}.ttx" | awk -F\" '{print $2}')
  #sed -i.bak -e 's,underlinePosition value="'$underlinePosition_value'",underlinePosition value="-125",' "${P%%.ttf}.ttx"
  sed -i.bak -e 's,underlinePosition value="'$underlinePosition_value'",underlinePosition value="-70",' "${P%%.ttf}.ttx"

  mv "$P" "${P}_orig"
  ttx -m "${P}_orig" "${P%%.ttf}.ttx"
  
  if [ $? -eq 0 ]; then
    mv -f "${P}_orig" "${BASE_DIR}/bak/"
    mv -f "${P%%.ttf}.ttx" "${BASE_DIR}/bak/"
    rm -f "${P%%.ttf}.ttx.bak"
  fi
done
