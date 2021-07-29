#!/bin/sh

# PlemolJP Generator
plemoljp_version="0.0.4"

base_dir=$(cd $(dirname $0); pwd)

# オプション解析
HIDDEN_SPACE_FLG='false'
while getopts h OPT
do
  case $OPT in
    'h' ) HIDDEN_SPACE_FLG='true';;
  esac
done

if [ "$HIDDEN_SPACE_FLG" = 'true' ]; then
  echo '### Generate Hidden Space Version ###'
fi

# Set familyname
hs_suffix=''
if [ "$HIDDEN_SPACE_FLG" = 'true' ]; then
  hs_suffix='HS'
fi
plemoljp_familyname="PlemolJP"
plemoljp_familyname_suffix="${hs_suffix}"
plemoljp35_familyname=${plemoljp_familyname}"35"
plemoljp35_familyname_suffix="${hs_suffix}"
plemoljp_console_suffix="Console"

# Set ascent and descent (line width parameters)
plemoljp_ascent=950
plemoljp_descent=225
plemoljp35_ascent=1025
plemoljp35_descent=275

em_ascent=880
em_descent=120
em=$(($em_ascent + $em_descent))

typo_line_gap=80

plexmono_width=600
plexjp_width=1000

plemoljp_half_width=528
plemoljp_full_width=$((${plemoljp_half_width} * 2))
plexmono_shrink_x=88
plexmono_shrink_y=93

plemoljp35_half_width=600
plemoljp35_full_width=$((${plemoljp35_half_width} * 5 / 3))

italic_angle=-9

# Set path to fontforge command
fontforge_command="fontforge"
ttfautohint_command="ttfautohint"

# Set redirection of stderr
redirection_stderr="${base_dir}/error.log"

# Set fonts directories used in auto flag
fonts_directories="${base_dir}/source/ ${base_dir}/source/IBM-Plex-Mono/ ${base_dir}/source/IBM-Plex-Sans-JP/unhinted/"

# Set flags
leaving_tmp_flag="false"

# Set filenames
plexmono_thin_src="IBMPlexMono-Thin.ttf"
plexmono_extralight_src="IBMPlexMono-ExtraLight.ttf"
plexmono_light_src="IBMPlexMono-Light.ttf"
plexmono_regular_src="IBMPlexMono-Regular.ttf"
plexmono_text_src="IBMPlexMono-Text.ttf"
plexmono_medium_src="IBMPlexMono-Medium.ttf"
plexmono_semibold_src="IBMPlexMono-SemiBold.ttf"
plexmono_bold_src="IBMPlexMono-Bold.ttf"
plexmono_thin_italic_src="IBMPlexMono-ThinItalic.ttf"
plexmono_extralight_italic_src="IBMPlexMono-ExtraLightItalic.ttf"
plexmono_light_italic_src="IBMPlexMono-LightItalic.ttf"
plexmono_regular_italic_src="IBMPlexMono-Italic.ttf"
plexmono_text_italic_src="IBMPlexMono-TextItalic.ttf"
plexmono_medium_italic_src="IBMPlexMono-MediumItalic.ttf"
plexmono_semibold_italic_src="IBMPlexMono-SemiBoldItalic.ttf"
plexmono_bold_italic_src="IBMPlexMono-BoldItalic.ttf"

plexjp_thin_src="IBMPlexSansJP-Thin.ttf"
plexjp_extralight_src="IBMPlexSansJP-ExtraLight.ttf"
plexjp_light_src="IBMPlexSansJP-Light.ttf"
plexjp_regular_src="IBMPlexSansJP-Regular.ttf"
plexjp_text_src="IBMPlexSansJP-Text.ttf"
plexjp_medium_src="IBMPlexSansJP-Medium.ttf"
plexjp_semibold_src="IBMPlexSansJP-SemiBold.ttf"
plexjp_bold_src="IBMPlexSansJP-Bold.ttf"
plexjp_thin_italic_src="IBMPlexSansJP-ThinItalic.ttf"
plexjp_extralight_italic_src="IBMPlexSansJP-ExtraLightItalic.ttf"
plexjp_light_italic_src="IBMPlexSansJP-LightItalic.ttf"
plexjp_regular_italic_src="IBMPlexSansJP-Italic.ttf"
plexjp_text_italic_src="IBMPlexSansJP-TextItalic.ttf"
plexjp_medium_italic_src="IBMPlexSansJP-MediumItalic.ttf"
plexjp_semibold_italic_src="IBMPlexSansJP-SemiBoldItalic.ttf"
plexjp_bold_italic_src="IBMPlexSansJP-BoldItalic.ttf"

modified_plexmono_material_generator="modified_plexmono_material_generator.pe"
modified_plexmono_material_thin="Modified-IBMPlexMono-Material-thin.sfd"
modified_plexmono_material_extralight="Modified-IBMPlexMono-Material-extralight.sfd"
modified_plexmono_material_light="Modified-IBMPlexMono-Material-light.sfd"
modified_plexmono_material_regular="Modified-IBMPlexMono-Material-Regular.sfd"
modified_plexmono_material_text="Modified-IBMPlexMono-Material-text.sfd"
modified_plexmono_material_medium="Modified-IBMPlexMono-Material-medium.sfd"
modified_plexmono_material_semibold="Modified-IBMPlexMono-Material-semiBold.sfd"
modified_plexmono_material_bold="Modified-IBMPlexMono-Material-Bold.sfd"
modified_plexmono_material_thin_italic="Modified-IBMPlexMono-Material-thin_italic.sfd"
modified_plexmono_material_extralight_italic="Modified-IBMPlexMono-Material-extralight_italic.sfd"
modified_plexmono_material_light_italic="Modified-IBMPlexMono-Material-light_italic.sfd"
modified_plexmono_material_regular_italic="Modified-IBMPlexMono-Material-Regular_italic.sfd"
modified_plexmono_material_text_italic="Modified-IBMPlexMono-Material-text_italic.sfd"
modified_plexmono_material_medium_italic="Modified-IBMPlexMono-Material-medium_italic.sfd"
modified_plexmono_material_semibold_italic="Modified-IBMPlexMono-Material-semiBold_italic.sfd"
modified_plexmono_material_bold_italic="Modified-IBMPlexMono-Material-Bold_italic.sfd"

modified_plexmono_console_generator="modified_plexmono_console_generator.pe"
modified_plexmono_console_thin="Modified-IBMPlexMono-Console-thin.sfd"
modified_plexmono_console_extralight="Modified-IBMPlexMono-Console-extralight.sfd"
modified_plexmono_console_light="Modified-IBMPlexMono-Console-light.sfd"
modified_plexmono_console_regular="Modified-IBMPlexMono-Console-Regular.sfd"
modified_plexmono_console_text="Modified-IBMPlexMono-Console-text.sfd"
modified_plexmono_console_medium="Modified-IBMPlexMono-Console-medium.sfd"
modified_plexmono_console_semibold="Modified-IBMPlexMono-Console-semiBold.sfd"
modified_plexmono_console_bold="Modified-IBMPlexMono-Console-Bold.sfd"
modified_plexmono_console_thin_italic="Modified-IBMPlexMono-Console-thin_italic.sfd"
modified_plexmono_console_extralight_italic="Modified-IBMPlexMono-Console-extralight_italic.sfd"
modified_plexmono_console_light_italic="Modified-IBMPlexMono-Console-light_italic.sfd"
modified_plexmono_console_regular_italic="Modified-IBMPlexMono-Console-Regular_italic.sfd"
modified_plexmono_console_text_italic="Modified-IBMPlexMono-Console-text_italic.sfd"
modified_plexmono_console_medium_italic="Modified-IBMPlexMono-Console-medium_italic.sfd"
modified_plexmono_console_semibold_italic="Modified-IBMPlexMono-Console-semiBold_italic.sfd"
modified_plexmono_console_bold_italic="Modified-IBMPlexMono-Console-Bold_italic.sfd"

modified_plexmono35_console_generator="modified_plexmono35_console_generator.pe"
modified_plexmono35_console_thin="Modified-IBMPlexMono35-Console-thin.sfd"
modified_plexmono35_console_extralight="Modified-IBMPlexMono35-Console-extralight.sfd"
modified_plexmono35_console_light="Modified-IBMPlexMono35-Console-light.sfd"
modified_plexmono35_console_regular="Modified-IBMPlexMono35-Console-Regular.sfd"
modified_plexmono35_console_text="Modified-IBMPlexMono35-Console-text.sfd"
modified_plexmono35_console_medium="Modified-IBMPlexMono35-Console-medium.sfd"
modified_plexmono35_console_semibold="Modified-IBMPlexMono35-Console-semiBold.sfd"
modified_plexmono35_console_bold="Modified-IBMPlexMono35-Console-Bold.sfd"
modified_plexmono35_console_thin_italic="Modified-IBMPlexMono35-Console-thin_italic.sfd"
modified_plexmono35_console_extralight_italic="Modified-IBMPlexMono35-Console-extralight_italic.sfd"
modified_plexmono35_console_light_italic="Modified-IBMPlexMono35-Console-light_italic.sfd"
modified_plexmono35_console_regular_italic="Modified-IBMPlexMono35-Console-Regular_italic.sfd"
modified_plexmono35_console_text_italic="Modified-IBMPlexMono35-Console-text_italic.sfd"
modified_plexmono35_console_medium_italic="Modified-IBMPlexMono35-Console-medium_italic.sfd"
modified_plexmono35_console_semibold_italic="Modified-IBMPlexMono35-Console-semiBold_italic.sfd"
modified_plexmono35_console_bold_italic="Modified-IBMPlexMono35-Console-Bold_italic.sfd"

modified_plexmono_generator="modified_plexmono_generator.pe"
modified_plexmono_thin="Modified-IBMPlexMono-thin.sfd"
modified_plexmono_extralight="Modified-IBMPlexMono-extralight.sfd"
modified_plexmono_light="Modified-IBMPlexMono-light.sfd"
modified_plexmono_regular="Modified-IBMPlexMono-Regular.sfd"
modified_plexmono_text="Modified-IBMPlexMono-text.sfd"
modified_plexmono_medium="Modified-IBMPlexMono-medium.sfd"
modified_plexmono_semibold="Modified-IBMPlexMono-semiBold.sfd"
modified_plexmono_bold="Modified-IBMPlexMono-Bold.sfd"
modified_plexmono_thin_italic="Modified-IBMPlexMono-thin_italic.sfd"
modified_plexmono_extralight_italic="Modified-IBMPlexMono-extralight_italic.sfd"
modified_plexmono_light_italic="Modified-IBMPlexMono-light_italic.sfd"
modified_plexmono_regular_italic="Modified-IBMPlexMono-Regular_italic.sfd"
modified_plexmono_text_italic="Modified-IBMPlexMono-text_italic.sfd"
modified_plexmono_medium_italic="Modified-IBMPlexMono-medium_italic.sfd"
modified_plexmono_semibold_italic="Modified-IBMPlexMono-semiBold_italic.sfd"
modified_plexmono_bold_italic="Modified-IBMPlexMono-Bold_italic.sfd"

modified_plexmono35_generator="modified_plexmono35_generator.pe"
modified_plexmono35_thin="Modified-IBMPlexMono35-thin.sfd"
modified_plexmono35_extralight="Modified-IBMPlexMono35-extralight.sfd"
modified_plexmono35_light="Modified-IBMPlexMono35-light.sfd"
modified_plexmono35_regular="Modified-IBMPlexMono35-Regular.sfd"
modified_plexmono35_text="Modified-IBMPlexMono35-text.sfd"
modified_plexmono35_medium="Modified-IBMPlexMono35-medium.sfd"
modified_plexmono35_semibold="Modified-IBMPlexMono35-semiBold.sfd"
modified_plexmono35_bold="Modified-IBMPlexMono35-Bold.sfd"
modified_plexmono35_thin_italic="Modified-IBMPlexMono35-thin_italic.sfd"
modified_plexmono35_extralight_italic="Modified-IBMPlexMono35-extralight_italic.sfd"
modified_plexmono35_light_italic="Modified-IBMPlexMono35-light_italic.sfd"
modified_plexmono35_regular_italic="Modified-IBMPlexMono35-Regular_italic.sfd"
modified_plexmono35_text_italic="Modified-IBMPlexMono35-text_italic.sfd"
modified_plexmono35_medium_italic="Modified-IBMPlexMono35-medium_italic.sfd"
modified_plexmono35_semibold_italic="Modified-IBMPlexMono35-semiBold_italic.sfd"
modified_plexmono35_bold_italic="Modified-IBMPlexMono35-Bold_italic.sfd"

