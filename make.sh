#!/usr/bin/env bash
set -euo pipefail

MAX_PARALLEL=4
DEBUG_OPTS=""

get_ini() {
    local key="$1"
    local value
    value="$(grep -E "^[[:space:]]*${key}[[:space:]]*=" build.ini | head -1 | cut -d= -f2-)"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    printf '%s' "$value"
}

FONT_NAME="$(get_ini FONT_NAME)"
BUILD_DIR="$(get_ini BUILD_FONTS_DIR)"
BUILD_DIR="${BUILD_DIR:-build}"

if [ -z "$FONT_NAME" ]; then
    echo "ERROR: build.ini から FONT_NAME を読めませんでした" >&2
    exit 1
fi

if [ "${DEBUG:-0}" = "1" ]; then
    echo "### Debug Mode ###"
    DEBUG_OPTS="--debug"
fi

mkdir -p "$BUILD_DIR"
find "$BUILD_DIR" -mindepth 1 -delete

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
        "--console|Console-"
    )
    styles=(
        Regular
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
    styles=(
        Regular
        Bold
        Thin
        ExtraLight
        Light
        Text
        Medium
        SemiBold
        Italic
        BoldItalic
        ThinItalic
        ExtraLightItalic
        LightItalic
        TextItalic
        MediumItalic
        SemiBoldItalic
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

if (( fail != 0 )); then
    echo "ERROR: ビルドジョブが失敗しました" >&2
    exit 1
fi

echo "### Checking generated fonts ###"
missing=0
expected_files=()

for item in "${variants[@]}"; do
    variant="${item#*|}"
    for style in "${styles[@]}"; do
        filename="${FONT_NAME}${variant}${style}.ttf"
        expected_files+=("$filename")
        if [ ! -f "${BUILD_DIR}/${filename}" ]; then
            echo "MISSING: ${BUILD_DIR}/${filename}" >&2
            missing=1
        fi
    done
done

shopt -s nullglob
actual_files=("${BUILD_DIR}/${FONT_NAME}"*-*.ttf)
shopt -u nullglob

declare -A expected_set=()
for filename in "${expected_files[@]}"; do
    expected_set["$filename"]=1
done

unexpected=0
for path in "${actual_files[@]+"${actual_files[@]}"}"; do
    filename="${path##*/}"
    if [ -z "${expected_set[$filename]+x}" ]; then
        echo "UNEXPECTED: ${path}" >&2
        unexpected=1
    fi
done

echo "expected=${#expected_files[@]}  actual=${#actual_files[@]}"
if (( missing != 0 || unexpected != 0 )); then
    echo "ERROR: 生成フォントの一覧と実ファイルが一致しません" >&2
    exit 1
fi

echo "### Checking font readability ###"
check_args=()
for filename in "${expected_files[@]}"; do
    check_args+=("${BUILD_DIR}/${filename}")
done
python3 check_generated_fonts.py "${check_args[@]}"

echo "### Build OK ###"
exit 0
