# Flutter のテスト戦略

## Flutter にある３つのテスト

Flutter には、下記の３つのテストが用意されています。

| テスト名         | 内容                                                                     |
| ---------------- | ------------------------------------------------------------------------ |
| Unit Test        | ロジックのチェックを行うためのテスト                                     |
| Widget Test      | UI が意図した状態で更新されるか、表示されているかのテスト                |
| Integration Test | E2E テスト。シミュレーターを起動して自動的に操作をエミュレートするテスト |

フロントエンドは、バックエンドに比べるとビジネスルールを実装するケースが少ないので、Unit Test を書くことは少ないです。複雑な JSON が適切にデシリアライズできるか、ぐらいです。書いても品質の担保に直結するケースも少ないように思います。

E2E テストはモバイルアプリの場合 WebAPI だけでなく、Firebase のような mBaaS 等も必要になるケースが多いため、環境を作るのも大変です。CI を回すのも難しく、どうしても必要なユースケースだけ書けば良いでしょう。決済フローなど。

最もテストを書くメリットが有るのは、**Widget Test**です。正常系の UI 操作を書いて、新しい機能が追加 or 既存機能が削除された場合に、デグレが発生していないかを検知できる状態にする。これがフロントエンドのテストで担保すべきことで、それ以外はあまり考えなくて良いと思っています。

**テストコードはコストパフォーマンスで判断すべきです**。細かく書きすぎてもいけないし、荒すぎてもいけない。例外発生時の処理なんて書かなくてもいい。フロントがどうにかする話じゃない。

フロントエンドのテストケース、チェックすべき観点は大きく３つです。

- 意図したデータが意図したレイアウトの中に表示されているか
- 操作によって更新が必要なデータは、操作後に更新されているか。もしくは、消えているか。
- 適切な画面に遷移されているか。戻った時に残したいデータは残って表示されているか。

## Widget Test は外部リソースが一切利用できない

Widget Test には、大きな制約があります。外部リソースが利用できない点です。

- REST を始めとした HTTP(S)アクセス
- ローカルに書き出したファイル、データベース、SharedPreference 等の設定情報
- KeyChain などの機密情報(Flutter Secure Storage)
- Firebase へのアクセス

UI から直接外部リソースを取得・アクセスするようなコードを書くと Widget Test ができません。

**このようなコードは絶対に書かないでください。**

```dart
TextButton(
  child: Text("tap here"),
  onPressed: () async {
    final response = await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums'));
    setState(() => albumList = Albums.fromJson(jsonDecode(response.body));
  }
)
```

どうするかといえば、データソースにアクセスするための、仲介役を挟みます。

```dart
TextButton(
  child: Text("tap here"),
  onPressed: () async {
    setState(() => albumList = albumRepository.getAlbumList());
  }
)
```

UI からすれば、必要なものはオブジェクトです。アルバムの一覧ですから `List<Album>` みたいなクラスのオブジェクトがあって、その値を持ってしてテストをすれば良い。どっからデータを取ってこようが、知る必要はないです。UI からすれば。

### Mock（モック）を使って処理を差し替える

レポジトリのクラスを作って仲介役を作っても、 `getAlbumList` は HTTP アクセスを実行してしまうため、このままですと Widget Test はできません。

どうするかといえば、メソッドのシグニチャ定義はそのままにして、テストを実行するときだけ中身のロジックを上書きします。そうすれば、**Widget に書いたコードを一切変えずにテストができます！**

以下のコードを見てください。

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Fake Cat Test', () async {
    final cat = FakeCat();

    expect(cat.meow('foo'), 'FakeMeowfoo');
    final result = await cat.future('foo');
    expect(result, 'FakeFuturefoo');
  });
}
// Concrete class.
class Cat {
  String meow(String suffix) => 'Meow$suffix';
  String hiss(String suffix) => 'Hiss$suffix';
  Future<String> future(String suffix) async => 'Future$suffix';
}

// Fake class.
class FakeCat extends Fake implements Cat {
  @override
  String meow(String suffix) => 'FakeMeow$suffix';

  @override
  Future<String> future(String suffix) async => Future.value('FakeFuture$suffix');
}
```

`FakeCat` クラスに注目してください。

メソッドのシグニチャはそのままに、処理だけ差し替わっています。 `Fake` クラスは Flutter 公式のライブラリで、非同期の `Future` もモックできます。

テスト用モックライブラリといえば、Java プログラマの方にはおなじみ `mockito` があります。

[mockito | Dart Package](https://pub.dev/packages/mockito)

`fake` は `mockito` より直感的に書けますが、 `mockito` のように関数のシグニチャに応じて戻り値を返すことができません。

```dart
when(cat.meow("AAA")).thenReturn("Purr");
when(cat.meow()).thenReturn("Empty");
```

ビジネスロジックが引数の組み合わせで変わるようなケースに、とても使い勝手がよいテスト用ライブラリです。バックエンドですと、同じ型でも中身が違ったりするので。

フロントエンドではあまり使わない気もしますので、Flutter 公式の紋所を信じ `fake` でテストを書けば良いと考えています。

## Finder と Matcher

Widget Test を書く場合は、「指定された Widget が存在するか、もしくはいないか」を検証することになります。

Widget を指定するための構文が `Finder` で、Widget の存在を確認するのが `Matcher`です。

Widget Test のチェックポイントは１つだけで「なぜ、その Finder で Widget を指定する必要があるのか」です。テストケースの妥当性を確認できればそれでいいので。

### Finder 一覧

| Finder                   | 内容                                                     |
| ------------------------ | -------------------------------------------------------- |
| find.text()              | 指定した Text をもつ Widget を探す。                     |
| find.textContaining()    | 指定した Pattern にマッチした Text をもつ Widget 探す。  |
| find.widgetWithText()    | 指定した文字列を持つ、指定した型の Widget を探す。       |
| find.image()             | 指定した image を含む Widget を探す。                    |
| find.byKey()             | 指定した Key を持つ Widget を探す。                      |
| find.bySubtype()         | 指定した型のサブクラスの Widget を探す。                 |
| find.byType()            | 指定した型の Widget を探す。                             |
| find.byIcon()            | 指定した icon を持つ Widget を探す。                     |
| find.widgetWithIcon()    | 指定した Icon を持つ、指定した型の Widget を探す。       |
| find.widgetWithImage()   | 指定した Image を持つ、指定した型の Widget を探す。      |
| find.byWidget()          | 指定した Widget を持つ、同一インスタンスの Widget を探す |
| find.byWidgetPredicate() | 自分で指定した条件に合う Widget を探す。                 |
| find.byTooltip()         | 指定した文字列を含んだ Tooltip を持つ Widget を探す。    |
| find.descendant()        | 配下の Widget で条件に合う Widget を探す                 |
| find.ancestor()          | 自分の祖先 Widget で条件に合う Widget を探す             |

### Matcher 一覧

| Matcher        | 内容                                |
| -------------- | ----------------------------------- |
| findsNothing   | 指定した Widget が存在しない        |
| findsOneWidget | 指定した Widget が 1 つだけ存在する |
| findsWidgets   | 指定した Widget が 1 つ以上存在する |
| findsNWidgets  | 指定した Widget が N 個存在する。   |