modified_plexjp_generator="modified_plexjp_generator.pe"
modified_plexjp_thin="Modified-IBMPlexSansJP-thin.sfd"
modified_plexjp_extralight="Modified-IBMPlexSansJP-extralight.sfd"
modified_plexjp_light="Modified-IBMPlexSansJP-light.sfd"
modified_plexjp_regular="Modified-IBMPlexSansJP-regular.sfd"
modified_plexjp_text="Modified-IBMPlexSansJP-text.sfd"
modified_plexjp_medium="Modified-IBMPlexSansJP-medium.sfd"
modified_plexjp_semibold="Modified-IBMPlexSansJP-semibold.sfd"
modified_plexjp_bold="Modified-IBMPlexSansJP-bold.sfd"
modified_plexjp_thin_italic="Modified-IBMPlexSansJP-thin_italic.sfd"
modified_plexjp_extralight_italic="Modified-IBMPlexSansJP-extralight_italic.sfd"
modified_plexjp_light_italic="Modified-IBMPlexSansJP-light_italic.sfd"
modified_plexjp_regular_italic="Modified-IBMPlexSansJP-regular_italic.sfd"
modified_plexjp_text_italic="Modified-IBMPlexSansJP-text_italic.sfd"
modified_plexjp_medium_italic="Modified-IBMPlexSansJP-medium_italic.sfd"
modified_plexjp_semibold_italic="Modified-IBMPlexSansJP-semibold_italic.sfd"
modified_plexjp_bold_italic="Modified-IBMPlexSansJP-bold_italic.sfd"

modified_plexjp35_generator="modified_plexjp35_generator.pe"
modified_plexjp35_thin="Modified-IBMPlexSansJP35-thin.sfd"
modified_plexjp35_extralight="Modified-IBMPlexSansJP35-extralight.sfd"
modified_plexjp35_light="Modified-IBMPlexSansJP35-light.sfd"
modified_plexjp35_regular="Modified-IBMPlexSansJP35-Monospace-regular.sfd"
modified_plexjp35_text="Modified-IBMPlexSansJP35-Monospace-text.sfd"
modified_plexjp35_medium="Modified-IBMPlexSansJP35-medium.sfd"
modified_plexjp35_semibold="Modified-IBMPlexSansJP35-semibold.sfd"
modified_plexjp35_bold="Modified-IBMPlexSansJP35-Monospace-bold.sfd"
modified_plexjp35_thin_italic="Modified-IBMPlexSansJP35-thin_italic.sfd"
modified_plexjp35_extralight_italic="Modified-IBMPlexSansJP35-extralight_italic.sfd"
modified_plexjp35_light_italic="Modified-IBMPlexSansJP35-light_italic.sfd"
modified_plexjp35_regular_italic="Modified-IBMPlexSansJP35-Monospace-regular_italic.sfd"
modified_plexjp35_text_italic="Modified-IBMPlexSansJP35-Monospace-text_italic.sfd"
modified_plexjp35_medium_italic="Modified-IBMPlexSansJP35-medium_italic.sfd"
modified_plexjp35_semibold_italic="Modified-IBMPlexSansJP35-semibold_italic.sfd"
modified_plexjp35_bold_italic="Modified-IBMPlexSansJP35-Monospace-bold_italic.sfd"

modified_plexjp_console_generator="modified_plexjp_console_generator.pe"
modified_plexjp_console_thin="Modified-IBMPlexSansJP-thin_console.sfd"
modified_plexjp_console_extralight="Modified-IBMPlexSansJP-extralight_console.sfd"
modified_plexjp_console_light="Modified-IBMPlexSansJP-light_console.sfd"
modified_plexjp_console_regular="Modified-IBMPlexSansJP-regular_console.sfd"
modified_plexjp_console_text="Modified-IBMPlexSansJP-text_console.sfd"
modified_plexjp_console_medium="Modified-IBMPlexSansJP-medium_console.sfd"
modified_plexjp_console_semibold="Modified-IBMPlexSansJP-semibold_console.sfd"
modified_plexjp_console_bold="Modified-IBMPlexSansJP-bold_console.sfd"
modified_plexjp_console_thin_italic="Modified-IBMPlexSansJP-thin_console_italic.sfd"
modified_plexjp_console_extralight_italic="Modified-IBMPlexSansJP-extralight_console_italic.sfd"
modified_plexjp_console_light_italic="Modified-IBMPlexSansJP-light_console_italic.sfd"
modified_plexjp_console_regular_italic="Modified-IBMPlexSansJP-regular_console_italic.sfd"
modified_plexjp_console_text_italic="Modified-IBMPlexSansJP-text_console_italic.sfd"
modified_plexjp_console_medium_italic="Modified-IBMPlexSansJP-medium_console_italic.sfd"
modified_plexjp_console_semibold_italic="Modified-IBMPlexSansJP-semibold_console_italic.sfd"
modified_plexjp_console_bold_italic="Modified-IBMPlexSansJP-bold_console_italic.sfd"

modified_plexjp35_console_generator="modified_plexjp35_console_generator.pe"
modified_plexjp35_console_thin="Modified-IBMPlexSansJP-thin_console.sfd"
modified_plexjp35_console_extralight="Modified-IBMPlexSansJP-extralight_console.sfd"
modified_plexjp35_console_light="Modified-IBMPlexSansJP-light_console.sfd"
modified_plexjp35_console_regular="Modified-IBMPlexSansJP35-Monospace-regular_console.sfd"
modified_plexjp35_console_text="Modified-IBMPlexSansJP35-Monospace-text_console.sfd"
modified_plexjp35_console_medium="Modified-IBMPlexSansJP35-medium_console.sfd"
modified_plexjp35_console_semibold="Modified-IBMPlexSansJP35-semibold_console.sfd"
modified_plexjp35_console_bold="Modified-IBMPlexSansJP35-Monospace-bold_console.sfd"
modified_plexjp35_console_thin_italic="Modified-IBMPlexSansJP-thin_console_italic.sfd"
modified_plexjp35_console_extralight_italic="Modified-IBMPlexSansJP-extralight_console_italic.sfd"
modified_plexjp35_console_light_italic="Modified-IBMPlexSansJP-light_console_italic.sfd"
modified_plexjp35_console_regular_italic="Modified-IBMPlexSansJP35-Monospace-regular_console_italic.sfd"
modified_plexjp35_console_text_italic="Modified-IBMPlexSansJP35-Monospace-text_console_italic.sfd"
modified_plexjp35_console_medium_italic="Modified-IBMPlexSansJP35-medium_console_italic.sfd"
modified_plexjp35_console_semibold_italic="Modified-IBMPlexSansJP35-semibold_console_italic.sfd"
modified_plexjp35_console_bold_italic="Modified-IBMPlexSansJP35-Monospace-bold_console_italic.sfd"

plemoljp_generator="plemoljp_generator.pe"
plemoljp_console_generator="plemoljp_console_generator.pe"

plemoljp35_generator="plemoljp35_generator.pe"
plemoljp35_console_generator="plemoljp35_console_generator.pe"

# Get input fonts
tmp=""
for i in $fonts_directories
do
    [ -d "${i}" ] && tmp="${tmp} ${i}"
done
fonts_directories="${tmp}"
# Search IBMPlexMono
input_plexmono_thin=`find $fonts_directories -follow -name "$plexmono_thin_src" | head -n 1`
input_plexmono_extralight=`find $fonts_directories -follow -name "$plexmono_extralight_src" | head -n 1`
input_plexmono_light=`find $fonts_directories -follow -name "$plexmono_light_src" | head -n 1`
input_plexmono_regular=`find $fonts_directories -follow -name "$plexmono_regular_src" | head -n 1`
input_plexmono_text=`find $fonts_directories -follow -name "$plexmono_text_src" | head -n 1`
input_plexmono_medium=`find $fonts_directories -follow -name "$plexmono_medium_src" | head -n 1`
input_plexmono_semibold=`find $fonts_directories -follow -name "$plexmono_semibold_src" | head -n 1`
input_plexmono_bold=`find $fonts_directories -follow -name "$plexmono_bold_src" | head -n 1`
input_plexmono_thin_italic=`find $fonts_directories -follow -name "$plexmono_thin_italic_src" | head -n 1`
input_plexmono_extralight_italic=`find $fonts_directories -follow -name "$plexmono_extralight_italic_src" | head -n 1`
input_plexmono_light_italic=`find $fonts_directories -follow -name "$plexmono_light_italic_src" | head -n 1`
input_plexmono_regular_italic=`find $fonts_directories -follow -name "$plexmono_regular_italic_src" | head -n 1`
input_plexmono_text_italic=`find $fonts_directories -follow -name "$plexmono_text_italic_src" | head -n 1`
input_plexmono_medium_italic=`find $fonts_directories -follow -name "$plexmono_medium_italic_src" | head -n 1`
input_plexmono_semibold_italic=`find $fonts_directories -follow -name "$plexmono_semibold_italic_src" | head -n 1`
input_plexmono_bold_italic=`find $fonts_directories -follow -name "$plexmono_bold_italic_src" | head -n 1`

if [ -z "${input_plexmono_regular}" -o -z "${input_plexmono_bold}" ]
then
  echo "Error: $plexmono_regular_src and/or $plexmono_bold_src not found" >&2
  exit 1
fi

# Search IBMPlexSansJP
input_plexjp_thin=`find $fonts_directories -follow -iname "$plexjp_thin_src" | head -n 1`
input_plexjp_extralight=`find $fonts_directories -follow -iname "$plexjp_extralight_src" | head -n 1`
input_plexjp_light=`find $fonts_directories -follow -iname "$plexjp_light_src" | head -n 1`
input_plexjp_regular=`find $fonts_directories -follow -iname "$plexjp_regular_src" | head -n 1`
input_plexjp_text=`find $fonts_directories -follow -iname "$plexjp_text_src"    | head -n 1`
input_plexjp_medium=`find $fonts_directories -follow -iname "$plexjp_medium_src"    | head -n 1`
input_plexjp_semibold=`find $fonts_directories -follow -iname "$plexjp_semibold_src"    | head -n 1`
input_plexjp_bold=`find $fonts_directories -follow -iname "$plexjp_bold_src"    | head -n 1`
if [ -z "${input_plexjp_regular}" -o -z "${input_plexjp_bold}" ]
then
  echo "Error: $plexjp_regular_src and/or $plexjp_bold_src not found" >&2
  exit 1
fi

# Check filename
[ "$(basename $input_plexmono_regular)" != "$plexmono_regular_src" ] &&
  echo "Warning: ${input_plexmono_regular} does not seem to be IBMPlexMono Regular" >&2
[ "$(basename $input_plexmono_bold)" != "$plexmono_bold_src" ] &&
  echo "Warning: ${input_plexmono_regular} does not seem to be IBMPlexMono Bold" >&2
[ "$(basename $input_plexjp_regular)" != "$plexjp_regular_src" ] &&
  echo "Warning: ${input_plexjp_regular} does not seem to be IBMPlexSansJP Regular" >&2
[ "$(basename $input_plexjp_bold)" != "$plexjp_bold_src" ] &&
  echo "Warning: ${input_plexjp_bold} does not seem to be IBMPlexSansJP Bold" >&2

# Check fontforge existance
if ! which $fontforge_command > /dev/null 2>&1
then
  echo "Error: ${fontforge_command} command not found" >&2
  exit 1
fi

# Make temporary directory
if [ -w "/tmp" -a "${leaving_tmp_flag}" = "false" ]
then
  tmpdir=`mktemp -d /tmp/plemoljp_generator_tmpdir.XXXXXX` || exit 2
else
  tmpdir=`mktemp -d ./plemoljp_generator_tmpdir.XXXXXX`    || exit 2
fi

# Remove temporary directory by trapping
if [ "${leaving_tmp_flag}" = "false" ]
then
  trap "if [ -d \"$tmpdir\" ]; then echo 'Remove temporary files'; rm -rf $tmpdir; echo 'Abnormally terminated'; fi; exit 3" HUP INT QUIT
  trap "if [ -d \"$tmpdir\" ]; then echo 'Remove temporary files'; rm -rf $tmpdir; echo 'Abnormally terminated'; fi" EXIT
else
  trap "echo 'Abnormally terminated'; exit 3" HUP INT QUIT
fi

