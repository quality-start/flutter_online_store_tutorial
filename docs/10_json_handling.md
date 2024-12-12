# JSON をタイプセーフに扱う

Flutter(というか Dart)で JSON を扱う流れ、まずは下記のサンプルコードをご覧ください。

```dart
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.https('dummyjson.com', 'products', {'limit': '20'}));
    final parsedListJson = jsonDecode(response.body)['products'] as List<dynamic>;
    return parsedListJson.cast<Map<String, Object?>>().map(Product.fromJson).toList();
  }
```

最初の行は、単に HTTP アクセスで JSON を取っているだけです。

次の行で、`jsonDecode`を呼び出しています。これは `String`を引数に`dynamic`を返す関数です。JSON をパースする側からすると、どんなフォーマットの JSON を食わせられるのかわからないので、どんな型にもキャストできる `dynamic`が返るのだと思われます。

この JSON が `products`とキーの配下に配列がぶら下がっているのでキーを指定し、その JSON の配列を `List<dynamic>`でキャストしています。`jsonDecode`が `dynamic`を返しているのが理由ですが、配列の中にある JSON オブジェクトの型がわからないという側面もあります。

`List<dynamic>`の`dynamic`を `cast`関数によって `Map<String, dynamic>` に型変換しています。これは、`Map<String, dynamic>`が JSON のオブジェクトを示しているからです。どの言語も JSON を連想配列と見立て、キーは文字列で、値は何でも入るようにして設計していると思います。

`List<dynamic>`の 1 つ 1 つの要素が `Map<String, Object?>`に型変換したことで、やっとタイプセーフにできます。`Product.fromJson`は、`Map<String, Object>`を引数に`Product`クラスのオブジェクトを返す関数です。

まとめると、`dynamic` -> `List<dynamic>` -> `List<Map<String, Object?>>` -> `List<Product>`という 4 つの型変換を経て、JSON がタイプセーフな型を持ったオブジェクトに転生できるというわけです。

`Product.fromJson`の実装は、以下の通りです。力技で実装されています。`Object?`を機械的にキャストするのは無理なので、こうならざるを得ません。

```dart
  factory Product.fromJson(Map<String, Object?> json) {
    return Product(
      id: json['id'] as int,
      brand: json['brand'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      thumbnail: json['thumbnail'] as String,
      images: (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }
}
```

新しく JSON からオブジェクトにデシリアライズしたい型が増えるたびに上記のようなコードを手打ちする意味はないので、前述した`freezed`の力を借りて、`fromJson` 関数だけを定義し、コード生成によって上記のコードを自動生成を行います。
