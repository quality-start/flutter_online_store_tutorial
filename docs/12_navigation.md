# 画面遷移

## Navigator1.0 と Navigator2.0

[【Flutter】最小限のコードで理解する「宣言的な画面遷移」と Navigator 2.0](https://zenn.dev/chooyan/articles/cb09f63a57f0fb)に詳しく書いてあります。

Flutter に限らず、モバイルアプリケーションの画面遷移は、スタック構造をとっています。`A画面`→`B画面`→`C画面`に遷移する場合、その画面遷移の履歴が毎回再構築されます。

- `A画面`→`B画面`に行く場合は、`Navigator.push`
- `B画面`→`A画面`に戻る場合は、`Navigator.pop`

モバイルアプリケーションの場合、原則これで大きな問題にはならないです。が、Flutter の場合、以下のような問題が表面化するようになりました。

- Web での URL 直接入力や「戻る」 / 「進む」ボタンに対応できない
- 下タブなど、Navigator がネストする場合に Android などのバックキーがタブ内ではなくアプリ全体に対して処理されてしまう

`Navigator2.0`の実装がかなり複雑なため、それを補完するライブラリがいくつか作られて様子を見ていたフェーズがあり、2022 年後半頃だと思いますが
[go_router](https://pub.dev/packages/go_router)というライブラリのメンテナーが Flutter 公式になり、選択肢は事実上 1 つに絞られました。

そうはいっても、ダイアログを上げるときなどは、Navigator1.0 のコードも使いますので、それらを対比してご案内します。

## MaterialApp routes

`MaterialApp`クラスには、`route`というフィールドがあり、そこに以下のような定義を書くと、画面遷移を前もって定義しておくことができます。

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => new MainPage(),
        '/subPage': (BuildContext context) => new SubPage()
      },
    );
  }
}
```

## Navigator1.0 のコード

`routes`に前もって定義してある場合、以下のコードで画面遷移が実行できます。

```dart
Navigator.of(context).pushNamed("/subPage");
```

`routes`に定義することが難しいような、画面の初期化に引数を取るようなページの場合、以下のように書くことができます。

`MaterialPageRoute`の中に遷移したい画面を書くだけです。

```dart
Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return SubPage(itemId: 33);
}));
```

### 今までの画面遷移を全部破棄して初期化したい

オンボーディングの UI によくあるやつで、「はじめる」ボタンを押した後は前の画面に戻ってこれなくするというタイプの画面遷移です。

Navigator1.0 では、以下のように書くことができます。

```dart
Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
        builder: (context) => const HomePage(),
    ),
    (_) => false,
);
```

`MaterialPageRoute` の第 2 引数の`(_) => false`がポイントで、`false`を返すと戻るところがないと解釈され、今までの画面遷移が全て破棄されます。

### 任意の画面まで戻りたい

`A画面`→`B画面`→`C画面`->`D画面`に遷移した時に、`D画面`から`B画面`に戻りたいという場合です。

```dart
/// 遷移する時
Navigator.of(context).push(
    MaterialPageRoute(
    settings: const RouteSettings(
        name: "ScreenB",
    ),
    builder: (context) => ScreenB(),
    ),
);

/// 戻る時
Navigator.popUntil(context, (route) => route.settings.name == "ScreenB");
```

`push`する時に`RouteSettings`のオブジェクトを定義して、画面遷移したポイントに名前をつけるだけです。

### 画面遷移した先で戻り値が欲しい

ダイアログを表示して、戻り値が必要な場合に使われます。`Navigator.pop()`の第２引数に値を入れるだけです。

```dart
Navigator.pop(context, 'Return Value');
```

受け取る側はこのように書きます。

```dart
final result = await Navigator.push<String>(
    context,
    MaterialPageRoute(builder: (context) => const SelectionScreen()),
);
```

公式のこちらの資料に詳細があります。

[Return data from a screen](https://docs.flutter.dev/cookbook/navigation/returning-data)

## Navigator2.0

モバイルアプリケーションのように、ハイパーリンクや URL 直打ちという世界がない場合、スタックの積み上げで充分でした。

Web アプリケーションの場合、ある画面を開くための方法が無数に存在します。URL による画面遷移に対応する必要があるためです。

- アドレスバーに直打ち
- ブックマークから遷移
- テキストリンクにより遷移

そのため、画面遷移の履歴をたどるという考え方ではうまく行かなくなったので、`NavigationState`をリビルドして最新化しようという考えになったのが、Navigator2.0 のコンセプトです。

実装は、`go_router`を使って実装します。`GoRoute`というルート設定を行い、`context.go()`で画面遷移を行います。

```dart
GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
     path: '/users/:userId',
     builder: (context, state) => const UserScreen(id: state.params['userId']),
    ),
  ],
);
```

`path`に遷移先を、`builder`で遷移先の Widget を指定します。画面遷移に必要なパラメーターは `state.params` で取得できます。

ナビゲーションを入れ子にする場合、以下のように設定します。よく使います。

```dart
GoRoute(
  path: '/',
  builder: (context, state) {
    return HomeScreen();
  },
  routes: [
    GoRoute(
      path: 'details',
      builder: (context, state) {
        return DetailsScreen();
      },
    ),
  ],
)
```

このように画面遷移を前もってひとつの設定に落とし込めると見通しがスッキリします。

### Typed GoRoute

`GoRoute`で最も残念な点が、パラメーターがタイプセーフになっていない点です。`state.params['userId']`では実行時例外が発生する可能性があります。

そのため、GoRoute の定義時を自動生成してタイプセーフに扱うことができる、[go_router_builder](https://pub.dev/packages/go_router_builder)というライブラリを使うことをおすすめしています。

`GoRoute`の定義は以下のように変わります。

```dart
@TypedGoRoute<HomeRoute>(
  path: '/',
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context) => const HomePage();
}
```

詳細は[【Flutter】go_router をタイプセーフに使う方法【go_router_builder】](https://zenn.dev/flutteruniv_dev/articles/20220801-135028-flutter-go-router-builder)を参照してください。