# console 版と通常版の IBMPlexMono から合成するグリフ差分
select_glyph_is_not_console="

  # 記号
  SelectMore(0u00a1, 0u00a5)
  SelectMore(0u00a7, 0u0522)
  SelectMore(0u0e3f)
  SelectMore(0u2010, 0u2021)
  SelectMore(0u2024, 0u2026)
  SelectMore(0u202f, 0u204b)
  SelectMore(0u2070, 0u208e)
  SelectMore(0u20a0, 0u20b9)
  SelectMore(0u2116, 0u215f)
  SelectMore(0u2200, 0u2215)
  SelectMore(0u221a, 0u222d)

  # 矢印
  SelectMore(0u2190, 0u2199)
  SelectMore(0u21a8)
  SelectMore(0u21b0, 0u21b5)
  SelectMore(0u21b8, 0u21b9)
  SelectMore(0u21c4, 0u21cc)
  SelectMore(0u21d0, 0u21d9)
  SelectMore(0u21e4, 0u21ed)
  SelectMore(0u21f5)
  SelectMore(0u27a1)
  SelectMore(0u2b05, 0u2b07)

  # 数学記号
  SelectMore(0u2234, 0u2237)
  SelectMore(0u223c, 0u223d)
  SelectMore(0u2242, 0u2243)
  SelectMore(0u2245)
  SelectMore(0u2248)
  SelectMore(0u224c)
  SelectMore(0u2250, 0u2253)
  SelectMore(0u2260)
  SelectMore(0u2260, 0u2262)
  SelectMore(0u2264, 0u2267)
  SelectMore(0u226a, 0u226b)
  SelectMore(0u226e, 0u226f)
  SelectMore(0u2272, 0u2273)
  SelectMore(0u2276, 0u2277)
  SelectMore(0u2282, 0u228b)
  SelectMore(0u2295, 0u2299)
  SelectMore(0u229d)
  SelectMore(0u22a0)
  SelectMore(0u22a2, 0u22a5)
  SelectMore(0u22bb, 0u22bd)
  SelectMore(0u22bf, 0u22c3)
  SelectMore(0u22c5)
  SelectMore(0u22da, 0u22db)
  SelectMore(0u22ee, 0u22ef)

  # 罫線、図形
  SelectMore(0u2500, 0u25af)
  SelectMore(0u25b1, 0u25b3)
  SelectMore(0u25b6, 0u25b7)
  SelectMore(0u25ba, 0u25bd)
  SelectMore(0u25c0, 0u25c1)
  SelectMore(0u25c4, 0u25cc)
  SelectMore(0u25ce, 0u25d3)
  SelectMore(0u25d8, 0u25d9)
  SelectMore(0u25e2, 0u25e5)
  SelectMore(0u25af)
  SelectMore(0u25e6)
  SelectMore(0u25ef)
  SelectMore(0u266a)
  SelectMore(0u2756)
  SelectMore(0u29fa, 0u29fb)
  SelectMore(0u2A2F)
  SelectMore(0u2b1a)

  # 一部 IBMPlexMono ベースにする
  ## 各エディタの可視化文字対策
  SelectFewer(0u2022)
  SelectFewer(0u00b7)
  SelectFewer(0u2024)
  SelectFewer(0u2219)
  SelectFewer(0u25d8)
  SelectFewer(0u25e6)
  ## IBM Plex Sans JP 等幅化対策 (IBM Plex Mono を適用して半角化)
  SelectFewer(171)
  SelectFewer(187)
"

# IBM Plex Sans JP 等幅化対策 (全角左寄せの除外)
set_full_left_fewer="
  SelectFewer(8217)
  SelectFewer(8218)
  SelectFewer(8221)
  SelectFewer(8222)
"

# IBM Plex Sans JP 等幅化対策 (Widthを全角にしてからセンタリング)
set_width_full_and_center="
  SelectNone()
  SelectMore(204)
  SelectMore(205)
  SelectMore(206)
  SelectMore(207)
  SelectMore(231)
  SelectMore(236)
  SelectMore(237)
  SelectMore(238)
  SelectMore(239)
  SelectMore(253)
  SelectMore(255)
  SelectMore(305)
  SelectMore(322)
  SelectMore(353)
  SelectMore(382)
  SelectMore(402)
  SelectMore(773)
  SelectMore(8209)
  SelectMore(8254)
"

# IBM Plex Sans JP 等幅化対策 (半角左寄せ対象をセンタリングから除外する)
set_half_left_fewer="
  SelectFewer(65377)
  SelectFewer(65379)
  SelectFewer(65380)
  SelectFewer(65438)
  SelectFewer(65439)
  SelectFewer(1114333)
  SelectFewer(1114335)
  SelectFewer(1114337)
  SelectFewer(1114339)
  SelectFewer(1114341)
"

# IBM Plex Sans JP 等幅化対策 (半角右寄せ対象をセンタリングから除外する)
set_half_right_fewer="
  SelectFewer(65378)
  SelectFewer(1114332)
  SelectFewer(1114334)
  SelectFewer(1114336)
  SelectFewer(1114338)
  SelectFewer(1114340)
"

# IBM Plex Sans JP 等幅化対策 (全角化しつつ右寄せをセンタリングから除外する)
set_half_to_full_right_fewer="
  SelectFewer(8216)
  SelectFewer(8220)
"

########################################
# Generate script for modified IBMPlexMono Material
########################################

cat > ${tmpdir}/${modified_plexmono_material_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified IBMPlexMono Material")

# Set parameters
input_list  = [ \\
                "${input_plexmono_thin}", \\
                "${input_plexmono_extralight}", \\
                "${input_plexmono_light}", \\
                "${input_plexmono_regular}", \\
                "${input_plexmono_text}", \\
                "${input_plexmono_medium}", \\
                "${input_plexmono_semibold}", \\
                "${input_plexmono_bold}", \\
                "${input_plexmono_thin_italic}", \\
                "${input_plexmono_extralight_italic}", \\
                "${input_plexmono_light_italic}", \\
                "${input_plexmono_regular_italic}", \\
                "${input_plexmono_text_italic}", \\
                "${input_plexmono_medium_italic}", \\
                "${input_plexmono_semibold_italic}", \\
                "${input_plexmono_bold_italic}" \\
              ]
output_list = [ \\
                "${modified_plexmono_material_thin}", \\
                "${modified_plexmono_material_extralight}", \\
                "${modified_plexmono_material_light}", \\
                "${modified_plexmono_material_regular}", \\
                "${modified_plexmono_material_text}", \\
                "${modified_plexmono_material_medium}", \\
                "${modified_plexmono_material_semibold}", \\
                "${modified_plexmono_material_bold}", \\
                "${modified_plexmono_material_thin_italic}", \\
                "${modified_plexmono_material_extralight_italic}", \\
                "${modified_plexmono_material_light_italic}", \\
                "${modified_plexmono_material_regular_italic}", \\
                "${modified_plexmono_material_text_italic}", \\
                "${modified_plexmono_material_medium_italic}", \\
                "${modified_plexmono_material_semibold_italic}", \\
                "${modified_plexmono_material_bold_italic}" \\
              ]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open IBMPlexMono
  Print("Open " + input_list[i])
  Open(input_list[i])

  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${em_ascent}, ${em_descent})

  # クォーテーションの拡大
  Select(0u0022)
  SelectMore(0u0027)
  SelectMore(0u0060)
  Scale(109, 106)

  # ; : , . の拡大
#  Select(0u003a)
#  SelectMore(0u003b)
#  SelectMore(0u002c)
#  SelectMore(0u002e)
#  Scale(108)
  ## 拡大後の位置合わせ
#  Select(0u003b); Move(0, 18) # ;
#  Select(0u002e); Move(0, 5)  # .
#  Select(0u002c); Move(0, -8) # ,

  # Eclipse Pleiades 半角スペース記号 (U+1d1c) 対策
  Select(0u054d); Copy()
  Select(0u1d1c); Paste()
  Scale(85, 60)

  # 結合分音記号は全て源柔ゴシックをベースにするため削除する
#  Select(0u0300, 0u036f); Clear()

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified IBMPlexMono
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified IBMPlexMono console
########################################

