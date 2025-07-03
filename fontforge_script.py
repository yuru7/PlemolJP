#!fontforge --lang=py -script

# 2つのフォントを合成する

import configparser
import math
import os
import shutil
import sys
import uuid
from decimal import ROUND_HALF_UP, Decimal

import fontforge
import psMat

# iniファイルを読み込む
settings = configparser.ConfigParser()
settings.read("build.ini", encoding="utf-8")

VERSION = settings.get("DEFAULT", "VERSION")
FONT_NAME = settings.get("DEFAULT", "FONT_NAME")
JP_FONT = settings.get("DEFAULT", "JP_FONT")
ENG_FONT = settings.get("DEFAULT", "ENG_FONT")
HACK_FONT = settings.get("DEFAULT", "HACK_FONT")
SOURCE_FONTS_DIR = settings.get("DEFAULT", "SOURCE_FONTS_DIR")
BUILD_FONTS_DIR = settings.get("DEFAULT", "BUILD_FONTS_DIR")
VENDER_NAME = settings.get("DEFAULT", "VENDER_NAME")
FONTFORGE_PREFIX = settings.get("DEFAULT", "FONTFORGE_PREFIX")
IDEOGRAPHIC_SPACE = settings.get("DEFAULT", "IDEOGRAPHIC_SPACE")
ADJUST_R = settings.get("DEFAULT", "ADJUST_R")
CONSOLE_STR = settings.get("DEFAULT", "CONSOLE_STR")
WIDTH_35_STR = settings.get("DEFAULT", "WIDTH_35_STR")
INVISIBLE_ZENKAKU_SPACE_STR = settings.get("DEFAULT", "INVISIBLE_ZENKAKU_SPACE_STR")
NERD_FONTS_STR = settings.get("DEFAULT", "NERD_FONTS_STR")
EM_ASCENT = int(settings.get("DEFAULT", "EM_ASCENT"))
EM_DESCENT = int(settings.get("DEFAULT", "EM_DESCENT"))
OS2_ASCENT = int(settings.get("DEFAULT", "OS2_ASCENT"))
OS2_DESCENT = int(settings.get("DEFAULT", "OS2_DESCENT"))
HALF_WIDTH_12 = int(settings.get("DEFAULT", "HALF_WIDTH_12"))
FULL_WIDTH_35 = int(settings.get("DEFAULT", "FULL_WIDTH_35"))
ITALIC_ANGLE = int(settings.get("DEFAULT", "ITALIC_ANGLE"))

COPYRIGHT = """[IBM Plex]
Copyright (c) 2017 IBM Corp. https://github.com/IBM/plex

[Hack]
Copyright 2018 Source Foundry Authors https://github.com/source-foundry/Hack

[Nerd Fonts]
Copyright (c) 2014, Ryan L McIntyre https://ryanlmcintyre.com

[PlemolJP]
Copyright (c) 2021, Yuko Otawara
"""  # noqa: E501

options = {}
nerd_font = None


def main():
    # オプション判定
    get_options()
    if options.get("unknown-option"):
        usage()
        return

    # buildディレクトリを作成する
    if os.path.exists(BUILD_FONTS_DIR) and not options.get("do-not-delete-build-dir"):
        shutil.rmtree(BUILD_FONTS_DIR)
        os.mkdir(BUILD_FONTS_DIR)
    if not os.path.exists(BUILD_FONTS_DIR):
        os.mkdir(BUILD_FONTS_DIR)

    generate_font(
        jp_style="Regular",
        eng_style="Regular",
        merged_style="Regular",
    )

    # デバッグモードの場合はここで終了
    if options.get("debug"):
        return

    generate_font(
        jp_style="Bold",
        eng_style="Bold",
        merged_style="Bold",
    )

    generate_font(
        jp_style="Thin",
        eng_style="Thin",
        merged_style="Thin",
    )
    generate_font(
        jp_style="ExtraLight",
        eng_style="ExtraLight",
        merged_style="ExtraLight",
    )
    generate_font(
        jp_style="Light",
        eng_style="Light",
        merged_style="Light",
    )
    generate_font(
        jp_style="Text",
        eng_style="Text",
        merged_style="Text",
    )
    generate_font(
        jp_style="Medium",
        eng_style="Medium",
        merged_style="Medium",
    )
    generate_font(
        jp_style="SemiBold",
        eng_style="SemiBold",
        merged_style="SemiBold",
    )

    generate_font(
        jp_style="Regular",
        eng_style="Italic",
        merged_style="Italic",
    )
    generate_font(
        jp_style="Bold",
        eng_style="BoldItalic",
        merged_style="BoldItalic",
    )
    generate_font(
        jp_style="Thin",
        eng_style="ThinItalic",
        merged_style="ThinItalic",
    )
    generate_font(
        jp_style="ExtraLight",
        eng_style="ExtraLightItalic",
        merged_style="ExtraLightItalic",
    )
    generate_font(
        jp_style="Light",
        eng_style="LightItalic",
        merged_style="LightItalic",
    )
    generate_font(
        jp_style="Text",
        eng_style="TextItalic",
        merged_style="TextItalic",
    )
    generate_font(
        jp_style="Medium",
        eng_style="MediumItalic",
        merged_style="MediumItalic",
    )
    generate_font(
        jp_style="SemiBold",
        eng_style="SemiBoldItalic",
        merged_style="SemiBoldItalic",
    )


def usage():
    print(
        f"Usage: {sys.argv[0]} "
        "[--hidden-zenkaku-space] [--35] [--console] [--nerd-font]"
    )


