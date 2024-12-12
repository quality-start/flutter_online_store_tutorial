# Flutter 環境構築

- Flutter のセットアップは Mac を前提としています。Windows の場合は別途ご案内します。
- `homebrew`や、`VSCode` などのツールはインストールされている前提でのご案内です。インストールが終わってない場合、先にインストールしてください。

## 必要なIDE
下記のIDEの最新バージョンをインストールしてください。
- Visual Studio Code
- Android Studio
- XCode

## テスト用デバイス設置
- Android Studio設置後テスト用の`Emulator`をダウンロードして実行ができるか確認してください。
- XCode設置後テスト用の`Simulator`をダウンロードして実行ができるか確認してください。

## brewのダウンロード
下記のリンクでbrewをインストールしてください。

https://brew.sh/index_ja

## asdf のセットアップ

Flutter はバージョンアップが非常に速いフレームワークです。[Flutter Release Note](https://docs.flutter.dev/development/tools/sdk/releases?tab=macos "タイトル")を見てもらえれば、2 週間に 1 回ぐらいマイナーバージョンアップが走ることが多いです。次回リリースで Flutter のコアのバージョンアップを含めてリリースする、とてもよくある話です。

プロジェクト単位で Flutter のバージョンを切り替えられるような仕組みが必要で、[asdf](https://asdf-vm.com)というライブラリを使います。PHP における`phpenv`、Python における `pyenv` のように、プロジェクト単位で実行するソフトウェアのバージョンを切り替えることができるものです。

```bash
$ brew install asdf
$ echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc
$ asdf # コマンドが認識できたらOK
```

以上で、asdf のインストールは完了です。

## .tool-versions ファイルについて

プロジェクトのルートフォルダに、`.tool-versions` というファイルがあります。これは、`asdf`でインストールする内容をまとめたもので、プロジェクト単位任意のバージョンを指定できます。

`.tool-versions` を使用している場合、 `asdf install` とターミナルで打てば、指定されたバージョンがインストールできます。

`flutter doctor` コマンドで、指定されたバージョンが入っていることを確認してください。

以上で、Flutter のセットアップは完了です。
