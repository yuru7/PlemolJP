#!/usr/bin/env bash
set -euo pipefail

MAX_PARALLEL=4
DEBUG_OPTS=""

if [ "${DEBUG:-0}" = "1" ]; then
    echo "### Debug Mode ###"
    DEBUG_OPTS="--debug"
fi

mkdir -p build
find build -mindepth 1 -delete

build_font() {
    options="$1"
    variant="$2"

    echo "FontForge: ${options}"

    # shellcheck disable=SC2086
    fontforge -lang=py -script \
        fontforge_script.py \
        --do-not-delete-build-dir \
        ${DEBUG_OPTS} \
        ${options}

    echo "FontTools: ${variant}"
    python3 fonttools_script.py "${variant}"
}

# 重い Nerd Fonts を先に回して、4並列の待ち時間を抑える
# DEBUG=1 のときは通常版のみ（Regular ウェイトのみ生成）
if [ "${DEBUG:-0}" = "1" ]; then
    variants=(
        "|-"
    )
else
    variants=(
        "--console --nerd-font|ConsoleNF-"
        "--console --35 --nerd-font|35ConsoleNF-"
        "|-"
        "--35|35-"
        "--console|Console-"
        "--console --35|35Console-"
        "--hidden-zenkaku-space|HS-"
        "--hidden-zenkaku-space --35|35HS-"
        "--hidden-zenkaku-space --console|ConsoleHS-"
        "--hidden-zenkaku-space --console --35|35ConsoleHS-"
    )
fi

fail=0

for item in "${variants[@]}"; do
    options="${item%%|*}"
    variant="${item#*|}"

    while (( $(jobs -rp | wc -l) >= MAX_PARALLEL )); do
        wait -n || fail=1
    done

    build_font "${options}" "${variant}" &
done

while (( $(jobs -rp | wc -l) > 0 )); do
    wait -n || fail=1
done

exit "${fail}"