def get_options():
    """オプションを取得する"""

    global options

    # オプションなしの場合は何もしない
    if len(sys.argv) == 1:
        return

    for arg in sys.argv[1:]:
        # オプション判定
        if arg == "--do-not-delete-build-dir":
            options["do-not-delete-build-dir"] = True
        elif arg == "--debug":
            options["debug"] = True
        elif arg == "--hidden-zenkaku-space":
            options["hidden-zenkaku-space"] = True
        elif arg == "--35":
            options["35"] = True
        elif arg == "--console":
            options["console"] = True
        elif arg == "--nerd-font":
            options["nerd-font"] = True
        elif arg == "--boxhf":
            options["boxhf"] = True
        else:
            options["unknown-option"] = True
            return


def generate_font(jp_style, eng_style, merged_style):
    print(f"=== Generate {merged_style} ===")

    # 合成するフォントを開く
    jp_font, eng_font = open_fonts(jp_style, eng_style)

    # フォントのEMを揃える
    adjust_em(eng_font)

    # Hack フォントをマージする
    merge_hack(jp_font, eng_font, merged_style)

    if options.get("console"):
        # East Asian Ambiguous Width 文字の半角化
        eaaw_width_to_half(jp_font)
        # コンソール用グリフを追加する
        add_console_glyphs(eng_font)

    if not options.get("console"):
        delete_not_console_glyphs(eng_font)

    # 重複するグリフを削除する
    jp_font = delete_duplicate_glyphs(jp_font, eng_font)

    # いくつかのグリフ形状に調整を加える
    adjust_some_glyph(jp_font, eng_font, merged_style)

    # 日本語グリフの斜体を生成する
    if "Italic" in merged_style:
        transform_italic_glyphs(jp_font)

    # 半角幅か全角幅になるように変換する
    set_width_600_or_1000(jp_font)

    if options.get("35"):
        # eng_fontを3:5幅にする
        adjust_width_35_eng(eng_font)
        # jp_fontを3:5幅にする
        adjust_width_35_jp(jp_font)
    else:
        # 1:2 幅にする
        transform_half_width(jp_font, eng_font)
        # 規定の幅からはみ出したグリフサイズを縮小する
        down_scale_redundant_size_glyph(eng_font)

    # GPOSテーブルを削除する
    remove_lookups(jp_font, remove_gsub=False, remove_gpos=True)

    # 罫線を全角にする
    if not options.get("boxhf"):
        if not options.get("console"):
            make_box_drawing_full_width(eng_font, jp_font)

    # 全角スペースを可視化する
    if not options.get("hidden-zenkaku-space"):
        visualize_zenkaku_space(jp_font)

    # Nerd Fontのグリフを追加する
    if options.get("nerd-font"):
        add_nerd_font_glyphs(jp_font, eng_font)

    # オプション毎の修飾子を追加する
    variant = f"{WIDTH_35_STR} " if options.get("35") else ""
    variant += f"{CONSOLE_STR} " if options.get("console") else ""
    variant += (
        INVISIBLE_ZENKAKU_SPACE_STR if options.get("hidden-zenkaku-space") else ""
    )
    variant += NERD_FONTS_STR if options.get("nerd-font") else ""
    variant = variant.strip()

    # macOSでのpostテーブルの使用性エラー対策
    # 重複するグリフ名を持つグリフをリネームする
    delete_glyphs_with_duplicate_glyph_names(eng_font)
    delete_glyphs_with_duplicate_glyph_names(jp_font)

    # メタデータを編集する
    cap_height = int(
        Decimal(str(eng_font[0x0048].boundingBox()[3])).quantize(
            Decimal("0"), ROUND_HALF_UP
        )
    )
    x_height = int(
        Decimal(str(eng_font[0x0078].boundingBox()[3])).quantize(
            Decimal("0"), ROUND_HALF_UP
        )
    )
    edit_meta_data(eng_font, merged_style, variant, cap_height, x_height)
    edit_meta_data(jp_font, merged_style, variant, cap_height, x_height)

    # ttfファイルに保存
    # ヒンティングが残っていると不具合に繋がりがちなので外す。
    # ヒンティングはあとで ttfautohint で行う。
    # flags=("no-hints", "omit-instructions") を使うとヒンティングだけでなく GPOS や GSUB も削除されてしまうので使わない
    font_name = f"{FONT_NAME}{variant}".replace(" ", "")
    eng_font.generate(
        f"{BUILD_FONTS_DIR}/{FONTFORGE_PREFIX}{font_name}-{merged_style}-eng.ttf",
    )
    jp_font.generate(
        f"{BUILD_FONTS_DIR}/{FONTFORGE_PREFIX}{font_name}-{merged_style}-jp.ttf",
    )

    # ttfを閉じる
    jp_font.close()
    eng_font.close()


def open_fonts(jp_style: str, eng_style: str):
    """フォントを開く"""
    jp_font = fontforge.open(
        SOURCE_FONTS_DIR + "/" + JP_FONT.replace("{style}", jp_style)
    )
    eng_font = fontforge.open(
        SOURCE_FONTS_DIR + "/" + ENG_FONT.replace("{style}", eng_style)
    )

    # フォント参照を解除する
    for glyph in jp_font.glyphs():
        if glyph.isWorthOutputting():
            jp_font.selection.select(("more", None), glyph)
    jp_font.unlinkReferences()
    for glyph in eng_font.glyphs():
        if glyph.isWorthOutputting():
            eng_font.selection.select(("more", None), glyph)
    eng_font.unlinkReferences()
    jp_font.selection.none()
    eng_font.selection.none()

    return jp_font, eng_font


