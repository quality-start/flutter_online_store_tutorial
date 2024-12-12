# 開発・検証・本番の環境分け

アプリの場合で切り分けないといけないのは、大きく以下の項目です。

- アイコン(分けたほうが分かりやすい)
- アプリ ID
- アプリ名
- エンドポイント等の認証先
- Firebase を始めとした外部サービスの接続・認証情報

## 環境の切り分けはコマンドライン引数で行う

環境の切り分けは、コマンドライン引数 `dart-defines-from-file` を使います。

Flutter3.7 から導入されたコマンドライン引数で、以下のようにコマンドを打つと環境を切り分けることができます。[【Flutter 3.7 以上】Dart-define-from-file を使って開発環境と本番環境を分ける](https://zenn.dev/altiveinc/articles/separating-environments-in-flutter)に詳細があります。

コマンドライン引数でどう分けるかは、下記の具体的なコマンドを参照して頂ければ。

```bash
$ flutter build ios --dart-define-from-file=dart_defines/dev.json # 開発
$ flutter build ios --dart-define-from-file=dart_defines/stg.json　# 検証
$ flutter build ios --dart-define-from-file=dart_defines/prod.json  # 本番
```

`--dart-define-from-file` の引数にファイル名を指定すると、そのキー名で環境変数が自動生成されます。

```json
{
  "flavor": "stg",
  "appName": "FAT stg",
  "APP_ID_SUFFIX": ".dev"
}
```

上記の JSON であれば、 `flavor`、 `appName`、 `APP_ID_SUFFIX` という環境変数が作られます。環境変数、筆者は全部大文字のスネークケースが好きです。`GOOGLE_APPLICATION_CREDENTIAL` という格好です。

### dart-defines で定義した環境変数をコードで参照する

`String.fromEnvironment('flavor')` と書けば参照することができます。当然、大文字小文字は区別されます。取れない場合は空文字が返ります。

### Flavor クラス

環境変数で分けた環境を 1 つにクラスにまとめたほうが見通しが良いので、まとめています。
`src/environment/flavor.dart` を参照してください。
