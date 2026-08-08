# PlemolJP (プレモル ジェイピー)

***Ple***x ***Mo***no ***L***anguage ***JP***

IBM Plex Mono と IBM Plex Sans JP を合成した日本語プログラミングフォント PlemolJP (プレモル ジェイピー)

**ダウンロードはこちら ➡ [Releases](https://github.com/yuru7/PlemolJP/releases/latest)**

> 💡 [Homebrew (Mac) でのインストール方法](doc/install_via_homebrew.md)

![image](https://github.com/yuru7/PlemolJP/raw/images/beer.jpg)

PlemolJP では合成元の [IBM Plex Mono](https://github.com/IBM/plex) シリーズと同様に、ノーマル・イタリックの両スタイルに対応しました。また、各スタイルごとに8種のウェイト (Thin~Bold) をご用意しています。  

さらに日本語環境でのプログラミングでつまずきがちな全角スペースの誤入力に気づけるよう、全角スペースを可視化する修正を加えています。  

> 💡 全角スペースの可視化が不要な場合は、リリースの Assets より `PlemolJP_HS_vx.x.x.zip` の名前形式になっている zip ファイルを選択してください。(HS: Hidden Space)

> 💡 Powerline 記号等が含まれる Nerd Fonts 対応版は、リリースの Assets より `PlemolJP_NF_vx.x.x.zip` の名前形式になっている zip ファイルを選択してください。(NF: Nerd Fonts)

|**フォント ファミリー**|**説明**|
|:------------:|:---|
|**PlemolJP**|文字幅比率「半角1:全角2」の通常版の PlemolJP。主にASCIIコードの英数字記号に IBM Plex Mono の字体を使い、その他の日本語文字や記号類に IBM Plex Sans JP を使っている。|
|**PlemolJP Console**|IBM Plex Mono の字体を除外せずに全て適用したフォントファミリー。矢印記号などの多くの記号が半角で表示されるため、コンソールでの利用や記号類は可能な限り半角で表示したい人にオススメ。|
|**PlemolJP35**|通常版の PlemolJP の文字幅比率を「半角3:全角5」にしたフォントファミリー。英数字が通常版の PlemolJP よりも大きく表示される。日本語が少ない文書やコードの場合にはこちらの方が読みやすいと感じるかもしれない。|
|**PlemolJP35 Console**|PlemolJP Console の文字幅比率を 半角3:全角5 にしたフォントファミリー|

> 💡 その他、公開中のプログラミングフォント
> - 日本語文字に源柔ゴシック、英数字部分に Hack を使った [**白源 (はくげん／HackGen)**](https://github.com/yuru7/HackGen)
> - 日本語文字に源真ゴシック、英数字部分に Fira Mono を使った [**Firge (ファージ)**](https://github.com/yuru7/Firge)
> - 日本語文字にBIZ UDゴシック、英数字部分に JetBrains Mono を使った [**UDEV Gothic**](https://github.com/yuru7/udev-gothic)

|Thin|ExtraLight|Light|Regular|
|:---:|:---:|:---:|:---:|
|![Thin](https://user-images.githubusercontent.com/13458509/133928702-21f1f391-e83a-4825-9059-36cf3d35f6f7.png)|![ExtraLight](https://user-images.githubusercontent.com/13458509/133928717-f5e17c66-b4e1-47fe-950f-ca3bc574a874.png)|![Light](https://user-images.githubusercontent.com/13458509/133928734-3ca98395-97b9-417b-96a1-ef83f614739a.png)|![Regular](https://user-images.githubusercontent.com/13458509/133928745-fe85ba2e-0d5e-406c-9d23-c832e11bc7b4.png)|

|Text|Medium|SemiBold|Bold|
|:---:|:---:|:---:|:---:|
|![Text](https://user-images.githubusercontent.com/13458509/133928757-af5b6b82-5e1f-41bb-a925-f03769bdad00.png)|![Medium](https://user-images.githubusercontent.com/13458509/133928766-a4b22651-cc1c-48d7-b729-15a6a4070f44.png)|![SemiBold](https://user-images.githubusercontent.com/13458509/133928774-d8467d02-c301-4bef-84e5-1702f9f9645d.png)|![Bold](https://user-images.githubusercontent.com/13458509/133928784-7cc5f571-1161-41de-81b8-b97573e3f524.png)|

## ビルド

[HOW_TO_BUILD.md](./HOW_TO_BUILD.md) 参考
