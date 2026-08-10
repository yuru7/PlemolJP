#!/usr/bin/env bash
# build/ に出力された TTF をバリエーション別ディレクトリに整理し、zip を作成する
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

get_ini() {
    local key="$1"
    local value
    value="$(grep -E "^[[:space:]]*${key}[[:space:]]*=" build.ini | head -1 | cut -d= -f2-)"
    # 前後の空白を除去
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    printf '%s' "$value"
}

VERSION="$(get_ini VERSION)"
FONT_NAME="$(get_ini FONT_NAME)"
BUILD_DIR="$(get_ini BUILD_FONTS_DIR)"
BUILD_DIR="${BUILD_DIR:-build}"

if [ -z "$VERSION" ] || [ -z "$FONT_NAME" ]; then
    echo "ERROR: build.ini から VERSION / FONT_NAME を読めませんでした" >&2
    exit 1
fi

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

# package_dir|family_dir|file_prefix
# 配布 zip に含める想定のファミリー一覧
expected_families=(
    "${FONT_NAME}_NF_${VERSION}|${FONT_NAME}Console_NF|${FONT_NAME}ConsoleNF"
    "${FONT_NAME}_NF_${VERSION}|${FONT_NAME}35Console_NF|${FONT_NAME}35ConsoleNF"
    "${FONT_NAME}_HS_${VERSION}|${FONT_NAME}_HS|${FONT_NAME}HS"
    "${FONT_NAME}_HS_${VERSION}|${FONT_NAME}35_HS|${FONT_NAME}35HS"
    "${FONT_NAME}_HS_${VERSION}|${FONT_NAME}Console_HS|${FONT_NAME}ConsoleHS"
    "${FONT_NAME}_HS_${VERSION}|${FONT_NAME}35Console_HS|${FONT_NAME}35ConsoleHS"
    "${FONT_NAME}_${VERSION}|${FONT_NAME}|${FONT_NAME}"
    "${FONT_NAME}_${VERSION}|${FONT_NAME}35|${FONT_NAME}35"
    "${FONT_NAME}_${VERSION}|${FONT_NAME}Console|${FONT_NAME}Console"
    "${FONT_NAME}_${VERSION}|${FONT_NAME}35Console|${FONT_NAME}35Console"
)

shopt -s nullglob

