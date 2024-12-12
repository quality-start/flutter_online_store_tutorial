# Riverpod で状態管理をする場合、その前に

Riverpod は、[Remi Rousslet](https://twitter.com/remi_rousselet?lang=ja)さんが中心となって作られた、Flutter で UI の状態管理を行うことを目的としたライブラリです。Flutter 界のロックスターで、彼が管理してるレポジトリで多くの Flutter 開発者が助けられています。

`Riverpod` の理解を促進するために、その前身となった `Provider`パッケージの理解があったほうが速いので、先にそっちの話をします。Riverpod は Provider の思想をコアにスクラッチで書き直されたのがコアにあるからです。

## setState から Provider へ

Flutter 公式で、[List of state management approaches](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options) という資料が公開されています。

公式・非公式含めて多くの状態管理を行うライブラリが紹介されていますが、Flutter 公式チームでリリースされた状態管理のライブラリが **Provider** です。公式ドキュメントで 2019 年頃にアナウンスされました。

Flutter には、`InheritedWidget` という、親の Widget が持つデータを子の Widget で使うケースに即した Widget が用意されています。Flutter の `theme` の中身は StatelessWidget ですが、開発者がアプリのテーマを取得する時に、`InheritedWidget` を継承したオブジェクトが参照されるようになっています。

アプリのテーマは全ての配下の Widget に適用するのが常なので、MaterialApp というトップレベルの Widget で theme を設定することで、配下の Widget 全てが指定されたテーマを参照することができます。`setState`から`build`を全ての配下の Widget に実装して呼び出すのはちょっと現実的ではないので、より効率的に変更を伝搬できるように、`InheritedWidget` が作られています。

しかし、`InheritedWidget` を使ってコードを書くとボイラーテンプレート的なコードが多く Flutter 内部の実装に詳しくないと扱いづらいということから、それをラップしていい感じに状態管理ができるようなライブラリを、Flutter 公式チームが公開しました。それが `Provider` です。

## Provider の使い方

Provider では以下の 3 つの登場人物が出ます。Riverpod でも同様の概念が出てくるので、抑えておいてください。

- ChangeNotifier
- ChangeNotifierProvider(InheritedWidget)
- Consumer(InheritedWidget の child で指定される Widget)

### ChangeNotifier

Flutter SDK に当初から実装されている、値の変更を自分を購読しているリスナーを登録することで検知するためのクラスです。変更を行ったことは手動で `notifyListener()`を都度実装する必要があるのがめんどい所。簡単なコードはこちら。

```dart
class CountData extends ChangeNotifier {
  int count = 0;

  void increment() {
    count = count + 1;
    notifyListeners();
  }
}
```

Provider パッケージ では、この ChangeNotifier を Widget に購読させることで、リビルドを実行させます。

### ChangeNotifierProvider

ChangeNotifier を購読した`InheritedWidget` のラッパークラスです。このラッパークラスのことを`Provider`と呼んでいます。こんな感じで使います。

```dart
class ParentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CountData>(
      create: CountData(),
      child: ChildWidget(),
    );
  }
}
```

`ChangeNotifierProvider`でラップして、`create` 引数にデータを渡します。

### Consumer

Consumer は、ChangeNotifierProvider で提供されたデータを使う Widget という意味です。唯一の必須の引数は `builder` です。 `notifyListeners()`を呼び出すと対応するすべての Consumer ウィジェットの builder メソッドが呼び出されるようになっています。

最初の引数は `BuildContext`です。2 番目引数は、自分が取得する型の `ChangeNotifier` のオブジェクトです。この例だと`CountData`です。3 番目の引数は child で Consumer の下に、モデルが変わっても変化しない大きなウィジェットのサブツリーがある場合などに使います。実務上、ほとんど使わないと思います。

```dart
class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Consumer<CountData>(
      builder: (context, cart, child) {
        return  Column(
          children: <Widget>[
          Text('count is ${data.count}'),
          RaisedButton(
            child: const Text('Increment'),
            onPressed: () {
            data.increment();
          },
        ),
      ],
    );
  }
}
```

### context 経由でデータを監視する

```dart
class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CountData data = context.watch<CountData>(context);

    return Column(
      children: <Widget>[
        Text('count is ${data.count}'),
        RaisedButton(
          child: const Text('Increment'),
          onPressed: () {
            data.increment();
          },
        ),
      ],
    );
  }
}
```

`context.watch<CountData>(context);` がポイントです。`watch`を使うと、`CountData`で `notifyListener`が呼び出されると、`build`がもう 1 度呼び出されます。`context.read`だと、プロバイダーの値を Widget の初回レンダリング時にのみ反映します。

この`watch` や`read`は、次に登場する`Riverpod` でも同様の関数があります。

## Riverpod の登場

Provider パッケージはシンプルで使いやすい状態管理手法を提供してくれましたが、普及が進むにつれて開発者にとって不都合な側面が目立つようになりました。`InheritedWidget` の特性上による弊害です。

- 同じ型の Provider を複数定義できない
- Widget ツリーから外れた Provider を参照すると実行時以外が出てしまい、Widget の継承関係を書き直さないといけない
- 非同期処理と組み合わせると Widget のコードが肥大化しやすい

この状況に対して、Flutter における憂国の士 Remi さんが、今までの Provider パッケージ でやっていた状態管理手法はそのままにしながら開発者体験を高めるために、`InheritedWidget` に相当する機能をゼロから作り直して開発されたのが、**Riverpod** です。

## Why Riverpod?

[公式のドキュメント](https://riverpod.dev/docs/concepts/providers0) にある通りですが、要点まとめます。

- 状態管理のコードがシンプルになります。従来の `setState` や `Provider` では煩雑な表現を必要としていたコードが不要になります。
- Provider の `watch` `listen`を使い分けることで、複雑な UI 更新処理が必要な画面でも可能な限りシンプルにコードを書くことが出来ます。
- テスタビリティがあがります。プロバイダーをオーバーライドして、テスト中に異なる動作をさせることができるので、プロダクションのコードを汚さなくて良くなります。

## Riverpod の使い方

まずは、サンプルコードを見てください。Riverpod 公式のドキュメントにあるものです。

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Text(value),
        ),
      ),
    );
  }
}
```

Provider パッケージでは、`ChangeNotifier`、`ChangeNotifierProvider`、`Consumer`の 3 つが登場しましたが、Riverpod では`Provider`と`Consumer`だけです。基本的な考え方は、前述した Provider パッケージ と同じです。

- `Provider`をグローバルに定義する。グローバルとは、どのクラスや関数にも属していないデータという意味です。
- エントリポイントである`runApp`の引数に `ProviderScope`を必ず呼び出す。
- 定義した`Provider`のデータを取り出す場合は、`ConsumerWidget`を継承して取得する。

## Ref とは

`Ref` は、Riverpod の Provider で定義したオブジェクトの値を取得したり、更新するために存在します。簡単に言うと、 `Ref` を経由しないと Provider にセットした値は取得できませんし、更新もウオッチできないようになっています。

`Riverpod`は、Dart でも使えることを目指しているため、`Flutter`以外のプロジェクトでも利用できる設計になっています。Flutter の特性で、UI の更新を伝搬するには Widget ツリーに`State`を埋めて更新しないといけないので、`WidgetRef`というクラスが用意されています。

`WidgetRef`を必ず参照できるように、`ConsumerWidget`が用意され、それを使います。

## Riverpod の Provider

Provider パッケージでは`ChangeNotifierProvider`がメインでしたが、Riverpod では、用途に応じた様々な Provider が実装されています。

Provider とは、自分の適したデータを保存・公開・更新するためのクラスのことです。
Riverpod 2 系で利用される Provider は、以下の通りです。

| Provider        | 内容                                                                 |
| --------------- | -------------------------------------------------------------------- |
| Provider        | (外部からは)変更できないデータを公開する。レポジトリレイヤーに最適。 |
| FutureProvider  | (外部からは)変更できない非同期のデータを公開する。一覧取得に最適。   |
| StreamProvider  | リアルタイムにデータを送受信する時に公開する                         |
| (Async)Notifier | データの更新を外部から行う。                                         |

`Notifier`には、管理するデータが非同期なのか否かで、使う Provider が異なります。同期なら `Notifier` で、 非同期なら `AsyncNotifier`です。

## Riverpod で Provider を作るには

2023 年 1 月にリリースされた、[riverpod_generator](https://pub.dev/packages/riverpod_generator) を使います。

Riverpod は素晴らしいライブラリですが、記法が複雑なので Riverpod 文法を覚えるのに四苦八苦する部分がありました。それを解決するために、ロジックや状態を公開・更新するコードを書けば、Riverpod が適切なプロバイダーを生成してくれるようになりました。

次章で説明します。
