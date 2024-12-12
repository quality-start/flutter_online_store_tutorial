# Flutter プロジェクト コーディング規約

## コーディング規約の多くは Lint で担保

Flutter2.5 から Lint が標準で搭載されるようになりました。Dart 公式で公表されている Lint ルールを設定すれば、if 文の書き方みたいな所で議論することはなくなります。

[Lint の一覧](https://dart-lang.github.io/linter/lints/)をぜひ眺めてみてください。

プロジェクト直下にある `analysis_options.yaml` で Lint のルールを設定できます。

## pedantic_mono Lint Rule

日本人の Flutter エンジニアで、2019 年頃から精力的に Flutter の情報を発信している、[mono さんが使っている Lint の設定](https://github.com/mono0926/pedantic_mono/blob/main/lib/analysis_options.yaml)を採用しています。

mono さんの Twitter: https://github.com/mono0926

## 一部のコード規約抜粋

文法（シンタックス）レベルの話は、全て Dart 公式が提供している Lint ルールに乗っかります。決めの問題で議論しても、有意義なものになりにくいです。

- 変数名・関数名はキャメルケース。スネークケースにすると Warning がでます。
- クラス名は頭大文字のキャメルケース。`CustomerUseCase` という書き方。
- 文字列はシングルクォーテーションで囲う。Dart のコード規約[prefer_single_quoutes](https://dart-lang.github.io/linter/lints/prefer_single_quotes.html)に推奨されているため。

##　コメントについて

Dart でコメントを書く時は、原則 `///`を使ってコメントを書きます。

```dart
/// HttpのRESTでアクセスするためのAPIクラス
/// retrofitで定義したインタフェースを明記する
```

`///`でコメントを書くと、VSCode でクラス名や変数名をマウスで当てた時に、コメント内容が閲覧できるようになっているからです。

**特に、モデルクラスの型定義の箇所は細かくコメントを書きましょう。**

フロントエンドはバックエンドに比べてビジネスロジックを記載する箇所が少ないので、仕様の多くが型定義に記載されるためです。

また、任意のクラスのコメントを組み込みたい場合は、以下のように`[]`でクラス名を括ります。`[Error]`となります。

```dart
/// ビジネスロジックを実行するためのクラス
/// 成功すればT型のインスタンスが返り、エラーが出たら[Error]のインスタンスが返ってくる
```

外部公開する必要のないコメント、及び `FIXME`や`TODO`のようなコメントは、`//`で記載します。

`//TODO(myumoto:) 画面遷移先変更`のような書き方です。