def adjust_some_glyph(jp_font, eng_font, style="Regular"):
    """いくつかのグリフ形状に調整を加える"""
    eng_glyph_width = eng_font[0x0020].width
    full_width = jp_font[0x3042].width
    if options.get("35"):
        half_width = eng_glyph_width
    else:
        half_width = int(full_width / 2)

    # クォーテーションの拡大
    eng_font.selection.select(("unicode", None), 0x0060)
    for glyph in eng_font.selection.byGlyphs:
        glyph.transform(psMat.rotate(math.radians(-25)))
        glyph.transform(psMat.scale(1.08, 1.2))
        glyph.transform(psMat.rotate(math.radians(33)))
        glyph.transform(psMat.translate(110, -135))
        glyph.width = eng_glyph_width
    eng_font.selection.select(("unicode", None), 0x0027)
    eng_font.selection.select(("unicode", "more"), 0x0022)
    for glyph in eng_font.selection.byGlyphs:
        glyph.transform(psMat.scale(1.09, 1.06))
        glyph.transform(psMat.translate((eng_glyph_width - glyph.width) / 2, 0))
        glyph.width = eng_glyph_width
    # ; : , . の拡大
    eng_font.selection.select(("unicode", None), 0x003A)
    eng_font.selection.select(("unicode", "more"), 0x003B)
    eng_font.selection.select(("unicode", "more"), 0x002C)
    eng_font.selection.select(("unicode", "more"), 0x002E)
    for glyph in eng_font.selection.byGlyphs:
        glyph.transform(psMat.scale(1.08, 1.08))
        glyph.transform(psMat.translate((eng_glyph_width - glyph.width) / 2, 0))
        glyph.width = eng_glyph_width
    # Eclipse Pleiades 半角スペース記号 (U+1d1c) 対策
    eng_font.selection.select(("unicode", None), 0x054D)
    eng_font.copy()
    eng_font.selection.select(("unicode", None), 0x1D1C)
    eng_font.paste()
    for glyph in eng_font.selection.byGlyphs:
        glyph.transform(psMat.scale(0.85, 0.6))
        glyph.transform(psMat.translate((eng_glyph_width - glyph.width) / 2, 0))
        glyph.width = eng_glyph_width

    # 全角括弧の開きを広くする
    for glyph_name in [0xFF08, 0xFF3B, 0xFF5B]:
        glyph = jp_font[glyph_name]
        glyph.transform(psMat.translate(-180, 0))
        glyph.width = full_width
    for glyph_name in [0xFF09, 0xFF3D, 0xFF5D]:
        glyph = jp_font[glyph_name]
        glyph.transform(psMat.translate(180, 0))
        glyph.width = full_width
    # 全角ピリオド、カンマを拡大する
    for glyph in jp_font.selection.select(("unicode", None), 0xFF0E).byGlyphs:
        glyph.transform(psMat.scale(1.45, 1.45))
        glyph.width = full_width
    for glyph in jp_font.selection.select(("unicode", None), 0xFF0C).byGlyphs:
        glyph.transform(psMat.scale(1.40, 1.40))
        glyph.width = full_width
    # LEFT SINGLE QUOTATION MARK (U+2018) ～ DOUBLE LOW-9 QUOTATION MARK (U+201E) の幅を全角幅にする
    for glyph in jp_font.selection.select(
        ("unicode", "ranges"), 0x2018, 0x2019
    ).byGlyphs:
        glyph.transform(psMat.scale(1.25, 1.25))
        glyph.transform(psMat.translate((full_width - glyph.width) / 2, -150))
        glyph.width = full_width
    for glyph in jp_font.selection.select(
        ("unicode", "ranges"), 0x201C, 0x201D
    ).byGlyphs:
        glyph.transform(psMat.scale(1.25, 1.25))
        glyph.transform(psMat.translate((full_width - glyph.width) / 2, -150))
        glyph.width = full_width

    # Cent Sign, Pound Sign, Yen Sign は半角記号に IBM Plex Sans JP を使用
    jp_font.selection.select(("unicode", None), 0x00A2)
    jp_font.selection.select(("unicode", "more"), 0x00A3)
    jp_font.selection.select(("unicode", "more"), 0x00A5)
    for glyph in jp_font.selection.byGlyphs:
        x_scale = half_width / glyph.width
        if x_scale < 1:
            glyph.transform(psMat.scale(x_scale, 1))
        # 後から英語フォントと同じ幅にするために一旦500幅として扱う
        glyph.transform(psMat.translate((500 - glyph.width) / 2, 0))
        glyph.width = 500

    # r グリフの調整
    if "Italic" not in style:
        eng_font[0x0072].clear()
        eng_font[0x0155].clear()
        eng_font[0x0157].clear()
        eng_font[0x0159].clear()
        eng_font.mergeFonts(f"{SOURCE_FONTS_DIR}/" + ADJUST_R.replace("{style}", style))

    # 矢印記号の読みづらさ対策
    for uni in [*range(0x21CD, 0x21CF + 1), 0x21D0, 0x21D2, 0x21D4, 0x21DA, 0x21DB]:
        eng_font.selection.select(("unicode", None), uni)
        for glyph in eng_font.selection.byGlyphs:
            scale_glyph_from_center(glyph, 1, 1.3)
    for uni in [0x21D1, 0x21D3]:
        eng_font.selection.select(("unicode", None), uni)
        for glyph in eng_font.selection.byGlyphs:
            scale_glyph_from_center(glyph, 1.3, 1)
    for uni in range(0x21D6, 0x21D9 + 1):
        eng_font.selection.select(("unicode", None), uni)
        for glyph in eng_font.selection.byGlyphs:
            scale_glyph_from_center(glyph, 1.3, 1.3)

    # 選択解除
    jp_font.selection.none()
    eng_font.selection.none()


