#!/usr/bin/env python3
"""生成された TTF が fontTools で読めるかを確認する"""

from __future__ import annotations

import sys
from pathlib import Path

from fontTools.ttLib import TTFont


def check_font(path: Path) -> str | None:
    """読めなければエラーメッセージ、問題なければ None を返す"""
    try:
        font = TTFont(path, recalcBBoxes=False, recalcTimestamp=False)
        # 主要テーブルに触れて、壊れたオフセット等を拾う
        _ = font["head"]
        _ = font["name"]
        _ = font["cmap"]
        _ = font["glyf"] if "glyf" in font else font["CFF "]
        font.close()
    except Exception as exc:  # noqa: BLE001 - 壊れたファイルをまとめて報告したい
        return f"{path}: {exc}"
    return None


def main() -> int:
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <font.ttf>...", file=sys.stderr)
        return 2

    errors: list[str] = []
    for arg in sys.argv[1:]:
        path = Path(arg)
        if not path.is_file():
            errors.append(f"{path}: file not found")
            continue
        message = check_font(path)
        if message is not None:
            errors.append(message)

    if errors:
        for message in errors:
            print(f"INVALID: {message}", file=sys.stderr)
        print(
            f"ERROR: {len(errors)} / {len(sys.argv) - 1} ファイルの読込に失敗しました",
            file=sys.stderr,
        )
        return 1

    print(f"readable={len(sys.argv) - 1}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