cat > ${tmpdir}/${modified_plexmono_console_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified IBMPlexMono Console")

# Set parameters
input_list  = [ \\
                "${tmpdir}/${modified_plexmono_material_thin}", \\
                "${tmpdir}/${modified_plexmono_material_extralight}", \\
                "${tmpdir}/${modified_plexmono_material_light}", \\
                "${tmpdir}/${modified_plexmono_material_regular}", \\
                "${tmpdir}/${modified_plexmono_material_text}", \\
                "${tmpdir}/${modified_plexmono_material_medium}", \\
                "${tmpdir}/${modified_plexmono_material_semibold}", \\
                "${tmpdir}/${modified_plexmono_material_bold}", \\
                "${tmpdir}/${modified_plexmono_material_thin_italic}", \\
                "${tmpdir}/${modified_plexmono_material_extralight_italic}", \\
                "${tmpdir}/${modified_plexmono_material_light_italic}", \\
                "${tmpdir}/${modified_plexmono_material_regular_italic}", \\
                "${tmpdir}/${modified_plexmono_material_text_italic}", \\
                "${tmpdir}/${modified_plexmono_material_medium_italic}", \\
                "${tmpdir}/${modified_plexmono_material_semibold_italic}", \\
                "${tmpdir}/${modified_plexmono_material_bold_italic}" \\
              ]
output_list = [ \\
                "${modified_plexmono_console_thin}", \\
                "${modified_plexmono_console_extralight}", \\
                "${modified_plexmono_console_light}", \\
                "${modified_plexmono_console_regular}", \\
                "${modified_plexmono_console_text}", \\
                "${modified_plexmono_console_medium}", \\
                "${modified_plexmono_console_semibold}", \\
                "${modified_plexmono_console_bold}", \\
                "${modified_plexmono_console_thin_italic}", \\
                "${modified_plexmono_console_extralight_italic}", \\
                "${modified_plexmono_console_light_italic}", \\
                "${modified_plexmono_console_regular_italic}", \\
                "${modified_plexmono_console_text_italic}", \\
                "${modified_plexmono_console_medium_italic}", \\
                "${modified_plexmono_console_semibold_italic}", \\
                "${modified_plexmono_console_bold_italic}" \\
              ]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open IBMPlexMono
  Print("Open " + input_list[i])
  Open(input_list[i])
  SelectWorthOutputting()
  UnlinkReference()

  Scale(${plexmono_shrink_x}, ${plexmono_shrink_y}, 0, 0)

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${plemoljp_half_width} - ${plexmono_width} * ${plexmono_shrink_x} / 100) / 2)) # -8
  width_pt = ${plemoljp_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified IBMPlexMono
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified IBMPlexMono35 console
########################################

cat > ${tmpdir}/${modified_plexmono35_console_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified IBMPlexMono35 Console")

# Set parameters
input_list  = [ \\
                "${tmpdir}/${modified_plexmono_material_thin}", \\
                "${tmpdir}/${modified_plexmono_material_extralight}", \\
                "${tmpdir}/${modified_plexmono_material_light}", \\
                "${tmpdir}/${modified_plexmono_material_regular}", \\
                "${tmpdir}/${modified_plexmono_material_text}", \\
                "${tmpdir}/${modified_plexmono_material_medium}", \\
                "${tmpdir}/${modified_plexmono_material_semibold}", \\
                "${tmpdir}/${modified_plexmono_material_bold}", \\
                "${tmpdir}/${modified_plexmono_material_thin_italic}", \\
                "${tmpdir}/${modified_plexmono_material_extralight_italic}", \\
                "${tmpdir}/${modified_plexmono_material_light_italic}", \\
                "${tmpdir}/${modified_plexmono_material_regular_italic}", \\
                "${tmpdir}/${modified_plexmono_material_text_italic}", \\
                "${tmpdir}/${modified_plexmono_material_medium_italic}", \\
                "${tmpdir}/${modified_plexmono_material_semibold_italic}", \\
                "${tmpdir}/${modified_plexmono_material_bold_italic}" \\
              ]
output_list = [ \\
                "${modified_plexmono35_console_thin}", \\
                "${modified_plexmono35_console_extralight}", \\
                "${modified_plexmono35_console_light}", \\
                "${modified_plexmono35_console_regular}", \\
                "${modified_plexmono35_console_text}", \\
                "${modified_plexmono35_console_medium}", \\
                "${modified_plexmono35_console_semibold}", \\
                "${modified_plexmono35_console_bold}", \\
                "${modified_plexmono35_console_thin_italic}", \\
                "${modified_plexmono35_console_extralight_italic}", \\
                "${modified_plexmono35_console_light_italic}", \\
                "${modified_plexmono35_console_regular_italic}", \\
                "${modified_plexmono35_console_text_italic}", \\
                "${modified_plexmono35_console_medium_italic}", \\
                "${modified_plexmono35_console_semibold_italic}", \\
                "${modified_plexmono35_console_bold_italic}" \\
              ]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open IBMPlexMono
  Print("Open " + input_list[i])
  Open(input_list[i])
  SelectWorthOutputting()
  UnlinkReference()

  # 幅の変更 (Move で文字幅も変わることに注意)
  move_pt = $(((${plemoljp35_half_width} - ${plexmono_width}) / 2)) # -8
  width_pt = ${plemoljp35_half_width}
  Move(move_pt, 0)
  SetWidth(width_pt, 0)

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # Save modified IBMPlexMono
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified IBMPlexMono
########################################

cat > ${tmpdir}/${modified_plexmono_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified IBMPlexMono")

# Set parameters
input_list  = [ \\
                "${tmpdir}/${modified_plexmono_console_thin}", \\
                "${tmpdir}/${modified_plexmono_console_extralight}", \\
                "${tmpdir}/${modified_plexmono_console_light}", \\
                "${tmpdir}/${modified_plexmono_console_regular}", \\
                "${tmpdir}/${modified_plexmono_console_text}", \\
                "${tmpdir}/${modified_plexmono_console_medium}", \\
                "${tmpdir}/${modified_plexmono_console_semibold}", \\
                "${tmpdir}/${modified_plexmono_console_bold}", \\
                "${tmpdir}/${modified_plexmono_console_thin_italic}", \\
                "${tmpdir}/${modified_plexmono_console_extralight_italic}", \\
                "${tmpdir}/${modified_plexmono_console_light_italic}", \\
                "${tmpdir}/${modified_plexmono_console_regular_italic}", \\
                "${tmpdir}/${modified_plexmono_console_text_italic}", \\
                "${tmpdir}/${modified_plexmono_console_medium_italic}", \\
                "${tmpdir}/${modified_plexmono_console_semibold_italic}", \\
                "${tmpdir}/${modified_plexmono_console_bold_italic}" \\
              ]
output_list = [ \\
                "${modified_plexmono_thin}", \\
                "${modified_plexmono_extralight}", \\
                "${modified_plexmono_light}", \\
                "${modified_plexmono_regular}", \\
                "${modified_plexmono_text}", \\
                "${modified_plexmono_medium}", \\
                "${modified_plexmono_semibold}", \\
                "${modified_plexmono_bold}", \\
                "${modified_plexmono_thin_italic}", \\
                "${modified_plexmono_extralight_italic}", \\
                "${modified_plexmono_light_italic}", \\
                "${modified_plexmono_regular_italic}", \\
                "${modified_plexmono_text_italic}", \\
                "${modified_plexmono_medium_italic}", \\
                "${modified_plexmono_semibold_italic}", \\
                "${modified_plexmono_bold_italic}" \\
              ]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open IBMPlexMono
  Print("Open " + input_list[i])
  Open(input_list[i])

  # Remove ambiguous glyphs
  SelectNone()
  ${select_glyph_is_not_console}
  Clear()

  # Save modified IBMPlexMono
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified IBMPlexMono35
########################################

cat > ${tmpdir}/${modified_plexmono35_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified IBMPlexMono")

# Set parameters
input_list  = [ \\
                "${tmpdir}/${modified_plexmono35_console_thin}", \\
                "${tmpdir}/${modified_plexmono35_console_extralight}", \\
                "${tmpdir}/${modified_plexmono35_console_light}", \\
                "${tmpdir}/${modified_plexmono35_console_regular}", \\
                "${tmpdir}/${modified_plexmono35_console_text}", \\
                "${tmpdir}/${modified_plexmono35_console_medium}", \\
                "${tmpdir}/${modified_plexmono35_console_semibold}", \\
                "${tmpdir}/${modified_plexmono35_console_bold}", \\
                "${tmpdir}/${modified_plexmono35_console_thin_italic}", \\
                "${tmpdir}/${modified_plexmono35_console_extralight_italic}", \\
                "${tmpdir}/${modified_plexmono35_console_light_italic}", \\
                "${tmpdir}/${modified_plexmono35_console_regular_italic}", \\
                "${tmpdir}/${modified_plexmono35_console_text_italic}", \\
                "${tmpdir}/${modified_plexmono35_console_medium_italic}", \\
                "${tmpdir}/${modified_plexmono35_console_semibold_italic}", \\
                "${tmpdir}/${modified_plexmono35_console_bold_italic}" \\
              ]
output_list = [ \\
                "${modified_plexmono35_thin}", \\
                "${modified_plexmono35_extralight}", \\
                "${modified_plexmono35_light}", \\
                "${modified_plexmono35_regular}", \\
                "${modified_plexmono35_text}", \\
                "${modified_plexmono35_medium}", \\
                "${modified_plexmono35_semibold}", \\
                "${modified_plexmono35_bold}", \\
                "${modified_plexmono35_thin_italic}", \\
                "${modified_plexmono35_extralight_italic}", \\
                "${modified_plexmono35_light_italic}", \\
                "${modified_plexmono35_regular_italic}", \\
                "${modified_plexmono35_text_italic}", \\
                "${modified_plexmono35_medium_italic}", \\
                "${modified_plexmono35_semibold_italic}", \\
                "${modified_plexmono35_bold_italic}" \\
              ]

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open IBMPlexMono
  Print("Open " + input_list[i])
  Open(input_list[i])

  # Remove ambiguous glyphs
  SelectNone()
  ${select_glyph_is_not_console}
  Clear()

  # Save modified IBMPlexMono
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified IBMPlexSansJP
########################################

cat > ${tmpdir}/${modified_plexjp_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified IBMPlexSansJP")

# Set parameters
plexmono = "${tmpdir}/${modified_plexmono_regular}"
input_list  = [ \\
                "${input_plexjp_thin}", \\
                "${input_plexjp_extralight}", \\
                "${input_plexjp_light}", \\
                "${input_plexjp_regular}", \\
                "${input_plexjp_text}", \\
                "${input_plexjp_medium}", \\
                "${input_plexjp_semibold}", \\
                "${input_plexjp_bold}", \\
                "${input_plexjp_thin}", \\
                "${input_plexjp_extralight}", \\
                "${input_plexjp_light}", \\
                "${input_plexjp_regular}", \\
                "${input_plexjp_text}", \\
                "${input_plexjp_medium}", \\
                "${input_plexjp_semibold}", \\
                "${input_plexjp_bold}" \\
              ]
output_list = [ \\
                "${modified_plexjp_thin}", \\
                "${modified_plexjp_extralight}", \\
                "${modified_plexjp_light}", \\
                "${modified_plexjp_regular}", \\
                "${modified_plexjp_text}", \\
                "${modified_plexjp_medium}", \\
                "${modified_plexjp_semibold}", \\
                "${modified_plexjp_bold}", \\
                "${modified_plexjp_thin_italic}", \\
                "${modified_plexjp_extralight_italic}", \\
                "${modified_plexjp_light_italic}", \\
                "${modified_plexjp_regular_italic}", \\
                "${modified_plexjp_text_italic}", \\
                "${modified_plexjp_medium_italic}", \\
                "${modified_plexjp_semibold_italic}", \\
                "${modified_plexjp_bold_italic}" \\
              ]

fontstyle_list    = [ \\
                      "Thin", \\
                      "ExtraLight", \\
                      "Light", \\
                      "Regular", \\
                      "Text", \\
                      "Medium", \\
                      "SemiBold", \\
                      "Bold", \\
                      "Thin Italic", \\
                      "ExtraLight Italic", \\
                      "Light Italic", \\
                      "Regular Italic", \\
                      "Text Italic", \\
                      "Medium Italic", \\
                      "SemiBold Italic", \\
                      "Bold Italic" \\
                    ]
fontweight_list   = [ \\
                      100, \\
                      200, \\
                      300, \\
                      400, \\
                      450, \\
                      500, \\
                      600, \\
                      700, \\
                      100, \\
                      200, \\
                      300, \\
                      400, \\
                      450, \\
                      500, \\
                      600, \\
                      700 \\
                    ]
panoseweight_list = [ \\
                      3, \\
                      3, \\
                      4, \\
                      5, \\
                      5, \\
                      6, \\
                      7, \\
                      8, \\
                      3, \\
                      3, \\
                      4, \\
                      5, \\
                      5, \\
                      6, \\
                      7, \\
                      8 \\
                    ]

Print("Get trim target glyph from IBMPlexMono")
Open(plexmono)
i = 0
end_plexmono = 65535
plexmono_exist_glyph_array = Array(end_plexmono)
while (i < end_plexmono)
  if (i % 5000 == 0)
    Print("Processing progress: " + i)
  endif
  if (WorthOutputting(i))
    plexmono_exist_glyph_array[i] = 1
  else
    plexmono_exist_glyph_array[i] = 0
  endif
  i++
endloop
Close()

# Begin loop
i = 0
end_plexjp = 1115564
i_halfwidth = 0
i_width1000 = 0
halfwidth_array = Array(10000)
width1000_array = Array(10000)
Print("Half width check loop start")
Open(input_list[0])
while (i < end_plexjp)
      if ( i % 10000 == 0 )
        Print("Processing progress: " + i)
      endif
      if (WorthOutputting(i) && (i > end_plexmono || plexmono_exist_glyph_array[i] == 0))
        Select(i)
        glyphWidth = GlyphInfo("Width")
        if (glyphWidth < ${plemoljp_half_width})
          halfwidth_array[i_halfwidth] = i
          i_halfwidth = i_halfwidth + 1
        elseif (glyphWidth == 1000)
          width1000_array[i_width1000] = i
          i_width1000 = i_width1000 + 1
        endif
      endif
      i = i + 1
endloop
Close()
Print("Half width check loop end")

i = 0
while (i < SizeOf(input_list))
  # Open IBMPlexSansJP
  Print("Open " + input_list[i])
  Open(input_list[i])
  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${em_ascent}, ${em_descent})

  # 斜体の生成
  if (Strstr(fontstyle_list[i], 'Italic') >= 0)
    Italic(${italic_angle})
  endif

  SelectNone()

  Print("Remove IBMPlexMono Glyphs start")
  ii = 0
  while ( ii < end_plexmono )
      if ( ii % 5000 == 0 )
        Print("Processing progress: " + ii)
      endif
      if (WorthOutputting(ii) && plexmono_exist_glyph_array[ii] == 1)
        SelectMore(ii)
      endif
      ii = ii + 1
  endloop
  Clear()
  Print("Remove IBMPlexMono Glyphs end")

  Print("Full SetWidth start")
  move_pt = $(((${plemoljp_full_width} - ${plexjp_width}) / 2)) # 26
  width_pt = ${plemoljp_full_width} # 1076

  SelectNone()
  ii=0
  while (ii < i_width1000)
      SelectMore(width1000_array[ii])
      ii = ii + 1
  endloop
  Move(move_pt, 0)
  SetWidth(width_pt)
  
  SelectWorthOutputting()
  ii=0
  while (ii < i_halfwidth)
      SelectFewer(halfwidth_array[ii])
      ii = ii + 1
  endloop
  ii=0
  while (ii < i_width1000)
      SelectFewer(width1000_array[ii])
      ii = ii + 1
  endloop
  $set_full_left_fewer
  SetWidth(width_pt)
  CenterInWidth()
  Print("Full SetWidth end")

  SelectNone()

  Print("Half SetWidth start")
  move_pt = $(((${plemoljp_half_width} - ${plexjp_width} / 2) / 2)) # 13
  width_pt = ${plemoljp_half_width} # 358
  ii=0
  while (ii < i_halfwidth)
      SelectMore(halfwidth_array[ii])
      ii = ii + 1
  endloop
  $set_half_left_fewer
  $set_half_right_fewer
  $set_half_to_full_right_fewer
  #Move(move_pt, 0)
  SetWidth(width_pt)
  CenterInWidth()
  Print("Half SetWidth end")

  $set_width_full_and_center
  SetWidth($plemoljp_full_width)
  CenterInWidth()
  # IBM Plex Sans JP 等幅化対策 (半角左寄せ)
  half_left_list = [65377, 65379, 65380, 65438, 65439, 1114333, 1114335, 1114337, 1114339, 1114341]
  ii = 0
  while (ii < SizeOf(half_left_list))
    Select(half_left_list[ii])
    SetWidth(${plexjp_width} / 2)
    move_pt = (${plemoljp_half_width} - GlyphInfo('Width')) / 2
    Move(move_pt, 0)
    SetWidth(${plemoljp_half_width})
    ii = ii + 1
  endloop
  # IBM Plex Sans JP 等幅化対策 (全角左寄せ)
  full_left_list = [8217 ,8218 ,8221 ,8222]
  ii = 0
  while (ii < SizeOf(full_left_list))
    Select(full_left_list[ii])
    SetWidth(${plexjp_width})
    move_pt = (${plemoljp_full_width} - GlyphInfo('Width')) / 2
    Move(move_pt, 0)
    SetWidth(${plemoljp_full_width})
    ii = ii + 1
  endloop
  # IBM Plex Sans JP 等幅化対策 (半角右寄せ)
  full_right_list = [65378, 1114332, 1114334, 1114336, 1114338, 1114340]
  ii = 0
  while (ii < SizeOf(full_right_list))
    Select(full_right_list[ii])
    move_pt = (${plexjp_width} / 2) - GlyphInfo('Width')
    Move(move_pt, 0)
    SetWidth(${plexjp_width} / 2)
    move_pt = (${plemoljp_half_width} - GlyphInfo('Width')) / 2
    Move(move_pt, 0)
    SetWidth(${plemoljp_half_width})
    ii = ii + 1
  endloop
  # IBM Plex Sans JP 等幅化対策 (全角化して右寄せ)
  half_to_full_right_list = [8216, 8220]
  ii = 0
  while (ii < SizeOf(half_to_full_right_list))
    Select(half_to_full_right_list[ii])
    move_pt = ${plexjp_width} - GlyphInfo('Width')
    Move(move_pt, 0)
    SetWidth(${plexjp_width})
    move_pt = (${plemoljp_full_width} - GlyphInfo('Width')) / 2
    Move(move_pt, 0)
    SetWidth(${plemoljp_full_width})
    ii = ii + 1
  endloop

  # Edit zenkaku space (from ballot box and heavy greek cross)
  if ("${HIDDEN_SPACE_FLG}" != "true")
        Print("Edit zenkaku space")
        Select(0u25A1); Copy(); Select(0u3000); Paste(); ExpandStroke(20, 0, 0, 0, 1)
        Select(0u254B); Copy(); Select(0uFFFE); Paste(); Scale(180); Copy()
        Select(0u3000); PasteInto()
        Select(0uFFFE); Clear(); Select(0u3000);
        OverlapIntersect()
  endif

  # broken bar は IBMPlexMono ベースにする
  Select(0u00a6); Clear()

  # Edit zenkaku brackets
  Print("Edit zenkaku brackets")
  bracket_move = $((${plemoljp_half_width} / 2 + ${plemoljp_half_width} / 30))
  Select(0uff08); Move(-bracket_move, 0); SetWidth(${plemoljp_full_width}) # (
  Select(0uff09); Move( bracket_move, 0); SetWidth(${plemoljp_full_width}) # )
  Select(0uff3b); Move(-bracket_move, 0); SetWidth(${plemoljp_full_width}) # [
  Select(0uff3d); Move( bracket_move, 0); SetWidth(${plemoljp_full_width}) # ]
  Select(0uff5b); Move(-bracket_move, 0); SetWidth(${plemoljp_full_width}) # {
  Select(0uff5d); Move( bracket_move, 0); SetWidth(${plemoljp_full_width}) # }

  # 全角 ，．‘’“” の調整
  Select(0uff0e);Scale(155) ; SetWidth(${plemoljp_full_width}) # ．
  Select(0uff0c);Scale(145) ; SetWidth(${plemoljp_full_width}) # ，
  Select(0u2018);Scale(145) ; SetWidth(${plemoljp_full_width}) # ‘
  Select(0u2019);Scale(145) ; SetWidth(${plemoljp_full_width}) # ’
  Select(0u201c);Scale(145) ; SetWidth(${plemoljp_full_width}) # “
  Select(0u201d);Scale(145) ; SetWidth(${plemoljp_full_width}) # ”

  # 下限で見切れているグリフの調整
  Select(0uff47); Scale(100, 91) # ｇ
  Select(0uff4a); Scale(100, 91) # ｊ

  # Save modified IBMPlexSansJP
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])
  Close()

  # Open new file
  Print("Generate IBMPlexSansJP ttf")
  New()
  # Set encoding to Unicode-bmp
  Reencode("unicode")
  # Set configuration
  if (Strstr(fontstyle_list[i], 'Italic') >= 0)
    style_split = StrSplit(fontstyle_list[i], ' ')
    SetFontNames("modified-plexjp" + style_split[0] + style_split[1])
  else
    SetFontNames("modified-plexjp" + fontstyle_list[i])
  endif
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${plemoljp_ascent})
  SetOS2Value("WinDescent",            ${plemoljp_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${plemoljp_ascent})
  SetOS2Value("HHeadDescent",         -${plemoljp_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  MergeFonts("${tmpdir}/" + output_list[i])
  Generate("${tmpdir}/" + output_list[i] + ".ttf", "")
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified IBMPlexSansJP for PlemolJP35
########################################

cat > ${tmpdir}/${modified_plexjp35_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified IBMPlexSansJP - 35")

# Set parameters
plexmono = "${tmpdir}/${modified_plexmono35_regular}"
input_list  = [ \\
                "${input_plexjp_thin}", \\
                "${input_plexjp_extralight}", \\
                "${input_plexjp_light}", \\
                "${input_plexjp_regular}", \\
                "${input_plexjp_text}", \\
                "${input_plexjp_medium}", \\
                "${input_plexjp_semibold}", \\
                "${input_plexjp_bold}", \\
                "${input_plexjp_thin}", \\
                "${input_plexjp_extralight}", \\
                "${input_plexjp_light}", \\
                "${input_plexjp_regular}", \\
                "${input_plexjp_text}", \\
                "${input_plexjp_medium}", \\
                "${input_plexjp_semibold}", \\
                "${input_plexjp_bold}" \\
              ]
output_list = [ \\
                "${modified_plexjp35_thin}", \\
                "${modified_plexjp35_extralight}", \\
                "${modified_plexjp35_light}", \\
                "${modified_plexjp35_regular}", \\
                "${modified_plexjp35_text}", \\
                "${modified_plexjp35_medium}", \\
                "${modified_plexjp35_semibold}", \\
                "${modified_plexjp35_bold}", \\
                "${modified_plexjp35_thin_italic}", \\
                "${modified_plexjp35_extralight_italic}", \\
                "${modified_plexjp35_light_italic}", \\
                "${modified_plexjp35_regular_italic}", \\
                "${modified_plexjp35_text_italic}", \\
                "${modified_plexjp35_medium_italic}", \\
                "${modified_plexjp35_semibold_italic}", \\
                "${modified_plexjp35_bold_italic}" \\
              ]

fontstyle_list    = [ \\
                      "Thin", \\
                      "ExtraLight", \\
                      "Light", \\
                      "Regular", \\
                      "Text", \\
                      "Medium", \\
                      "SemiBold", \\
                      "Bold", \\
                      "Thin Italic", \\
                      "ExtraLight Italic", \\
                      "Light Italic", \\
                      "Regular Italic", \\
                      "Text Italic", \\
                      "Medium Italic", \\
                      "SemiBold Italic", \\
                      "Bold Italic" \\
                    ]

fontweight_list   = [ \\
                      100, \\
                      200, \\
                      300, \\
                      400, \\
                      450, \\
                      500, \\
                      600, \\
                      700, \\
                      100, \\
                      200, \\
                      300, \\
                      400, \\
                      450, \\
                      500, \\
                      600, \\
                      700 \\
                    ]
panoseweight_list = [ \\
                      3, \\
                      3, \\
                      4, \\
                      5, \\
                      5, \\
                      6, \\
                      7, \\
                      8, \\
                      3, \\
                      3, \\
                      4, \\
                      5, \\
                      5, \\
                      6, \\
                      7, \\
                      8 \\
                    ]

Print("Get trim target glyph from IBMPlexMono")
Open(plexmono)
i = 0
end_plexmono = 65535
plexmono_exist_glyph_array = Array(end_plexmono)
while (i < end_plexmono)
  if (i % 5000 == 0)
    Print("Processing progress: " + i)
  endif
  if (WorthOutputting(i))
    plexmono_exist_glyph_array[i] = 1
  else
    plexmono_exist_glyph_array[i] = 0
  endif
  i++
endloop
Close()

# Begin loop
i = 0
end_plexjp = 1115564
i_halfwidth = 0
i_width1000 = 0
halfwidth_array = Array(10000)
width1000_array = Array(10000)
Print("Half width check loop start")
Open(input_list[0])
while (i < end_plexjp)
      if ( i % 10000 == 0 )
        Print("Processing progress: " + i)
      endif
      if (WorthOutputting(i) && (i > end_plexmono || plexmono_exist_glyph_array[i] == 0))
        Select(i)
        glyphWidth = GlyphInfo("Width")
        if (glyphWidth < ${plemoljp_half_width})
          halfwidth_array[i_halfwidth] = i
          i_halfwidth = i_halfwidth + 1
        elseif (glyphWidth == 1000)
          width1000_array[i_width1000] = i
          i_width1000 = i_width1000 + 1
        endif
      endif
      i = i + 1
endloop
Close()
Print("Half width check loop end")

i = 0
while (i < SizeOf(input_list))
  # Open IBMPlexSansJP
  Print("Open " + input_list[i])
  Open(input_list[i])
  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${em_ascent}, ${em_descent})

  # 斜体の生成
  if (Strstr(fontstyle_list[i], 'Italic') >= 0)
    Italic(${italic_angle})
  endif

  SelectNone()

  Print("Remove IBMPlexMono Glyphs start")
  ii = 0
  while ( ii < end_plexmono )
      if ( ii % 5000 == 0 )
        Print("Processing progress: " + ii)
      endif
      if (WorthOutputting(ii) && plexmono_exist_glyph_array[ii] == 1)
        SelectMore(ii)
      endif
      ii = ii + 1
  endloop
  Clear()
  Print("Remove IBMPlexMono Glyphs end")

  Print("Full SetWidth start")
  move_pt = $(((${plemoljp35_full_width} - ${plexjp_width}) / 2)) # 3
  width_pt = ${plemoljp35_full_width} # 1030

  SelectNone()
  ii=0
  while (ii < i_width1000)
      SelectMore(width1000_array[ii])
      ii = ii + 1
  endloop
  Move(move_pt, 0)
  SetWidth(width_pt)
  
  SelectWorthOutputting()
  ii=0
  while (ii < i_halfwidth)
      SelectFewer(halfwidth_array[ii])
      ii = ii + 1
  endloop
  ii=0
  while (ii < i_width1000)
      SelectFewer(width1000_array[ii])
      ii = ii + 1
  endloop
  $set_full_left_fewer
  SetWidth(width_pt)
  CenterInWidth()
  Print("Full SetWidth end")

  SelectNone()

  Print("Half SetWidth start")
  move_pt = $(((${plemoljp35_half_width} - ${plexjp_width} / 2) / 2)) # 35
  width_pt = ${plemoljp35_half_width} # 618
  ii=0
  while (ii < i_halfwidth)
      SelectMore(halfwidth_array[ii])
      ii = ii + 1
  endloop
  $set_half_left_fewer
  $set_half_right_fewer
  $set_half_to_full_right_fewer
  #Move(move_pt, 0)
  SetWidth(width_pt)
  CenterInWidth()
  Print("Half SetWidth end")

  $set_width_full_and_center
  SetWidth($plemoljp35_full_width)
  CenterInWidth()
  # IBM Plex Sans JP 等幅化対策 (半角左寄せ)
  half_left_list = [65377, 65379, 65380, 65438, 65439, 1114333, 1114335, 1114337, 1114339, 1114341]
  ii = 0
  while (ii < SizeOf(half_left_list))
    Select(half_left_list[ii])
    SetWidth(${plexjp_width} / 2)
    move_pt = (${plemoljp35_half_width} - GlyphInfo('Width')) / 2
    Move(move_pt, 0)
    SetWidth(${plemoljp35_half_width})
    ii = ii + 1
  endloop
  # IBM Plex Sans JP 等幅化対策 (全角左寄せ)
  full_left_list = [8217 ,8218 ,8221 ,8222]
  ii = 0
  while (ii < SizeOf(full_left_list))
    Select(full_left_list[ii])
    SetWidth(${plexjp_width})
    move_pt = (${plemoljp35_full_width} - GlyphInfo('Width')) / 2
    Move(move_pt, 0)
    SetWidth(${plemoljp35_full_width})
    ii = ii + 1
  endloop
  # IBM Plex Sans JP 等幅化対策 (半角右寄せ)
  full_right_list = [65378, 1114332, 1114334, 1114336, 1114338, 1114340]
  ii = 0
  while (ii < SizeOf(full_right_list))
    Select(full_right_list[ii])
    move_pt = (${plexjp_width} / 2) - GlyphInfo('Width')
    Move(move_pt, 0)
    SetWidth(${plexjp_width} / 2)
    move_pt = (${plemoljp35_half_width} - GlyphInfo('Width')) / 2
    Move(move_pt, 0)
    SetWidth(${plemoljp35_half_width})
    ii = ii + 1
  endloop
  # IBM Plex Sans JP 等幅化対策 (全角化して右寄せ)
  half_to_full_right_list = [8216, 8220]
  ii = 0
  while (ii < SizeOf(half_to_full_right_list))
    Select(half_to_full_right_list[ii])
    move_pt = ${plexjp_width} - GlyphInfo('Width')
    Move(move_pt, 0)
    SetWidth(${plexjp_width})
    move_pt = (${plemoljp35_full_width} - GlyphInfo('Width')) / 2
    Move(move_pt, 0)
    SetWidth(${plemoljp35_full_width})
    ii = ii + 1
  endloop

  # Edit zenkaku space (from ballot box and heavy greek cross)
  if ("${HIDDEN_SPACE_FLG}" != "true")
        Print("Edit zenkaku space")
        Select(0u25A1); Copy(); Select(0u3000); Paste(); ExpandStroke(20, 0, 0, 0, 1)
        Select(0u254B); Copy(); Select(0uFFFE); Paste(); Scale(180); Copy()
        Select(0u3000); PasteInto()
        Select(0uFFFE); Clear(); Select(0u3000);
        OverlapIntersect()
  endif

  # broken bar は IBMPlexMono ベースにする
  Select(0u00a6); Clear()

  # Edit zenkaku brackets
  Print("Edit zenkaku brackets")
  bracket_move = $((${plemoljp35_half_width} / 2 + ${plemoljp35_half_width} / 30))
  Select(0uff08); Move(-bracket_move, 0); SetWidth(${plemoljp35_full_width}) # (
  Select(0uff09); Move( bracket_move, 0); SetWidth(${plemoljp35_full_width}) # )
  Select(0uff3b); Move(-bracket_move, 0); SetWidth(${plemoljp35_full_width}) # [
  Select(0uff3d); Move( bracket_move, 0); SetWidth(${plemoljp35_full_width}) # ]
  Select(0uff5b); Move(-bracket_move, 0); SetWidth(${plemoljp35_full_width}) # {
  Select(0uff5d); Move( bracket_move, 0); SetWidth(${plemoljp35_full_width}) # }

  # 全角 ，．‘’“” の調整
  Select(0uff0e);Scale(155) ; SetWidth(${plemoljp35_full_width}) # ．
  Select(0uff0c);Scale(145) ; SetWidth(${plemoljp35_full_width}) # ，
  Select(0u2018);Scale(145) ; SetWidth(${plemoljp35_full_width}) # ‘
  Select(0u2019);Scale(145) ; SetWidth(${plemoljp35_full_width}) # ’
  Select(0u201c);Scale(145) ; SetWidth(${plemoljp35_full_width}) # “
  Select(0u201d);Scale(145) ; SetWidth(${plemoljp35_full_width}) # ”

  # Save modified IBMPlexSansJP
  Print("Save " + output_list[i])
  Save("${tmpdir}/" + output_list[i])
  Close()

  # Open new file
  Print("Generate IBMPlexSansJP ttf")
  New()
  # Set encoding to Unicode-bmp
  Reencode("unicode")
  # Set configuration
  if (Strstr(fontstyle_list[i], 'Italic') >= 0)
    style_split = StrSplit(fontstyle_list[i], ' ')
    SetFontNames("modified-plexjp" + style_split[0] + style_split[1])
  else
    SetFontNames("modified-plexjp" + fontstyle_list[i])
  endif
  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${plemoljp35_ascent})
  SetOS2Value("WinDescent",            ${plemoljp35_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${plemoljp35_ascent})
  SetOS2Value("HHeadDescent",         -${plemoljp35_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  MergeFonts("${tmpdir}/" + output_list[i])
  Generate("${tmpdir}/" + output_list[i] + ".ttf", "")
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified IBMPlexSansJP Console
########################################

cat > ${tmpdir}/${modified_plexjp_console_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified IBMPlexSansJP Console")

# Set parameters
plexmono = "${tmpdir}/${modified_plexmono_material_regular}"
input_list  = [ \\
                "${tmpdir}/${modified_plexjp_thin}.ttf", \\
                "${tmpdir}/${modified_plexjp_extralight}.ttf", \\
                "${tmpdir}/${modified_plexjp_light}.ttf", \\
                "${tmpdir}/${modified_plexjp_regular}.ttf", \\
                "${tmpdir}/${modified_plexjp_text}.ttf", \\
                "${tmpdir}/${modified_plexjp_medium}.ttf", \\
                "${tmpdir}/${modified_plexjp_semibold}.ttf", \\
                "${tmpdir}/${modified_plexjp_bold}.ttf", \\
                "${tmpdir}/${modified_plexjp_thin_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp_extralight_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp_light_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp_regular_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp_text_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp_medium_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp_semibold_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp_bold_italic}.ttf" \\
              ]
output_list = [ \\
                "${modified_plexjp_console_thin}", \\
                "${modified_plexjp_console_extralight}", \\
                "${modified_plexjp_console_light}", \\
                "${modified_plexjp_console_regular}", \\
                "${modified_plexjp_console_text}", \\
                "${modified_plexjp_console_medium}", \\
                "${modified_plexjp_console_semibold}", \\
                "${modified_plexjp_console_bold}", \\
                "${modified_plexjp_console_thin_italic}", \\
                "${modified_plexjp_console_extralight_italic}", \\
                "${modified_plexjp_console_light_italic}", \\
                "${modified_plexjp_console_regular_italic}", \\
                "${modified_plexjp_console_text_italic}", \\
                "${modified_plexjp_console_medium_italic}", \\
                "${modified_plexjp_console_semibold_italic}", \\
                "${modified_plexjp_console_bold_italic}" \\
              ]

Print("Get trim target glyph from IBMPlexMono")
Open(plexmono)
i = 0
end_plexmono = 65535
plexmono_exist_glyph_array = Array(end_plexmono)
while (i < end_plexmono)
  if (i % 5000 == 0)
    Print("Processing progress: " + i)
  endif
  if (WorthOutputting(i))
    plexmono_exist_glyph_array[i] = 1
  else
    plexmono_exist_glyph_array[i] = 0
  endif
  i++
endloop
Close()

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open IBMPlexSansJP
  Print("Open " + input_list[i])
  Open(input_list[i])

  ii = 0
  end_plexjp = end_plexmono
  Print("Begin delete the glyphs contained in IBMPlexMono")
  SelectNone()
  while ( ii < end_plexjp )
      if ( ii % 5000 == 0 )
        Print("Processing progress: " + ii)
      endif
      if (WorthOutputting(ii) && plexmono_exist_glyph_array[ii] == 1)
        SelectMore(ii)
      endif
      ii = ii + 1
  endloop
  Clear()
  Print("End delete the glyphs contained in IBMPlexMono")

  # 結合分音記号は全て源柔ゴシック収録のものを使用する
  #Select(0u0300, 0u036f)
  #move_pt = $(((${plemoljp_half_width} - ${plemoljp_full_width}) / 2))
  #Move(move_pt, 0)
  #SetWidth(${plemoljp_half_width}, 0)

  # Save modified IBMPlexSansJP
  Print("Generate " + output_list[i])
  Generate("${tmpdir}/" + output_list[i] + ".ttf", "")
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for modified IBMPlexSansJP Console for PlemolJP35
########################################

cat > ${tmpdir}/${modified_plexjp35_console_generator} << _EOT_
#!$fontforge_command -script

Print("Generate modified IBMPlexSansJP Console - 35")

# Set parameters
plexmono = "${tmpdir}/${modified_plexmono_material_regular}"
input_list  = [ \\
                "${tmpdir}/${modified_plexjp35_thin}.ttf", \\
                "${tmpdir}/${modified_plexjp35_extralight}.ttf", \\
                "${tmpdir}/${modified_plexjp35_light}.ttf", \\
                "${tmpdir}/${modified_plexjp35_regular}.ttf", \\
                "${tmpdir}/${modified_plexjp35_text}.ttf", \\
                "${tmpdir}/${modified_plexjp35_medium}.ttf", \\
                "${tmpdir}/${modified_plexjp35_semibold}.ttf", \\
                "${tmpdir}/${modified_plexjp35_bold}.ttf", \\
                "${tmpdir}/${modified_plexjp35_thin_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp35_extralight_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp35_light_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp35_regular_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp35_text_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp35_medium_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp35_semibold_italic}.ttf", \\
                "${tmpdir}/${modified_plexjp35_bold_italic}.ttf" \\
              ]
output_list = [ \\
                "${modified_plexjp35_console_thin}", \\
                "${modified_plexjp35_console_extralight}", \\
                "${modified_plexjp35_console_light}", \\
                "${modified_plexjp35_console_regular}", \\
                "${modified_plexjp35_console_text}", \\
                "${modified_plexjp35_console_medium}", \\
                "${modified_plexjp35_console_semibold}", \\
                "${modified_plexjp35_console_bold}", \\
                "${modified_plexjp35_console_thin_italic}", \\
                "${modified_plexjp35_console_extralight_italic}", \\
                "${modified_plexjp35_console_light_italic}", \\
                "${modified_plexjp35_console_regular_italic}", \\
                "${modified_plexjp35_console_text_italic}", \\
                "${modified_plexjp35_console_medium_italic}", \\
                "${modified_plexjp35_console_semibold_italic}", \\
                "${modified_plexjp35_console_bold_italic}" \\
              ]

Print("Get trim target glyph from IBMPlexMono")
Open(plexmono)
i = 0
end_plexmono = 65535
plexmono_exist_glyph_array = Array(end_plexmono)
while (i < end_plexmono)
  if (i % 5000 == 0)
    Print("Processing progress: " + i)
  endif
  if (WorthOutputting(i))
    plexmono_exist_glyph_array[i] = 1
  else
    plexmono_exist_glyph_array[i] = 0
  endif
  i++
endloop
Close()

# Begin loop of regular and bold
i = 0
while (i < SizeOf(input_list))
  # Open IBMPlexSansJP
  Print("Open " + input_list[i])
  Open(input_list[i])

  ii = 0
  end_plexjp = end_plexmono
  Print("Begin delete the glyphs contained in IBMPlexMono")
  SelectNone()
  while ( ii < end_plexjp )
      if ( ii % 5000 == 0 )
        Print("Processing progress: " + ii)
      endif
      if (WorthOutputting(ii) && plexmono_exist_glyph_array[ii] == 1)
        SelectMore(ii)
      endif
      ii = ii + 1
  endloop
  Clear()
  Print("End delete the glyphs contained in IBMPlexMono")

  # 結合分音記号は全て源柔ゴシック収録のものを使用する
  #Select(0u0300, 0u036f)
  #move_pt = $(((${plemoljp35_half_width} - ${plemoljp35_full_width}) / 2))
  #Move(move_pt, 0)
  #SetWidth(${plemoljp35_half_width}, 0)

  # Save modified IBMPlexSansJP
  Print("Generate " + output_list[i])
  Generate("${tmpdir}/" + output_list[i] + ".ttf", "")
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for PlemolJP
########################################

cat > ${tmpdir}/${plemoljp_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate PlemolJP")

# Set parameters
plexmono_list  = [ \\
                    "${tmpdir}/${modified_plexmono_thin}", \\
                    "${tmpdir}/${modified_plexmono_extralight}", \\
                    "${tmpdir}/${modified_plexmono_light}", \\
                    "${tmpdir}/${modified_plexmono_regular}", \\
                    "${tmpdir}/${modified_plexmono_text}", \\
                    "${tmpdir}/${modified_plexmono_medium}", \\
                    "${tmpdir}/${modified_plexmono_semibold}", \\
                    "${tmpdir}/${modified_plexmono_bold}", \\
                    "${tmpdir}/${modified_plexmono_thin_italic}", \\
                    "${tmpdir}/${modified_plexmono_extralight_italic}", \\
                    "${tmpdir}/${modified_plexmono_light_italic}", \\
                    "${tmpdir}/${modified_plexmono_regular_italic}", \\
                    "${tmpdir}/${modified_plexmono_text_italic}", \\
                    "${tmpdir}/${modified_plexmono_medium_italic}", \\
                    "${tmpdir}/${modified_plexmono_semibold_italic}", \\
                    "${tmpdir}/${modified_plexmono_bold_italic}" \\
                  ]
fontfamily        = "${plemoljp_familyname}"
fontfamilysuffix  = "${plemoljp_familyname_suffix}"

fontstyle_list    = [ \\
                      "Thin", \\
                      "ExtraLight", \\
                      "Light", \\
                      "Regular", \\
                      "Text", \\
                      "Medium", \\
                      "SemiBold", \\
                      "Bold", \\
                      "Thin Italic", \\
                      "ExtraLight Italic", \\
                      "Light Italic", \\
                      "Regular Italic", \\
                      "Text Italic", \\
                      "Medium Italic", \\
                      "SemiBold Italic", \\
                      "Bold Italic" \\
                    ]

fontweight_list   = [ \\
                      100, \\
                      200, \\
                      300, \\
                      400, \\
                      450, \\
                      500, \\
                      600, \\
                      700, \\
                      100, \\
                      200, \\
                      300, \\
                      400, \\
                      450, \\
                      500, \\
                      600, \\
                      700 \\
                    ]
panoseweight_list = [ \\
                      3, \\
                      3, \\
                      4, \\
                      5, \\
                      5, \\
                      6, \\
                      7, \\
                      8, \\
                      3, \\
                      3, \\
                      4, \\
                      5, \\
                      5, \\
                      6, \\
                      7, \\
                      8 \\
                    ]

copyright         = "Copyright (c) 2019, Yuko Otawara"
version           = "${plemoljp_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  fontname_style = fontstyle_list[i]
  base_style = fontstyle_list[i]

  # 斜体の生成
  if (Strstr(fontstyle_list[i], 'Italic') >= 0)
    SetItalicAngle(${italic_angle})
    style_split = StrSplit(fontstyle_list[i], ' ')
    if (style_split[0] == 'Regular')
      fontname_style = 'Italic'
    else
      fontname_style = style_split[0] + style_split[1]
    endif
    base_style = style_split[0]
  endif

  # Set configuration
  if (Strstr(fontstyle_list[i], 'Regular') == -1 && Strstr(fontstyle_list[i], 'Bold') == -1)
    if (fontfamilysuffix != "")
      SetFontNames(fontfamily + fontfamilysuffix + "-" + fontname_style, \\
                    fontfamily + " " + fontfamilysuffix + " " + base_style, \\
                    fontfamily + " " + fontfamilysuffix + " " + fontstyle_list[i], \\
                    base_style, \\
                    copyright, version)
    else
      SetFontNames(fontfamily + "-" + fontname_style, \\
                    fontfamily + " " + base_style, \\
                    fontfamily + " " + fontstyle_list[i], \\
                    base_style, \\
                    copyright, version)
    endif
    
    if (Strstr(fontstyle_list[i], 'Italic') >= 0)
      SetTTFName(0x409, 2, "Italic")
    else
      SetTTFName(0x409, 2, "Regular")
    endif
  else
    display_style = fontstyle_list[i]
    if (fontstyle_list[i] == 'Regular Italic')
      SetTTFName(0x409, 2, 'Italic')
      display_style = 'Italic'
    else
      SetTTFName(0x409, 2, fontstyle_list[i])
    endif

    if (fontfamilysuffix != "")
      SetFontNames(fontfamily + fontfamilysuffix + "-" + fontname_style, \\
                    fontfamily + " " + fontfamilysuffix, \\
                    fontfamily + " " + fontfamilysuffix + " " + display_style, \\
                    base_style, \\
                    copyright, version)
    else
      SetFontNames(fontfamily + "-" + fontname_style, \\
                    fontfamily, \\
                    fontfamily + " " + display_style, \\
                    base_style, \\
                    copyright, version)
    endif
  endif

  if (fontfamilysuffix != "")
    SetTTFName(0x409, 16, fontfamily + " " + fontfamilysuffix)
  else
    SetTTFName(0x409, 16, fontfamily)
  endif
  if (fontstyle_list[i] == 'Regular Italic')
    SetTTFName(0x409, 17, 'Italic')
  else
    SetTTFName(0x409, 17, fontstyle_list[i])
  endif


  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))

  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${plemoljp_ascent})
  SetOS2Value("WinDescent",            ${plemoljp_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${plemoljp_ascent})
  SetOS2Value("HHeadDescent",         -${plemoljp_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  # Merge IBMPlexMono font
  Print("Merge " + plexmono_list[i]:t)
  MergeFonts(plexmono_list[i])

  # Save PlemolJP
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontname_style + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix + "-" + fontname_style + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontname_style + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontname_style + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for PlemolJP Console
########################################

cat > ${tmpdir}/${plemoljp_console_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate PlemolJP Console")

# Set parameters
plexmono_list  = [ \\
                    "${tmpdir}/${modified_plexmono_console_thin}", \\
                    "${tmpdir}/${modified_plexmono_console_extralight}", \\
                    "${tmpdir}/${modified_plexmono_console_light}", \\
                    "${tmpdir}/${modified_plexmono_console_regular}", \\
                    "${tmpdir}/${modified_plexmono_console_text}", \\
                    "${tmpdir}/${modified_plexmono_console_medium}", \\
                    "${tmpdir}/${modified_plexmono_console_semibold}", \\
                    "${tmpdir}/${modified_plexmono_console_bold}", \\
                    "${tmpdir}/${modified_plexmono_console_thin_italic}", \\
                    "${tmpdir}/${modified_plexmono_console_extralight_italic}", \\
                    "${tmpdir}/${modified_plexmono_console_light_italic}", \\
                    "${tmpdir}/${modified_plexmono_console_regular_italic}", \\
                    "${tmpdir}/${modified_plexmono_console_text_italic}", \\
                    "${tmpdir}/${modified_plexmono_console_medium_italic}", \\
                    "${tmpdir}/${modified_plexmono_console_semibold_italic}", \\
                    "${tmpdir}/${modified_plexmono_console_bold_italic}" \\
                  ]
fontfamily        = "${plemoljp_familyname}"
fontfamilysuffix_nonspace = "${plemoljp_console_suffix}${hs_suffix}"
fontfamilysuffix_inspace  = "${plemoljp_console_suffix} ${hs_suffix}"

fontstyle_list    = [ \\
                      "Thin", \\
                      "ExtraLight", \\
                      "Light", \\
                      "Regular", \\
                      "Text", \\
                      "Medium", \\
                      "SemiBold", \\
                      "Bold", \\
                      "Thin Italic", \\
                      "ExtraLight Italic", \\
                      "Light Italic", \\
                      "Regular Italic", \\
                      "Text Italic", \\
                      "Medium Italic", \\
                      "SemiBold Italic", \\
                      "Bold Italic" \\
                    ]

fontweight_list   = [ \\
                      100, \\
                      200, \\
                      300, \\
                      400, \\
                      450, \\
                      500, \\
                      600, \\
                      700, \\
                      100, \\
                      200, \\
                      300, \\
                      400, \\
                      450, \\
                      500, \\
                      600, \\
                      700 \\
                    ]
panoseweight_list = [ \\
                      3, \\
                      3, \\
                      4, \\
                      5, \\
                      5, \\
                      6, \\
                      7, \\
                      8, \\
                      3, \\
                      3, \\
                      4, \\
                      5, \\
                      5, \\
                      6, \\
                      7, \\
                      8 \\
                    ]

copyright         = "Copyright (c) 2019, Yuko Otawara"
version           = "${plemoljp_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  fontname_style = fontstyle_list[i]
  base_style = fontstyle_list[i]

  # 斜体の生成
  if (Strstr(fontstyle_list[i], 'Italic') >= 0)
    SetItalicAngle(${italic_angle})
    style_split = StrSplit(fontstyle_list[i], ' ')
    if (style_split[0] == 'Regular')
      fontname_style = 'Italic'
    else
      fontname_style = style_split[0] + style_split[1]
    endif
    base_style = style_split[0]
  endif

  # Set configuration
  if (Strstr(fontstyle_list[i], 'Regular') == -1 && Strstr(fontstyle_list[i], 'Bold') == -1)
    if (fontfamilysuffix_nonspace != "")
      SetFontNames(fontfamily + fontfamilysuffix_nonspace + "-" + fontname_style, \\
                    fontfamily + " " + fontfamilysuffix_inspace + " " + base_style, \\
                    fontfamily + " " + fontfamilysuffix_inspace + " " + fontstyle_list[i], \\
                    base_style, \\
                    copyright, version)
    else
      SetFontNames(fontfamily + "-" + fontname_style, \\
                    fontfamily + " " + base_style, \\
                    fontfamily + " " + fontstyle_list[i], \\
                    base_style, \\
                    copyright, version)
    endif
    
    if (Strstr(fontstyle_list[i], 'Italic') >= 0)
      SetTTFName(0x409, 2, "Italic")
    else
      SetTTFName(0x409, 2, "Regular")
    endif
  else
    display_style = fontstyle_list[i]
    if (fontstyle_list[i] == 'Regular Italic')
      SetTTFName(0x409, 2, 'Italic')
      display_style = 'Italic'
    else
      SetTTFName(0x409, 2, fontstyle_list[i])
    endif

    if (fontfamilysuffix_nonspace != "")
      SetFontNames(fontfamily + fontfamilysuffix_nonspace + "-" + fontname_style, \\
                    fontfamily + " " + fontfamilysuffix_inspace, \\
                    fontfamily + " " + fontfamilysuffix_inspace + " " + display_style, \\
                    base_style, \\
                    copyright, version)
    else
      SetFontNames(fontfamily + "-" + fontname_style, \\
                    fontfamily, \\
                    fontfamily + " " + display_style, \\
                    base_style, \\
                    copyright, version)
    endif
  endif

  if (fontfamilysuffix_nonspace != "")
    SetTTFName(0x409, 16, fontfamily + " " + fontfamilysuffix_inspace)
  else
    SetTTFName(0x409, 16, fontfamily)
  endif
  if (fontstyle_list[i] == 'Regular Italic')
    SetTTFName(0x409, 17, 'Italic')
  else
    SetTTFName(0x409, 17, fontstyle_list[i])
  endif


  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))

  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${plemoljp_ascent})
  SetOS2Value("WinDescent",            ${plemoljp_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${plemoljp_ascent})
  SetOS2Value("HHeadDescent",         -${plemoljp_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  # Merge IBMPlexMono font
  Print("Merge " + plexmono_list[i]:t)
  MergeFonts(plexmono_list[i])

  # Save PlemolJP
  if (fontfamilysuffix_nonspace != "")
        Print("Save " + fontfamily + fontfamilysuffix_nonspace + "-" + fontname_style + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix_nonspace + "-" + fontname_style + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontname_style + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontname_style + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for PlemolJP35
########################################

cat > ${tmpdir}/${plemoljp35_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate PlemolJP")

# Set parameters
plexmono_list  = [ \\
                    "${tmpdir}/${modified_plexmono35_thin}", \\
                    "${tmpdir}/${modified_plexmono35_extralight}", \\
                    "${tmpdir}/${modified_plexmono35_light}", \\
                    "${tmpdir}/${modified_plexmono35_regular}", \\
                    "${tmpdir}/${modified_plexmono35_text}", \\
                    "${tmpdir}/${modified_plexmono35_medium}", \\
                    "${tmpdir}/${modified_plexmono35_semibold}", \\
                    "${tmpdir}/${modified_plexmono35_bold}", \\
                    "${tmpdir}/${modified_plexmono35_thin_italic}", \\
                    "${tmpdir}/${modified_plexmono35_extralight_italic}", \\
                    "${tmpdir}/${modified_plexmono35_light_italic}", \\
                    "${tmpdir}/${modified_plexmono35_regular_italic}", \\
                    "${tmpdir}/${modified_plexmono35_text_italic}", \\
                    "${tmpdir}/${modified_plexmono35_medium_italic}", \\
                    "${tmpdir}/${modified_plexmono35_semibold_italic}", \\
                    "${tmpdir}/${modified_plexmono35_bold_italic}" \\
                  ]
fontfamily        = "${plemoljp35_familyname}"
fontfamilysuffix  = "${plemoljp35_familyname_suffix}"

fontstyle_list    = [ \\
                      "Thin", \\
                      "ExtraLight", \\
                      "Light", \\
                      "Regular", \\
                      "Text", \\
                      "Medium", \\
                      "SemiBold", \\
                      "Bold", \\
                      "Thin Italic", \\
                      "ExtraLight Italic", \\
                      "Light Italic", \\
                      "Regular Italic", \\
                      "Text Italic", \\
                      "Medium Italic", \\
                      "SemiBold Italic", \\
                      "Bold Italic" \\
                    ]

fontweight_list   = [ \\
                      100, \\
                      200, \\
                      300, \\
                      400, \\
                      450, \\
                      500, \\
                      600, \\
                      700, \\
                      100, \\
                      200, \\
                      300, \\
                      400, \\
                      450, \\
                      500, \\
                      600, \\
                      700 \\
                    ]
panoseweight_list = [ \\
                      3, \\
                      3, \\
                      4, \\
                      5, \\
                      5, \\
                      6, \\
                      7, \\
                      8, \\
                      3, \\
                      3, \\
                      4, \\
                      5, \\
                      5, \\
                      6, \\
                      7, \\
                      8 \\
                    ]

copyright         = "Copyright (c) 2019, Yuko Otawara"
version           = "${plemoljp_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  fontname_style = fontstyle_list[i]
  base_style = fontstyle_list[i]

  # 斜体の生成
  if (Strstr(fontstyle_list[i], 'Italic') >= 0)
    SetItalicAngle(${italic_angle})
    style_split = StrSplit(fontstyle_list[i], ' ')
    if (style_split[0] == 'Regular')
      fontname_style = 'Italic'
    else
      fontname_style = style_split[0] + style_split[1]
    endif
    base_style = style_split[0]
  endif

  # Set configuration
  if (Strstr(fontstyle_list[i], 'Regular') == -1 && Strstr(fontstyle_list[i], 'Bold') == -1)
    if (fontfamilysuffix != "")
      SetFontNames(fontfamily + fontfamilysuffix + "-" + fontname_style, \\
                    fontfamily + " " + fontfamilysuffix + " " + base_style, \\
                    fontfamily + " " + fontfamilysuffix + " " + fontstyle_list[i], \\
                    base_style, \\
                    copyright, version)
    else
      SetFontNames(fontfamily + "-" + fontname_style, \\
                    fontfamily + " " + base_style, \\
                    fontfamily + " " + fontstyle_list[i], \\
                    base_style, \\
                    copyright, version)
    endif
    
    if (Strstr(fontstyle_list[i], 'Italic') >= 0)
      SetTTFName(0x409, 2, "Italic")
    else
      SetTTFName(0x409, 2, "Regular")
    endif
  else
    display_style = fontstyle_list[i]
    if (fontstyle_list[i] == 'Regular Italic')
      SetTTFName(0x409, 2, 'Italic')
      display_style = 'Italic'
    else
      SetTTFName(0x409, 2, fontstyle_list[i])
    endif

    if (fontfamilysuffix != "")
      SetFontNames(fontfamily + fontfamilysuffix + "-" + fontname_style, \\
                    fontfamily + " " + fontfamilysuffix, \\
                    fontfamily + " " + fontfamilysuffix + " " + display_style, \\
                    base_style, \\
                    copyright, version)
    else
      SetFontNames(fontfamily + "-" + fontname_style, \\
                    fontfamily, \\
                    fontfamily + " " + display_style, \\
                    base_style, \\
                    copyright, version)
    endif
  endif

  if (fontfamilysuffix != "")
    SetTTFName(0x409, 16, fontfamily + " " + fontfamilysuffix)
  else
    SetTTFName(0x409, 16, fontfamily)
  endif
  if (fontstyle_list[i] == 'Regular Italic')
    SetTTFName(0x409, 17, 'Italic')
  else
    SetTTFName(0x409, 17, fontstyle_list[i])
  endif


  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))

  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${plemoljp35_ascent})
  SetOS2Value("WinDescent",            ${plemoljp35_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${plemoljp35_ascent})
  SetOS2Value("HHeadDescent",         -${plemoljp35_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  # Merge IBMPlexMono font
  Print("Merge " + plexmono_list[i]:t)
  MergeFonts(plexmono_list[i])

  # Save PlemolJP
  if (fontfamilysuffix != "")
        Print("Save " + fontfamily + fontfamilysuffix + "-" + fontname_style + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix + "-" + fontname_style + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontname_style + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontname_style + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate script for PlemolJP35 Console
########################################

cat > ${tmpdir}/${plemoljp35_console_generator} << _EOT_
#!$fontforge_command -script

# Print message
Print("Generate PlemolJP Console")

# Set parameters
plexmono_list  = [ \\
                    "${tmpdir}/${modified_plexmono35_console_thin}", \\
                    "${tmpdir}/${modified_plexmono35_console_extralight}", \\
                    "${tmpdir}/${modified_plexmono35_console_light}", \\
                    "${tmpdir}/${modified_plexmono35_console_regular}", \\
                    "${tmpdir}/${modified_plexmono35_console_text}", \\
                    "${tmpdir}/${modified_plexmono35_console_medium}", \\
                    "${tmpdir}/${modified_plexmono35_console_semibold}", \\
                    "${tmpdir}/${modified_plexmono35_console_bold}", \\
                    "${tmpdir}/${modified_plexmono35_console_thin_italic}", \\
                    "${tmpdir}/${modified_plexmono35_console_extralight_italic}", \\
                    "${tmpdir}/${modified_plexmono35_console_light_italic}", \\
                    "${tmpdir}/${modified_plexmono35_console_regular_italic}", \\
                    "${tmpdir}/${modified_plexmono35_console_text_italic}", \\
                    "${tmpdir}/${modified_plexmono35_console_medium_italic}", \\
                    "${tmpdir}/${modified_plexmono35_console_semibold_italic}", \\
                    "${tmpdir}/${modified_plexmono35_console_bold_italic}" \\
                  ]
fontfamily        = "${plemoljp35_familyname}"
fontfamilysuffix_nonspace = "${plemoljp_console_suffix}${hs_suffix}"
fontfamilysuffix_inspace  = "${plemoljp_console_suffix} ${hs_suffix}"

fontstyle_list    = [ \\
                      "Thin", \\
                      "ExtraLight", \\
                      "Light", \\
                      "Regular", \\
                      "Text", \\
                      "Medium", \\
                      "SemiBold", \\
                      "Bold", \\
                      "Thin Italic", \\
                      "ExtraLight Italic", \\
                      "Light Italic", \\
                      "Regular Italic", \\
                      "Text Italic", \\
                      "Medium Italic", \\
                      "SemiBold Italic", \\
                      "Bold Italic" \\
                    ]

fontweight_list   = [ \\
                      100, \\
                      200, \\
                      300, \\
                      400, \\
                      450, \\
                      500, \\
                      600, \\
                      700, \\
                      100, \\
                      200, \\
                      300, \\
                      400, \\
                      450, \\
                      500, \\
                      600, \\
                      700 \\
                    ]
panoseweight_list = [ \\
                      3, \\
                      3, \\
                      4, \\
                      5, \\
                      5, \\
                      6, \\
                      7, \\
                      8, \\
                      3, \\
                      3, \\
                      4, \\
                      5, \\
                      5, \\
                      6, \\
                      7, \\
                      8 \\
                    ]

copyright         = "Copyright (c) 2019, Yuko Otawara"
version           = "${plemoljp_version}"

# Begin loop of regular and bold
i = 0
while (i < SizeOf(fontstyle_list))
  # Open new file
  New()

  # Set encoding to Unicode-bmp
  Reencode("unicode")

  fontname_style = fontstyle_list[i]
  base_style = fontstyle_list[i]

  # 斜体の生成
  if (Strstr(fontstyle_list[i], 'Italic') >= 0)
    SetItalicAngle(${italic_angle})
    style_split = StrSplit(fontstyle_list[i], ' ')
    if (style_split[0] == 'Regular')
      fontname_style = 'Italic'
    else
      fontname_style = style_split[0] + style_split[1]
    endif
    base_style = style_split[0]
  endif

  # Set configuration
  if (Strstr(fontstyle_list[i], 'Regular') == -1 && Strstr(fontstyle_list[i], 'Bold') == -1)
    if (fontfamilysuffix_nonspace != "")
      SetFontNames(fontfamily + fontfamilysuffix_nonspace + "-" + fontname_style, \\
                    fontfamily + " " + fontfamilysuffix_inspace + " " + base_style, \\
                    fontfamily + " " + fontfamilysuffix_inspace + " " + fontstyle_list[i], \\
                    base_style, \\
                    copyright, version)
    else
      SetFontNames(fontfamily + "-" + fontname_style, \\
                    fontfamily + " " + base_style, \\
                    fontfamily + " " + fontstyle_list[i], \\
                    base_style, \\
                    copyright, version)
    endif
    
    if (Strstr(fontstyle_list[i], 'Italic') >= 0)
      SetTTFName(0x409, 2, "Italic")
    else
      SetTTFName(0x409, 2, "Regular")
    endif
  else
    display_style = fontstyle_list[i]
    if (fontstyle_list[i] == 'Regular Italic')
      SetTTFName(0x409, 2, 'Italic')
      display_style = 'Italic'
    else
      SetTTFName(0x409, 2, fontstyle_list[i])
    endif

    if (fontfamilysuffix_nonspace != "")
      SetFontNames(fontfamily + fontfamilysuffix_nonspace + "-" + fontname_style, \\
                    fontfamily + " " + fontfamilysuffix_inspace, \\
                    fontfamily + " " + fontfamilysuffix_inspace + " " + display_style, \\
                    base_style, \\
                    copyright, version)
    else
      SetFontNames(fontfamily + "-" + fontname_style, \\
                    fontfamily, \\
                    fontfamily + " " + display_style, \\
                    base_style, \\
                    copyright, version)
    endif
  endif

  if (fontfamilysuffix_nonspace != "")
    SetTTFName(0x409, 16, fontfamily + " " + fontfamilysuffix_inspace)
  else
    SetTTFName(0x409, 16, fontfamily)
  endif
  if (fontstyle_list[i] == 'Regular Italic')
    SetTTFName(0x409, 17, 'Italic')
  else
    SetTTFName(0x409, 17, fontstyle_list[i])
  endif

  SetTTFName(0x409, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))

  ScaleToEm(${em_ascent}, ${em_descent})
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "PfEd")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${plemoljp35_ascent})
  SetOS2Value("WinDescent",            ${plemoljp35_descent})
  SetOS2Value("TypoAscent",            ${em_ascent})
  SetOS2Value("TypoDescent",          -${em_descent})
  SetOS2Value("TypoLineGap",           ${typo_line_gap})
  SetOS2Value("HHeadAscent",           ${plemoljp35_ascent})
  SetOS2Value("HHeadDescent",         -${plemoljp35_descent})
  SetOS2Value("HHeadLineGap",            0)
  SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])

  # Merge IBMPlexMono font
  Print("Merge " + plexmono_list[i]:t)
  MergeFonts(plexmono_list[i])

  # Save PlemolJP
  if (fontfamilysuffix_nonspace != "")
        Print("Save " + fontfamily + fontfamilysuffix_nonspace + "-" + fontname_style + ".ttf")
        Generate("${base_dir}/" + fontfamily + fontfamilysuffix_nonspace + "-" + fontname_style + ".ttf", "")
  else
        Print("Save " + fontfamily + "-" + fontname_style + ".ttf")
        Generate("${base_dir}/" + fontfamily + "-" + fontname_style + ".ttf", "")
  endif
  Close()

  i += 1
endloop

Quit()
_EOT_

########################################
# Generate PlemolJP
########################################

# Generate Material
$fontforge_command -script ${tmpdir}/${modified_plexmono_material_generator} 2> $redirection_stderr || exit 4

# Generate Console
$fontforge_command -script ${tmpdir}/${modified_plexmono_console_generator} 2> $redirection_stderr || exit 4

# Generate Modiifed IBMPlexMono
$fontforge_command -script ${tmpdir}/${modified_plexmono_generator} 2> $redirection_stderr || exit 4

# Generate Modified IBMPlexSansJP
$fontforge_command -script ${tmpdir}/${modified_plexjp_generator} 2> $redirection_stderr || exit 4

# Generate Modified IBMPlexSansJP Console
$fontforge_command -script ${tmpdir}/${modified_plexjp_console_generator} 2> $redirection_stderr || exit 4

# Generate PlemolJP
$fontforge_command -script ${tmpdir}/${plemoljp_generator} 2> $redirection_stderr || exit 4

# Generate PlemolJP Console
$fontforge_command -script ${tmpdir}/${plemoljp_console_generator} 2> $redirection_stderr || exit 4

# Generate Console - 35
$fontforge_command -script ${tmpdir}/${modified_plexmono35_console_generator} 2> $redirection_stderr || exit 4

# Generate Modiifed IBMPlexMono - 35
$fontforge_command -script ${tmpdir}/${modified_plexmono35_generator} 2> $redirection_stderr || exit 4

# Generate Modified IBMPlexSansJP - 35
$fontforge_command -script ${tmpdir}/${modified_plexjp35_generator} 2> $redirection_stderr || exit 4

# Generate Modified IBMPlexSansJP Console - 35
$fontforge_command -script ${tmpdir}/${modified_plexjp35_console_generator} 2> $redirection_stderr || exit 4

# Generate PlemolJP - 35
$fontforge_command -script ${tmpdir}/${plemoljp35_generator} 2> $redirection_stderr || exit 4

# Generate PlemolJP Console - 35
$fontforge_command -script ${tmpdir}/${plemoljp35_console_generator} 2> $redirection_stderr || exit 4

for style in Thin ExtraLight Light Regular Text Medium SemiBold Bold ThinItalic ExtraLightItalic LightItalic Italic TextItalic MediumItalic SemiBoldItalic BoldItalic
do
  plemoljp_filename="${plemoljp_familyname}${plemoljp_familyname_suffix}-${style}.ttf"
  plemoljp_console_filename="${plemoljp_familyname}${plemoljp_console_suffix}${hs_suffix}-${style}.ttf"
  plemoljp35_filename="${plemoljp35_familyname}${plemoljp_familyname_suffix}-${style}.ttf"
  plemoljp35_console_filename="${plemoljp35_familyname}${plemoljp_console_suffix}${hs_suffix}-${style}.ttf"

  # Add hinting
  # PlemolJP
  for f in "$plemoljp_filename" "$plemoljp_console_filename"
  do
    ttfautohint -l 6 -r 45 -a qsq -D latn -W -X "13-15" -I "$f" "hinted_${f}"
  done
  # PlemolJP35
  for f in "$plemoljp35_filename" "$plemoljp35_console_filename"
  do
    ttfautohint -l 6 -r 45 -a qsq -D latn -W -X "13-15" -I "$f" "hinted_${f}"
  done

  if [ "${style}" = 'Thin' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_thin}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_thin}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_thin}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_thin}.ttf"
  fi
  if [ "${style}" = 'ExtraLight' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_extralight}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_extralight}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_extralight}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_extralight}.ttf"
  fi
  if [ "${style}" = 'Light' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_light}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_light}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_light}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_light}.ttf"
  fi
  if [ "${style}" = 'Regular' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_regular}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_regular}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_regular}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_regular}.ttf"
  fi
  if [ "${style}" = 'Text' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_text}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_text}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_text}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_text}.ttf"
  fi
  if [ "${style}" = 'Medium' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_medium}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_medium}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_medium}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_medium}.ttf"
  fi
  if [ "${style}" = 'SemiBold' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_semibold}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_semibold}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_semibold}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_semibold}.ttf"
  fi
  if [ "${style}" = 'Bold' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_bold}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_bold}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_bold}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_bold}.ttf"
  fi
  if [ "${style}" = 'ThinItalic' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_thin_italic}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_thin_italic}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_thin_italic}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_thin_italic}.ttf"
  fi
  if [ "${style}" = 'ExtraLightItalic' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_extralight_italic}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_extralight_italic}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_extralight_italic}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_extralight_italic}.ttf"
  fi
  if [ "${style}" = 'LightItalic' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_light_italic}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_light_italic}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_light_italic}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_light_italic}.ttf"
  fi
  if [ "${style}" = 'Italic' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_regular_italic}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_regular_italic}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_regular_italic}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_regular_italic}.ttf"
  fi
  if [ "${style}" = 'TextItalic' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_text_italic}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_text_italic}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_text_italic}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_text_italic}.ttf"
  fi
  if [ "${style}" = 'MediumItalic' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_medium_italic}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_medium_italic}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_medium_italic}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_medium_italic}.ttf"
  fi
  if [ "${style}" = 'SemiBoldItalic' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_semibold_italic}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_semibold_italic}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_semibold_italic}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_semibold_italic}.ttf"
  fi
  if [ "${style}" = 'BoldItalic' ]; then
    marge_plexjp_regular="${tmpdir}/${modified_plexjp_bold_italic}.ttf"
    marge_plexjp_console_regular="${tmpdir}/${modified_plexjp_console_bold_italic}.ttf"
    marge_plexjp35_regular="${tmpdir}/${modified_plexjp35_bold_italic}.ttf"
    marge_plexjp35_console_regular="${tmpdir}/${modified_plexjp35_console_bold_italic}.ttf"
  fi

  # PlemolJP
  echo "pyftmerge: ${plemoljp_filename}"
  pyftmerge "hinted_${plemoljp_filename}" "$marge_plexjp_regular"
  mv merged.ttf "${plemoljp_filename}"

  # PlemolJP Console
  echo "pyftmerge: ${plemoljp_console_filename}"
  pyftmerge "hinted_${plemoljp_console_filename}" "$marge_plexjp_console_regular"
  mv merged.ttf "${plemoljp_console_filename}"

  # PlemolJP35
  echo "pyftmerge: ${plemoljp35_filename}"
  pyftmerge "hinted_${plemoljp35_filename}" "$marge_plexjp35_regular"
  mv merged.ttf "${plemoljp35_filename}"

  # PlemolJP35 Console
  echo "pyftmerge: ${plemoljp35_console_filename}"
  pyftmerge "hinted_${plemoljp35_console_filename}" "$marge_plexjp35_console_regular"
  mv merged.ttf "${plemoljp35_console_filename}"

done

rm -f hinted_*.ttf

# Remove temporary directory
if [ "${leaving_tmp_flag}" = "false" ]
then
  echo "Remove temporary files"
  rm -rf $tmpdir
fi

# Exit
echo "Succeeded in generating PlemolJP!"
exit 0
