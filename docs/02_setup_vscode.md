# VSCode for Flutter 開発 環境構築

## VSCode のセットアップ

基本的には、`.vscode` フォルダを `git` 管理するだけで全員同じになりますが、各々のファイルの意味や用途などを記載しておきます。

```
.vscode/
├── extensions.json
├── freezed.code-snippets
├── launch.json
└── settings.json
```

- extensions.json
  - VSCode の拡張機能を入れたもの。シンタックスハイライトやスペルチェッカー、VSCode の Flutter プラグインなど。
- freezed.code-snippets
  - Flutter でよく使う `freezed` というライブラリでコードを生成する時に便利なスニペット。
  - VSCode は `xxx.code-snippets` 形式でコードスニペットを定義することができる。
- launch.json
  - シミュレーターや実機で、Flutter アプリを起動するための設定ファイル。
- settings.json
  - Flutter 開発に必要なルールを全部まとめたもの。コード規約の半分以上はこれで担保できます。
  - ファイルを変更して保存した時に、指定されたフォーマッター及び Lint に基づいてコードが保存されるようになっています。