def adjust_em(font):
    """フォントのEMを揃える"""
    font.em = EM_ASCENT + EM_DESCENT


def delete_duplicate_glyphs(jp_font, eng_font):
    """jp_fontとeng_fontのグリフを比較し、重複するグリフを削除する"""

    eng_font.selection.none()
    jp_font.selection.none()

    # IBM Plex Sans JP グリフを使用
    eng_font[0x00A2].clear()  # Cent Sign
    eng_font[0x00A3].clear()  # Pound Sign
    eng_font[0x00A5].clear()  # Yen Sign
    eng_font[0x3000].clear()  # 全角スペース
    # U+274C (CROSS MARK) を削除 (OSに含まれる絵文字フォントにフォールバックさせるため)
    eng_font[0x274C].clear()
    # LATIN 系グリフには IBM Plex Mono を使用
    for glyph in jp_font.glyphs():
        if 0x00C0 <= glyph.unicode <= 0x00D6:
            glyph.clear()
        elif 0x00D8 <= glyph.unicode <= 0x00F6:
            glyph.clear()
        elif 0x00F8 <= glyph.unicode <= 0x0259:
            glyph.clear()

    # 重複グリフを選択する
    for glyph in jp_font.glyphs("encoding"):
        if glyph.isWorthOutputting() and glyph.unicode > 0:
            try:
                eng_font.selection.select(("more", "unicode"), glyph.unicode)
            except ValueError:
                # Encoding is out of range のときは継続する
                continue
        # altuni が設定されている場合は altuni にも選択を拡張する
        if glyph.altuni:
            for u in glyph.altuni:
                try:
                    eng_font.selection.select(("more", "unicode"), u[0])
                except ValueError:
                    # Encoding is out of range のときは継続する
                    continue

    eng_font.selection.select(("more", "unicode"), 0x0301)

    # 削除箇所に altuni が設定されている場合は削除する前にコピーする
    for glyph in eng_font.selection.byGlyphs:
        jp_font.selection.select(("more", "unicode"), glyph.unicode)
    altuni_glyph_list = []
    for glyph in jp_font.selection.byGlyphs:
        if glyph.altuni:
            altuni_glyph_list.append(glyph.unicode)
            for u in glyph.altuni:
                print(f"Copying glyph U+{glyph.unicode:04X} to U+{u[0]:04X}")
    jp_font = materialize_altuni_glyphs(jp_font, altuni_glyph_list)
    jp_font.selection.none()

    # altuni の整理で各グリフの状態が変わった可能性があるので重複グリフを再選択する
    eng_font.selection.none()
    for glyph in jp_font.glyphs("encoding"):
        try:
            if glyph.isWorthOutputting() and glyph.unicode > 0:
                eng_font.selection.select(("more", "unicode"), glyph.unicode)
        except ValueError:
            # Encoding is out of range のときは継続する
            continue

    # 重複するグリフを削除
    for glyph in eng_font.selection.byGlyphs:
        jp_font.selection.select(("more", "unicode"), glyph.unicode)
    for glyph in jp_font.selection.byGlyphs:
        glyph.clear()

    jp_font.selection.none()
    eng_font.selection.none()

    return jp_font


def materialize_altuni_glyphs(font, entity_glyph_unicode_list):
    """altuni を指定している参照元のコードポイントにグリフをコピーし、
    参照先 (実体) の altuni を削除する。異体字セレクタ分はスキップする。
    """

    for unicode in entity_glyph_unicode_list:
        entity_glyph = font[unicode]
        if not entity_glyph.altuni:
            continue

        # 以下形式のタプルで返ってくる
        # (unicode-value, variation-selector, reserved-field)
        # 第3フィールドは常に0なので無視
        altunis = entity_glyph.altuni

        # 参照先の altuni を削除
        # これをやらないと、グリフのコピー時に altuni が参照されてしまい、
        # 同じコードポイントに貼り付いてしまって意味がない
        entity_glyph.altuni = None

        processed = []
        for altuni in altunis:
            if altuni[0] in processed:
                continue
            if altuni[1] != -1:
                # variation-selector が -1 以外の場合は異体字セレクタなのでスキップ
                continue
            processed.append(altuni[0])
            # altuni 参照元に空グリフを作成
            copy_target_unicode = altuni[0]
            try:
                entity_glyph.glyphname = f"uni{entity_glyph.unicode:04X}"
                copied_glyph_name = f"uni{copy_target_unicode:04X}"
                if copied_glyph_name == entity_glyph.glyphname:
                    copied_glyph_name += "copy"
                copy_target_glyph = font.createChar(
                    copy_target_unicode,
                    copied_glyph_name,
                )
            except Exception:
                copy_target_glyph = font[copy_target_unicode]
            copy_target_glyph.width = entity_glyph.width
            # altuni 参照元へグリフをコピー
            font.selection.select(entity_glyph.glyphname)
            font.copy()
            font.selection.select(copy_target_glyph.glyphname)
            font.paste()

    # alt_uni 処理後、エンコーディングがずれるためか一部のグリフの select() がうまくいかなくなるので開き直す
    font_path = f"{BUILD_FONTS_DIR}/{font.fullname}_{uuid.uuid4()}.ttf"
    font.generate(font_path)
    font.close()
    font = fontforge.open(font_path)
    # 一時ファイルを削除
    os.remove(font_path)

    return font