ttf_files=("${BUILD_DIR}"/"${FONT_NAME}"*-*.ttf)
if [ ${#ttf_files[@]} -eq 0 ]; then
    echo "ERROR: ${BUILD_DIR}/ に ${FONT_NAME}*-*.ttf が見つかりません。先に make.sh でビルドしてください" >&2
    exit 1
fi

release_dir="${BUILD_DIR}/release"
rm -rf "$release_dir"
mkdir -p "$release_dir"

# NF → HS → 通常 の順（広い glob が先行バリアントを巻き込まないようにする）
move_groups=(
    "${FONT_NAME}*NF*-*.ttf|${FONT_NAME}_NF_${VERSION}|NF"
    "${FONT_NAME}*HS*-*.ttf|${FONT_NAME}_HS_${VERSION}|HS"
    "${FONT_NAME}*-*.ttf|${FONT_NAME}_${VERSION}|"
)

# ファミリー振り分けも具体的なパターンから順に処理する
family_patterns=(
    "*35Console*.ttf|${FONT_NAME}35Console"
    "*Console*.ttf|${FONT_NAME}Console"
    "*35*.ttf|${FONT_NAME}35"
    "*.ttf|${FONT_NAME}"
)

echo "### Release packaging ###"
echo "VERSION=${VERSION}  FONT_NAME=${FONT_NAME}"
echo "output: ${release_dir}"

for group in "${move_groups[@]}"; do
    IFS='|' read -r pattern folder_name variant_tag <<<"$group"

    src_files=("${BUILD_DIR}"/${pattern})
    if [ ${#src_files[@]} -eq 0 ]; then
        echo "ERROR: 必須グループのファイルがありません: ${pattern}" >&2
        exit 1
    fi

    folder_path="${release_dir}/${folder_name}"
    mkdir -p "$folder_path"
    mv "${src_files[@]}" "$folder_path"/
    echo "moved ${#src_files[@]} files -> ${folder_name}/"

    if [ -n "$variant_tag" ]; then
        variant="_${variant_tag}"
    else
        variant=""
    fi

    for fam in "${family_patterns[@]}"; do
        IFS='|' read -r fam_pattern fam_base <<<"$fam"
        individual_folder="${folder_path}/${fam_base}${variant}"

        fam_files=("${folder_path}"/${fam_pattern})
        if [ ${#fam_files[@]} -eq 0 ]; then
            continue
        fi

        mkdir -p "$individual_folder"
        mv "${fam_files[@]}" "$individual_folder"/
        echo "  -> ${fam_base}${variant}/ (${#fam_files[@]} files)"
    done
done

echo "### Creating zip archives ###"
(
    cd "$release_dir"
    for dir in "${FONT_NAME}"_*; do
        [ -d "$dir" ] || continue
        zip_name="${dir}.zip"
        echo "zip: ${zip_name}"
        zip -r -q "$zip_name" "$dir"
    done
)

echo "### Checking release layout ###"
check_fail=0
declare -A expected_paths=()
declare -A package_dirs=()

for entry in "${expected_families[@]}"; do
    IFS='|' read -r package_dir family_dir file_prefix <<<"$entry"
    package_dirs["$package_dir"]=1
    family_path="${release_dir}/${package_dir}/${family_dir}"

    if [ ! -d "$family_path" ]; then
        echo "MISSING DIR: ${family_path}" >&2
        check_fail=1
        continue
    fi

    for style in "${styles[@]}"; do
        filename="${file_prefix}-${style}.ttf"
        rel_path="${package_dir}/${family_dir}/${filename}"
        expected_paths["$rel_path"]=1
        if [ ! -f "${family_path}/${filename}" ]; then
            echo "MISSING: ${family_path}/${filename}" >&2
            check_fail=1
        fi
    done
done

# 配布ディレクトリ内の余分な TTF がないか
while IFS= read -r -d '' path; do
    rel_path="${path#"${release_dir}/"}"
    if [ -z "${expected_paths[$rel_path]+x}" ]; then
        echo "UNEXPECTED: ${path}" >&2
        check_fail=1
    fi
done < <(find "$release_dir" -type f -name '*.ttf' -print0 | sort -z)

echo "### Checking zip contents ###"
for package_dir in "${!package_dirs[@]}"; do
    zip_path="${release_dir}/${package_dir}.zip"
    dir_path="${release_dir}/${package_dir}"

    if [ ! -f "$zip_path" ]; then
        echo "MISSING ZIP: ${zip_path}" >&2
        check_fail=1
        continue
    fi
    if [ ! -d "$dir_path" ]; then
        echo "MISSING DIR: ${dir_path}" >&2
        check_fail=1
        continue
    fi

    zip_tmp="$(mktemp)"
    dir_tmp="$(mktemp)"
    unzip -Z1 "$zip_path" | grep '\.ttf$' | sed 's#/$##' | sort >"$zip_tmp"
    (
        cd "$release_dir"
        find "$package_dir" -type f -name '*.ttf' | sort
    ) >"$dir_tmp"

    if ! cmp -s "$zip_tmp" "$dir_tmp"; then
        echo "ERROR: ${package_dir}.zip の内容とディレクトリ一覧が一致しません" >&2
        diff -u "$dir_tmp" "$zip_tmp" >&2 || true
        check_fail=1
    fi
    rm -f "$zip_tmp" "$dir_tmp"
done

if (( check_fail != 0 )); then
    echo "ERROR: 配布一覧と出力ファイルの整合性チェックに失敗しました" >&2
    exit 1
fi

echo "### Done ###"
echo "release directory: ${release_dir}"
ls -1 "${release_dir}"/*.zip 2>/dev/null || true
