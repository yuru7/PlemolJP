# フォントのビルド手順

## Docker を使ってビルド

Docker を使って PlemolJP をビルドする手順です。

ビルド環境は、公開イメージ [`ghcr.io/yuru7/composite-font-builder`](https://github.com/yuru7/composite-font-builder/pkgs/container/composite-font-builder) を使います。`make.sh` やソースフォントなどプロジェクト固有のファイルは、実行時にリポジトリをマウントして渡します。

### 必要なもの

- [Docker](https://docs.docker.com/get-docker/)

ソースフォント（IBM Plex Mono / Sans JP など）は本プロジェクトの `source/` に含まれている前提です。

### フォントを生成する

リポジトリのルートで実行します。初回はイメージの取得が行われ、コンテナ起動時に `./make.sh` が走ります。

```bash
docker run --rm -v "$(pwd):/work" ghcr.io/yuru7/composite-font-builder
```

生成された TTF はホスト側の `./build/` に出力されます。完了まで数分かかります。

他の合成フォントリポジトリでも、同じイメージを使い、そのリポジトリのルートで同様に `docker run` すればビルドできます（そのリポジトリに実行可能な `make.sh` がある前提です）。

### 出力について

`make.sh` は最大 4 並列で、通常版・35 幅版・Console・HS・Nerd Fonts など各バリアントをビルドします。

```
build/PlemolJP*.ttf
```

## Docker を使わない場合（参考）

### Linux

Ubuntu 24.04 系では、おおむね次のパッケージが必要です。

```bash
sudo apt-get update
sudo apt-get install -y fontforge python3 python3-fontforge python3-pip ttfautohint
python3 -m pip install --break-system-packages fonttools ttfautohint-py
./make.sh
```

依存パッケージの定義は [composite-font-builder](https://github.com/yuru7/composite-font-builder) を参照してください。

### Windows

従来どおり PowerShell から実行できます（FontForge Builds と Python 3 がインストールされていることが前提です）。

```powershell
.\make.ps1
```

こちらは全バリアントを並列ビルドし、`release_files/` 以下に整理して出力します。