def delete_not_console_glyphs(eng_font):
    eng_font.selection.none()

    # 記号
    eng_font.selection.select(("more", "unicode", "ranges"), 0x00A1, 0x00A5)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x00A7, 0x00AA)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x00AC, 0x00B8)
    eng_font.selection.select(("more", "unicode"), 0x00D7)
    eng_font.selection.select(("more", "unicode"), 0x00F7)
    eng_font.selection.select(("more", "unicode"), 0x0401)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x0410, 0x044F)
    eng_font.selection.select(("more", "unicode"), 0x0451)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x2010, 0x2026)
    eng_font.selection.select(("more", "unicode"), 0x2030)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x2032, 0x2033)
    eng_font.selection.select(("more", "unicode"), 0x203B)
    eng_font.selection.select(("more", "unicode"), 0x203E)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x2113, 0x2122)
    # 矢印
    # TODO: IBM Plex Sans JP v1.002 へバージョンアップすると矢印が拡張される見込みだが、当該バージョンには一部グリフ欠けがあるためさらに上のバージョンが出てきた際に取り込む
    eng_font.selection.select(("more", "unicode", "ranges"), 0x2190, 0x2193)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x21C4, 0x21C6)
    eng_font.selection.select(("more", "unicode"), 0x21D2)
    eng_font.selection.select(("more", "unicode"), 0x21D4)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x21E6, 0x21E9)
    eng_font.selection.select(("more", "unicode"), 0x21F5)

    # 数学記号
    eng_font.selection.select(("more", "unicode"), 0x2200)
    eng_font.selection.select(("more", "unicode"), 0x2202)
    eng_font.selection.select(("more", "unicode"), 0x2211)
    eng_font.selection.select(("more", "unicode"), 0x2219)
    eng_font.selection.select(("more", "unicode"), 0x221A)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x221D, 0x2220)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x2227, 0x222E)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x2234, 0x2235)
    eng_font.selection.select(("more", "unicode"), 0x2252)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x2260, 0x2261)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x2266, 0x2267)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x226A, 0x226B)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x2282, 0x2283)
    eng_font.selection.select(("more", "unicode", "ranges"), 0x2286, 0x2287)

    # 一部 IBMPlexMono ベースにする
    # 各エディタの可視化文字対策
    eng_font.selection.select(("less", "unicode"), 0x2022)
    eng_font.selection.select(("less", "unicode"), 0x00B7)
    eng_font.selection.select(("less", "unicode"), 0x2024)
    eng_font.selection.select(("less", "unicode"), 0x2219)
    eng_font.selection.select(("less", "unicode"), 0x25D8)
    eng_font.selection.select(("less", "unicode"), 0x25E6)

    for glyph in eng_font.selection.byGlyphs:
        glyph.clear()

    eng_font.selection.none()


def remove_lookups(font, remove_gsub=True, remove_gpos=True):
    """GSUB, GPOSテーブルを削除する"""
    if remove_gsub:
        for lookup in font.gsub_lookups:
            font.removeLookup(lookup)
    if remove_gpos:
        for lookup in font.gpos_lookups:
            font.removeLookup(lookup)


def transform_italic_glyphs(font):
    """日本語フォントの斜体を生成する"""
    # 傾きを設定する
    font.italicangle = -ITALIC_ANGLE
    # 全グリフを斜体に変換
    for glyph in font.glyphs():
        orig_width = glyph.width
        glyph.transform(psMat.skew(ITALIC_ANGLE * math.pi / 180))
        glyph.transform(psMat.translate(-40, 0))
        glyph.width = orig_width


def set_width_600_or_1000(jp_font):
    """半角幅か全角幅になるように変換する"""
    for glyph in jp_font.glyphs():
        if 0 < glyph.width < 500:
            # グリフ位置を調整してから幅を設定
            glyph.transform(psMat.translate((500 - glyph.width) / 2, 0))
            glyph.width = 500
        elif (
            500 < glyph.width < 1000 or 0xC0 <= glyph.unicode <= 0x192
        ):  # 特定のアルファベット関連文字 0xC0 - 0x192 は全角幅にする
            # グリフ位置を調整してから幅を設定
            glyph.transform(psMat.translate((1000 - glyph.width) / 2, 0))
            glyph.width = 1000

        # 500幅の場合は一旦 600 幅にする
        if glyph.width == 500:
            glyph.transform(psMat.translate((600 - glyph.width) / 2, 0))
            glyph.width = 600

        # なぜか標準の幅ではないグリフの個別調整
        if glyph.unicode == 0x51F0:
            glyph.transform(psMat.translate((1000 - glyph.width) / 2, 0))
            glyph.width = 1000
        if glyph.glyphname == "perthousand.full":
            glyph.width = 1000


def adjust_width_35_eng(eng_font):
    """英語フォントを半角3:全角5幅になるように変換する"""
    original_half_width = eng_font[0x0030].width
    after_width = int(FULL_WIDTH_35 * 3 / 5)
    x_scale = after_width / original_half_width
    for glyph in eng_font.glyphs():
        if 0 < glyph.width < after_width:
            # after_width より幅が狭い場合は位置合わせしてから幅を設定
            glyph.transform(psMat.translate((after_width - glyph.width) / 2, 0))
            glyph.width = after_width
        elif after_width < glyph.width <= original_half_width:
            # after_width より幅が広い、かつ元の半角幅より狭い場合は縮小してから幅を設定
            glyph.transform(psMat.scale(x_scale, 1))
            glyph.width = after_width
        elif original_half_width < glyph.width:
            # after_width より幅が広い (おそらく全てリガチャ) の場合は倍数にする
            multiply_number = round(glyph.width / original_half_width)
            glyph.transform(psMat.scale(x_scale, 1))
            glyph.width = after_width * multiply_number


