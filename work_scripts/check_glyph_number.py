# フォントファイルに格納されているグリフ数を調べるスクリプト

import argparse
import pathlib
import sys
from typing import List, Optional

import fontforge

# サポートするフォント拡張子
SUPPORTED_EXTS = {".ttf", ".otf", ".sfd"}


def find_font_files(
    paths: List[pathlib.Path], recursive: bool = False
) -> List[pathlib.Path]:
    """与えられたパスのリストからフォントファイルを集める。

    Args:
        paths: CLI で渡された path のリスト。
        recursive: ディレクトリを再帰的に探索するかどうか。

    Returns:
        フォントファイルの pathlib.Path リスト。
    """
    font_files: List[pathlib.Path] = []
    for p in paths:
        if p.is_file() and p.suffix.lower() in SUPPORTED_EXTS:
            font_files.append(p)
        elif p.is_dir():
            if recursive:
                font_files.extend(
                    child
                    for child in p.rglob("*")
                    if child.is_file() and child.suffix.lower() in SUPPORTED_EXTS
                )
            else:
                font_files.extend(
                    child
                    for child in p.glob("*")
                    if child.is_file() and child.suffix.lower() in SUPPORTED_EXTS
                )
        else:
            # 不明なパスは無視
            continue
    return font_files


def count_glyphs(font_path: pathlib.Path) -> Optional[int]:
    """FontForge を用いてフォントのグリフ数を数える。失敗したら None を返す。"""
    try:
        font = fontforge.open(str(font_path))
        # len() が無いので別の処理
        glyph_count = 0
        for _ in font.glyphs():
            glyph_count += 1
        font.close()
        return glyph_count
    except Exception as e:  # noqa: BLE001
        print(f"[ERROR] {font_path}: {e}", file=sys.stderr)
        return None


def main() -> None:
    parser = argparse.ArgumentParser(
        description="フォントファイルに格納されているグリフ数を表示します。",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "paths",
        nargs="+",
        type=pathlib.Path,
        help="フォントファイルまたはフォントファイルを含むディレクトリのパス",
    )
    parser.add_argument(
        "-r",
        "--recursive",
        action="store_true",
        help="ディレクトリを再帰的に探索する",
    )
    args = parser.parse_args()

    files = find_font_files(args.paths, recursive=args.recursive)
    if not files:
        print(
            "指定されたパスに対象フォントファイルが見つかりませんでした。",
            file=sys.stderr,
        )
        sys.exit(1)

    exit_status = 0
    for f in sorted(files):
        glyphs = count_glyphs(f)
        if glyphs is None:
            exit_status = 1
            continue
        print(f"{str(f)} : {glyphs}")

    sys.exit(exit_status)


if __name__ == "__main__":
    main()
