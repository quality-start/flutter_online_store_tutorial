# Freezed とは

[freezed](https://pub.dev/packages/freezed)は、様々な機能を自分が定義したクラスに付与してくれる、コード生成ライブラリです。Remi さんが作成したライブラリです。

- `copyWith`メソッドの生成。これにより、既存のオブジェクトの一部だけを書き換えた新しいオブジェクトを返すことができる
- `fromJson`メソッドの生成。JSON データからオブジェクトを生成する時に利用します。
- `when`によるパターンマッチ機能の追加。Dart2 系にはパターンマッチがなく、`freezed`の手を借りて実現します。

## イミュータブルなフロントエンド

宣言型 UI を採用しているフロントエンドのフレームワークを使うと、イミュータブルなデータを扱うことを推奨されます。コンストラクタで初期化されたあと、その後変更できないようなデータのことをイミュータブル(immutable)と言います。

下記のようなクラスがイミュータブルな状態です。簡単に言えばフィールドが全部`final`になっているクラスです。Flutter の Widget は(全部確認できていませんが)、全てと言っていいほど、クラスのフィールドやメソッドに`final`がついています。

```dart
class User {
  User({required this.name, required this.kana});
  final String name;
  final String kana;
}
```

以下のようなコードを書くとコンパイルが通りません。`final`なので再代入ができないためです。

```dart
var u = User(name: "eee", kana:"eee");
print(u);
u.name = "bbb"; // The setter 'name' isn't defined for the class because it's final
```

`User`を更新する画面(プロフィールの編集など）があった場合、どうやって新しい値に更新するのか。オブジェクトそのものを作り直します。以下のようなコードです。

```dart
  var u = User(name: "eee", kana:"eee");
  u = User(name: "update!", kana: u.kana);
```

更新したいオブジェクトのフィールドを書き換えて、それ以外は更新前のオブジェクトのデータを引き継いで、新しいオブジェクトを作ります。これにより、常に最新のオブジェクトが代入されることが保証されるので、Riverpod はオブジェクトの更新を検知し、ビルド関数を呼び出すことができるようになります。

### copyWith を使う

更新したいオブジェクトのフィールドを書き換えて、それ以外は更新前のオブジェクトのデータを引き継ぐ。力技でコードを書くとつらみが多い。フィールドが 20 個あった場合、書き換えるのは 2 個で残りの 18 個はそのままだった場合、1 つ 1 つコピーするコードを書くのは冗長です。User データの変更があった場合も、面倒です。

`freezed`では、自動生成によって`copyWith`という関数を自動生成してくれます。このように使います。

```dart
  var u = User(name: "eee", kana:"eee");
  u = u.copyWith(name: "update!");
```

## JSON のデシリアライズ

WebAPI で JSON データを取得し、デシリアライズしてオブジェクトを生成するためのメソッド`fromJson`を自動生成してくれます。

JSON 文字列をどのようにデシリアライズするかについては、[JSON ハンドリング](../docs/10_json_handling.md)で記載したので、ここでは生成するまでに留めなす。

## when でパターンマッチ

Swift/Kotlin では、標準で搭載されている言語仕様です。Kotlin の書き味が近いので、そちらで説明します。こういう動作を行うのがパターンマッチです。

```kotlin
final string = "sample"
when (string) {
    "sample" -> {
        println("this is sample")
    }
    "hoge" -> {
        println("this is hoge")
    }
    "huga" -> {
        println("this is huga")
    }
    else -> {
        println("other")
    }
}
```

参照元: [【Swift/Kotlin】Swift の switch と Kotlin の when の対比](https://iganin.hatenablog.com/entry/2019/08/14/210620)

Kotlin には、`when式`という Switch 文の強化版とも言うべき言語仕様があり、フロントエンドのようにユーザー操作によって複数の状態を有するコードを書かねばならない仕様と相性がよく、とても重宝されています。上記では文字列を比較していますが、オブジェクトの型比較などもできます。

2023 年 2 月時点、Dart には when 式がありません。しかし、パターンマッチは使いたい。非同期で外部リソースからデータを取得する場合、「取得中」「取得成功」「取得失敗」の 3 つのステータスが常に存在して、どれか 1 つが返ってきます。それを `when`を使って書き分けます。

```dart
asyncValue.when(
    loading: CircularProgressIndicator.new,
    error: (error, stacktrace) => Text(error.toString()),
    data: (value) { return Text('$value');},
  );
```

`freezed`を使ってパターンマッチを行うようなクラス定義をすれば、`when`が自動的に生えて上記のようなパターンマッチがすんなり実装できます。開発者体験、高いですよね。

### Result クラスでビジネスロジックの成功可否をパターンマッチ

Kotlin に`Result`クラスというのがあります。こういう使い方をします。

```kotlin
 val result: Result<Int> = Result.fold(getIntValue())
result
    .onSuccess {
        println(it)
    }
    .onFailure {
        println(it.message)
    }
```

`getIntValue()`で例外が発生したら`onFailure`が返ります。成功すれば`onSuccess`です。

これを Dart で実現する場合、`freezed`の力を借りて、こんなクラスを定義します。

```dart
@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(Error error) = Failure<T>;
}
```

自動生成したあとは、以下のようなコードを書くことができます！

```dart
final Result<Something> result = await _somethingRepository.fetchSomething();
result.when(
  success: (Something something) {
  },
  failure: (Error error) {
  }
);
```

例外が発生しうるビジネスロジック、フロントエンドの場合の多くは外部リソースへのデータ取得と送信ですが、その時に予期せぬ出来事があった場合に、`failure`でハンドリングできるようになり、見通しがスッキリします。

## freezed の定義方法

VSCode に用意したコードスニペットを使うだけですが、このような定義になります。

```dart
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converter/json_converter.dart';

part 'Untitled.freezed.dart';
part 'Untitled.g.dart';

@freezed
class Untitled with _$Untitled {
  @jsonConvertersSerializable
  const factory Untitled({
    required String userId,
  }) = _Untitled;

  factory Untitled.fromJson(Map<String, Object?> json) =>
      _$UntitledFromJson(json);
}
```

## Tip

モデル化するため下記のサイトでJsonをコピペすると自動的に生成されることができます。

関連APIのResponseを確認してアプリで必要なパラメーターを整理使ったら簡単に実装ができます。

https://app.quicktype.io/

<img width="306" alt="image" src="https://user-images.githubusercontent.com/111341132/231672885-a60fc720-0809-4d65-b55c-02aacb37a980.png"> <img width="294" alt="image" src="https://user-images.githubusercontent.com/111341132/231672930-75937c55-38db-49b8-8bd8-77502b672d3a.png">
