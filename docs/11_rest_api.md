# REST API を、dio と Retrofit で作る

Flutter で REST なクライアントを作る場合、よく使われるライブラリが２つあります。これを使って実装します。

- [dio](https://pub.dev/packages/dio)
- [retrofit](https://pub.dev/packages/retrofit)

`dio`は、HTTP クライアントのライブラリです。Dart 公式で`http`というライブラリがありますが、単に HTTP 通信が可能なだけなので、以下にあるようなよくある機能を追加するには別の実装が必要です。

- 接続先の URL、タイムアウト設定等
- カスタムリクエスト・カスタムヘッダ
- リクエスト・レスポンスに必要なフィルター
- ファイルアップロード・ダウンロード

リクエストを投げる前に`Authorization`というヘッダに`Baerer: X).5ugha..` というアクセストークンを入れる、401 が返ってきた場合はもう 1 度リクエストを再送したい等、HTTP 通信でよくある要件を満たすために必要なライブラリです。

`retrofit`は、タイプセーフな HTTP 通信を行うためのライブラリです。元々は Square 社のエンジニアが Android 用に作ったライブラリだったと思いますが、Dart にもあります。

以下のような形で、アノテーションを付けながら URL リクエストを組み立てて使います。

```dart
// @Pathを使うと、`@GETに埋め込んだ変数を参照する
@GET("/tasks/{id}")
Future<Task> getTask(@Path("id") String id);

@GET('/demo')
//@Queriesは?keyword=444のようなクエリストリングのこと
Future<String> queries(@Queries() Map<String, dynamic> queries);

@POST("/tasks")
//Task型のオブジェクトをBodyに入れると、自動的にJSONにシリアライズされて、POSTされます
Future<Task> createTask(@Body() Task task);

@POST("http://httpbin.org/post")
@FormUrlEncoded()
//フォームとして送信したい場合は、FormUrlEncodedを使います。keyword=444という形でデータが送信されます
Future<String> postUrlEncodedFormData(@Field() String hello);
```

## エラーハンドリング

API 通信を行った場合、当然ですが様々なエラーが予想されます。それらを一括でエラーハンドリングできるように設計されています。

いろいろ試しましたが、こちらの記事にある設計がシンプルで堅牢なので、こちらのエラーハンドリングの設計をそのまま使わせて頂いています。

[【Flutter】dio + freezed で API レスポンスを Result<T>で受け取る](https://zenn.dev/muttsu_623/articles/b928bad493a2c7f8b32f)

肝となるのは `Error`クラスです。コメントを大量に書き込んでいるので、そちらを参照してください。