def adjust_width_35_jp(jp_font):
    """日本語フォントを半角3:全角5幅になるように変換する"""
    after_width = int(FULL_WIDTH_35 * 3 / 5)
    jp_half_width = jp_font[0x3000].width / 2
    jp_full_width = jp_font[0x3000].width
    for glyph in jp_font.glyphs():
        if glyph.width == jp_half_width:
            glyph.transform(psMat.translate((after_width - glyph.width) / 2, 0))
            glyph.width = after_width
        elif glyph.width == jp_full_width:
            glyph.transform(psMat.translate((FULL_WIDTH_35 - glyph.width) / 2, 0))
            glyph.width = FULL_WIDTH_35


def transform_half_width(jp_font, eng_font):
    """1:2幅になるように変換する"""
    before_width_eng = eng_font[0x0030].width
    after_width_eng = HALF_WIDTH_12
    # 単純な 縮小後幅 / 元の幅 だと狭くなりすりぎるので、
    # 倍率を考慮して分子は大きめにしている
    x_scale = 546 / before_width_eng
    for glyph in eng_font.glyphs():
        if glyph.width > 0:
            # リガチャ考慮
            after_width_eng_multiply = after_width_eng * round(
                glyph.width / before_width_eng
            )
            # 縮小
            glyph.transform(psMat.scale(x_scale, 0.97))
            # 幅を設定
            glyph.transform(
                psMat.translate((after_width_eng_multiply - glyph.width) / 2, 0)
            )
            glyph.width = after_width_eng_multiply

    for glyph in jp_font.glyphs():
        if glyph.width == 600:
            # 英数字グリフと同じ幅にする
            glyph.transform(psMat.translate((after_width_eng - glyph.width) / 2, 0))
            glyph.width = after_width_eng
        elif glyph.width == 1000:
            # 全角は after_width_eng の倍の幅にする
            glyph.transform(psMat.translate((after_width_eng * 2 - glyph.width) / 2, 0))
            glyph.width = after_width_eng * 2


def make_box_drawing_full_width(eng_font, jp_font):
    """罫線を全角にする"""
    # 英語フォント側は完全に削除
    eng_font.selection.select(("unicode", "ranges"), 0x2500, 0x257F)
    for glyph in eng_font.selection.byGlyphs:
        glyph.clear()
    eng_font.selection.none()
    # 日本語フォント側は削除してから全角用グリフをマージする
    jp_font.selection.select(("unicode", "ranges"), 0x2500, 0x257F)
    for glyph in jp_font.selection.byGlyphs:
        glyph.clear()
    jp_font.selection.none()
    jp_font.mergeFonts(fontforge.open(f"{SOURCE_FONTS_DIR}/FullWidthBoxDrawings.sfd"))
    # 幅設定と位置調整
    width_to = jp_font[0x3042].width
    jp_font.selection.select(("unicode", "ranges"), 0x2500, 0x257F)
    for glyph in jp_font.selection.byGlyphs:
        # 幅が調整前より広がる場合は拡大する
        width_from = glyph.width
        if width_from < width_to:
            glyph.transform(psMat.scale(width_to / width_from, 1))
        width_from = glyph.width
        glyph.transform(psMat.translate((width_to - width_from) / 2, 0))
        glyph.width = width_to
    jp_font.selection.none()


def visualize_zenkaku_space(jp_font):
    """全角スペースを可視化する"""
    # 全角スペースを差し替え
    glyph = jp_font[0x3000]
    width_to = glyph.width
    glyph.clear()
    jp_font.mergeFonts(fontforge.open(f"{SOURCE_FONTS_DIR}/{IDEOGRAPHIC_SPACE}"))
    # 幅を設定し位置調整
    jp_font.selection.select("U+3000")
    for glyph in jp_font.selection.byGlyphs:
        width_from = glyph.width
        glyph.transform(psMat.translate((width_to - width_from) / 2, 0))
        glyph.width = width_to
    jp_font.selection.none()


def merge_hack(jp_font, eng_font, style):
    """Hack フォントをマージする"""
    if "Bold" in style:
        hack_font = fontforge.open(
            f"{SOURCE_FONTS_DIR}/" + HACK_FONT.replace("{style}", "Bold")
        )
    else:
        hack_font = fontforge.open(
            f"{SOURCE_FONTS_DIR}/" + HACK_FONT.replace("{style}", "Regular")
        )
    hack_font.em = EM_ASCENT + EM_DESCENT
    # 既に英語フォント側に存在する場合はhackグリフは削除する
    for glyph in eng_font.glyphs():
        if glyph.unicode != -1:
            try:
                for g in hack_font.selection.select(
                    ("unicode", None), glyph.unicode
                ).byGlyphs:
                    g.clear()
            except Exception:
                pass
    if options.get("console"):
        # Console版では、日本語フォントよりhackフォントのグリフを優先する
        for glyph in hack_font.glyphs():
            if glyph.unicode != -1:
                try:
                    for g in jp_font.selection.select(
                        ("unicode", None), glyph.unicode
                    ).byGlyphs:
                        g.clear()
                except Exception:
                    pass
    else:
        # 既に日本語フォント側に存在する場合はhackグリフは削除する
        for glyph in jp_font.glyphs():
            if glyph.unicode != -1:
                try:
                    for g in hack_font.selection.select(
                        ("unicode", None), glyph.unicode
                    ).byGlyphs:
                        g.clear()
                except Exception:
                    pass
    # EM 1000 にしたときの幅に合わせて調整
    half_width = int(FULL_WIDTH_35 * 3 / 5)
    for glyph in hack_font.glyphs():
        if glyph.width > 0:
            glyph.transform(psMat.translate((half_width - glyph.width) / 2, 0))
            glyph.width = half_width
    # Hack フォントをオブジェクトとして扱いたくないので、一旦ファイル保存して直接マージする
    font_path = f"{BUILD_FONTS_DIR}/tmp_hack_{uuid.uuid4()}.ttf"
    hack_font.generate(font_path)
    hack_font.close()

    eng_font.mergeFonts(font_path)
    os.remove(font_path)


