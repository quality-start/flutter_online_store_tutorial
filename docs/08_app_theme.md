# Flutter とテーマ

Flutter の UI デザインは、Material Design に準拠するように求められています。

Material Design に沿ったアプリケーションを構築しやすくするため、Flutter には`ThemeData`が存在します。このテーマを作ることで、ライトモード・ダークモードの切り替えも行うことができます。

`MaterialApp`のコンストラクタ引数`theme`に`ThemeData`を指定することでアプリ全体にテーマが適用されます。

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        home: TasksScreen(),
        theme: ThemeData(primaryColor: Colors.purple), // コンストラクタ引数themeにThemeDataを渡す
      );
  }
}
```

ThemeData ですが引数がめちゃくちゃ多いです。[ThemeData の公式 API ドキュメント](https://api.flutter.dev/flutter/material/ThemeData-class.html)を見てみるとすごいことになっています。

テーマを作るのがめんどくさい人のために、`ThemeData`には、`primarySwatch`というキーワード引数があります。ここに、PrimaryColor に対応する色をセットすると、マテリアルデザインに沿ったカラーテーマを自動で適用してくれます。

カラーコードを決め打ちで入れてしまうと、ライトモード・ダークモードの切り替えの時に自動的に切り替わらないので、UI が意図したデザインで表示されない可能性があります。なるべく、色の決め打ちをせずに `ThemeData`に寄せましょう。

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        home: TasksScreen(),
        theme: ThemeData(primarySwatch: Colors.purple), // コンストラクタ引数themeにThemeDataを渡す
      );
  }
}
```

Material Design のスキームは踏襲しつつもアクセントカラーは別にしたい、フォントは好きなものを使いたいケースが多いので、色、ボタン、テキストの３つは各々指定し、ライトモード・ダークモードの切り替え時に参照できるようにしておきましょう。

## ColorScheme

Material Design で定義されているカラー種別を表現したものです。ほぼ、PrimaryColor と Secondary Color で決まります。

PrimaryColor は、以下のような UI オブジェクトの色に自動的にセットされます。

- AppBar の背景色
- BottomNavigation の selected(ライトモードの場合)
- TextField の選択した時の枠線やアイコンの色(InputDecoration の色)
- CircleAvatar の色
- Button の背景色

Secondary Color は、以下が対象になります。

- FloatingButton の色
- checkbox/radio の selected
- indicator の矢印の色
- Dialog の Button の文字色
- BottomNavigation の selected

それ以外の色はあまり使ったことがないです。

## TextTheme

https://api.flutter.dev/flutter/material/TextTheme-class.html

Material Design で定められたスキームがあり、それに準拠したものです。サイズやフォントなどを定義し、カラーなどは別途 Widget で定義します。

## ButtonTheme

Flutter でよく使うのは`ElevetedButton`というボタンです。スタイルのカスタマイズが柔軟で、タップした時にリップル効果がつくボタンです。

それだけでなく、`TextButton`や`OutlinedButton`などもあり、各々のボタンに共通のスタイルを定義するためのものです。