def eaaw_width_to_half(jp_font):
    """East Asian Ambiguous Width 文字の半角化"""
    # ref: https://www.unicode.org/Public/15.1.0/ucd/EastAsianWidth.txt

    eaaw_unicode_list = (
        0x203B,  # REFERENCE MARK
        0x2103,
        0x2109,
        0x2121,
        0x212B,
        *range(0x2160, 0x216B + 1),
        *range(0x2170, 0x217B + 1),
        0x221F,
        0x222E,
        *range(0x226A, 0x226B + 1),
        0x22A5,
        0x22BF,
        0x2312,
        *range(0x2460, 0x2490 + 1),
        *range(0x249C, 0x24B5 + 1),
        *range(0x2605, 0x2606 + 1),
        0x260E,
        0x261C,
        0x261E,
        0x2640,
        0x2642,
        *range(0x2660, 0x2665 + 1),
        0x2667,
        0x266A,
        0x266D,
        0x266F,
        0x1F100,
    )
    half_width = 500
    for glyph in jp_font.glyphs():
        if glyph.unicode in eaaw_unicode_list and glyph.width > half_width:
            glyph.transform(psMat.scale(0.67, 0.9))
            glyph.transform(psMat.translate((half_width - glyph.width) / 2, 0))
            glyph.width = half_width


def add_console_glyphs(eng_font):
    eng_width = eng_font[0x0030].width

    # HEAVY CHECK MARK (U+2714) を追加
    # この記号は Docker コマンドなどで使用されている
    eng_font.selection.select(("unicode", None), 0x2713)
    eng_font.copy()
    eng_font.selection.select(("unicode", None), 0x2714)
    eng_font.paste()
    for glyph in eng_font.selection.byGlyphs:
        glyph.stroke("circular", 35, removeinternal=True)
        glyph.width = eng_width

    eng_font.selection.none()


def scale_glyph_from_center(glyph, scale_x, scale_y):
    """グリフの中心位置を基点としたスケール調整"""
    original_width = glyph.width
    # スケール前の中心位置を求める
    before_bb = glyph.boundingBox()
    before_center_x = (before_bb[0] + before_bb[2]) / 2
    before_center_y = (before_bb[1] + before_bb[3]) / 2
    # スケール変換
    glyph.transform(psMat.scale(scale_x, scale_y))
    # スケール後の中心位置を求める
    after_bb = glyph.boundingBox()
    after_center_x = (after_bb[0] + after_bb[2]) / 2
    after_center_y = (after_bb[1] + after_bb[3]) / 2
    # 拡大で増えた分を考慮して中心位置を調整
    glyph.transform(
        psMat.translate(
            before_center_x - after_center_x,
            before_center_y - after_center_y,
        )
    )
    glyph.width = original_width


def down_scale_redundant_size_glyph(eng_font):
    """規定の幅からはみ出したグリフサイズを縮小する"""

    for glyph in eng_font.glyphs():
        xmin = glyph.boundingBox()[0]
        xmax = glyph.boundingBox()[2]

        if (
            glyph.width > 0
            and -15
            < xmin
            < 0  # 特定幅より左にはみ出している場合、意図的にはみ出しているものと見なして無視
            and abs(xmin) - 10
            < xmax - glyph.width
            < abs(xmin) + 10  # はみ出し幅が左側と右側で極端に異なる場合は無視
            and not (
                0x0020 <= glyph.unicode <= 0x02AF
            )  # latin 系のグリフ 0x0020 - 0x0192 は無視
            and not (
                0xE0B0 <= glyph.unicode <= 0xE0D4
            )  # Powerline系のグリフ 0xE0B0 - 0xE0D4 は無視
            and not (
                0x2500 <= glyph.unicode <= 0x257F
            )  # 罫線系のグリフ 0x2500 - 0x257F は無視
            and not (
                0x2591 <= glyph.unicode <= 0x2593
            )  # SHADE グリフ 0x2591 - 0x2593 は無視
        ):
            scale_glyph_from_center(glyph, 1 + (xmin / glyph.width) * 2, 1)


def add_nerd_font_glyphs(jp_font, eng_font):
    """Nerd Fontのグリフを追加する"""
    global nerd_font
    # Nerd Fontのグリフを追加する
    if nerd_font is None:
        nerd_font = fontforge.open(
            f"{SOURCE_FONTS_DIR}/nerd-fonts/SymbolsNerdFont-Regular.ttf"
        )
        nerd_font.em = EM_ASCENT + EM_DESCENT
        glyph_names = set()
        for nerd_glyph in nerd_font.glyphs():
            # Nerd Fontsのグリフ名をユニークにするため接尾辞を付ける
            nerd_glyph.glyphname = f"{nerd_glyph.glyphname}-nf"
            # postテーブルでのグリフ名重複対策
            # fonttools merge で合成した後、MacOSで `'post'テーブルの使用性` エラーが発生することへの対処
            if nerd_glyph.glyphname in glyph_names:
                nerd_glyph.glyphname = f"{nerd_glyph.glyphname}-{nerd_glyph.encoding}"
            glyph_names.add(nerd_glyph.glyphname)
            # 幅を調整する
            half_width = eng_font[0x0030].width
            # Powerline Symbols の調整
            if 0xE0B0 <= nerd_glyph.unicode <= 0xE0D7:
                # 位置と幅合わせ
                if nerd_glyph.width < half_width:
                    nerd_glyph.transform(
                        psMat.translate((half_width - nerd_glyph.width) / 2, 0)
                    )
                elif nerd_glyph.width > half_width:
                    nerd_glyph.transform(psMat.scale(half_width / nerd_glyph.width, 1))
                # グリフの高さ・位置を調整する
                nerd_glyph.transform(psMat.scale(1, 1.14))
                nerd_glyph.transform(psMat.translate(0, 21))
            elif nerd_glyph.width < (EM_ASCENT + EM_DESCENT) * 0.6:
                # 幅が狭いグリフは中央寄せとみなして調整する
                nerd_glyph.transform(
                    psMat.translate((half_width - nerd_glyph.width) / 2, 0)
                )
            # 幅を設定
            nerd_glyph.width = half_width
    # 日本語フォントにマージするため、既に存在する場合は削除する
    for nerd_glyph in nerd_font.glyphs():
        if nerd_glyph.unicode != -1:
            # 既に存在する場合は削除する
            try:
                for glyph in jp_font.selection.select(
                    ("unicode", None), nerd_glyph.unicode
                ).byGlyphs:
                    glyph.clear()
            except Exception:
                pass
            try:
                for glyph in eng_font.selection.select(
                    ("unicode", None), nerd_glyph.unicode
                ).byGlyphs:
                    glyph.clear()
            except Exception:
                pass

    jp_font.mergeFonts(nerd_font)

    jp_font.selection.none()
    eng_font.selection.none()


def delete_glyphs_with_duplicate_glyph_names(font):
    """重複するグリフ名を持つグリフをリネームする"""
    glyph_name_set = set()
    for glyph in font.glyphs():
        if glyph.glyphname in glyph_name_set:
            glyph.glyphname = f"{glyph.glyphname}_{glyph.encoding}"
        else:
            glyph_name_set.add(glyph.glyphname)


def edit_meta_data(font, weight: str, variant: str, cap_height: int, x_height: int):
    """フォント内のメタデータを編集する"""
    font.ascent = EM_ASCENT
    font.descent = EM_DESCENT

    if WIDTH_35_STR in variant and not options.get("nerd-font"):
        os2_ascent = OS2_ASCENT + 60
        os2_descent = OS2_DESCENT + 60
    else:
        os2_ascent = OS2_ASCENT
        os2_descent = OS2_DESCENT

    font.os2_winascent = os2_ascent
    font.os2_windescent = os2_descent

    font.os2_typoascent = os2_ascent
    font.os2_typodescent = -os2_descent
    font.os2_typolinegap = 0

    font.hhea_ascent = os2_ascent
    font.hhea_descent = -os2_descent
    font.hhea_linegap = 0

    font.os2_xheight = x_height
    font.os2_capheight = cap_height

    # VSCode のターミナル上のボトム位置の表示で g, j などが見切れる問題への対処
    # 水平ベーステーブルを削除
    font.horizontalBaseline = None

    if "Regular" == weight or "Italic" == weight:
        font.os2_weight = 400
    elif "Thin" in weight:
        font.os2_weight = 100
    elif "ExtraLight" in weight:
        font.os2_weight = 200
    elif "Light" in weight:
        font.os2_weight = 300
    elif "Text" in weight:
        font.os2_weight = 450
    elif "Medium" in weight:
        font.os2_weight = 500
    elif "SemiBold" in weight:
        font.os2_weight = 600
    elif "Bold" in weight:
        font.os2_weight = 700

    font.os2_vendor = VENDER_NAME

    font.sfnt_names = (
        (
            "English (US)",
            "License",
            """This Font Software is licensed under the SIL Open Font License,
Version 1.1. This license is available with a FAQ
at: http://scripts.sil.org/OFL""",
        ),
        ("English (US)", "License URL", "http://scripts.sil.org/OFL"),
        ("English (US)", "Version", VERSION),
        ("English (US)", "Copyright", COPYRIGHT),
    )

    # フォント名を設定する
    if (
        "Regular" == weight
        or "Italic" == weight
        or "Bold" == weight
        or "BoldItalic" == weight
    ):
        font_family = FONT_NAME
        if variant != "":
            font_family += f" {variant}".replace(" 35", "35")
        font_weight = weight
        if weight == "BoldItalic":
            font_weight = font_weight.replace("Italic", " Italic")
        font.familyname = font_family
        # フォントサブファミリー名
        font.appendSFNTName(0x409, 2, font_weight)
        font.fontname = f"{font_family}-{font_weight}".replace(" ", "")
        font.fullname = f"{font_family} {font_weight}"
        font.weight = font_weight.split(" ")[0]
    else:
        font_family = FONT_NAME
        if variant != "":
            font_family += f" {variant}".replace(" 35", "35")
        font_weight = weight
        if "Italic" in weight:
            font_weight = font_weight.replace("Italic", " Italic")
        font.familyname = f"{font_family} " + font_weight.split(" ")[0]
        # フォントサブファミリー名
        if "Italic" in weight:
            font.appendSFNTName(0x409, 2, "Italic")
        else:
            font.appendSFNTName(0x409, 2, "Regular")
        font.fontname = f"{font_family}-{font_weight}".replace(" ", "")
        font.fullname = f"{font_family} {font_weight}"
        font.weight = font_weight.split(" ")[0]
        # 優先フォントファミリー名
        font.appendSFNTName(0x409, 16, font_family)
        # 優先フォントスタイル
        font.appendSFNTName(0x409, 17, font_weight)


if __name__ == "__main__":
    main()
