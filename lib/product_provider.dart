import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_provider.g.dart';

// RiverpodはProviderというオブジェクトを経由して、Widgetとデータ連携を行います。
// Stringのデータを格納するProviderを作って、WidgetはProviderからデータを取り出す、という格好です。
// Riverpodを使うのにあたって最も面倒なのが、Providerの作成です。種類が多く、使い方に迷うため。
// そのため、riverpod_generatorという、関数やクラス定義からProviderを生成するライブラリを使っている
// @riverpodというアノテーションを付けると、Provider自動生成対象と認識されます。
@riverpod
Future<Map<String, dynamic>> dummyProduct(Ref ref) async {
  // product_provider.g.dartを見ると、AutoDisposeFutureProviderというProviderが生成されているのがわかります。
  // FutureProviderはFutureBuilder同様に、Futureを受け取って、データを取り出すProviderです。
  // FutureProviderは、初期化した後にProviderの中身を変更できません。
  // 毎回同じ条件で非同期でデータを引っ張ってくるが、その都度最新がほしいみたいなケースで使います。
  // ユーザー情報や、最新のお知らせ10件とか、何かの履歴？みたいなでーたを取得する場合が多い。
  // FutureProviderを使いたい場合は、Futureの関数を定義して、@riverpodをつけます。
  final response = await http.get(
    Uri.parse(
      'https://dummyjson.com/products?limit=10&skip=10&select=title,price',
    ),
  );
  return jsonDecode(response.body) as Map<String, dynamic>;
}

// RiverpodのProviderは2つに大別でき、初期化したあとで中身を変更できるもの・できないものがあります。
// final/constのように一度データを初期化したら再代入できない、という制約がある場合とない場合があります。
// 前者の再代入不可は、Provider / FutureProviderです。
// 再代入可能なのが、NotifierProvider / AsyncNotifierProviderです。
// プロフィールの編集、ページングや検索条件の変更など、初期化した後データを書き換えたいケースでこちらを使います。
// 再代入可能かどうかは、クラスを定義して@riverpodするか、関数を定義して@riverpodするかで決まります。
@riverpod
class AsyncProduct extends _$AsyncProduct {
  // _$AsyncProductは、Riverpodが自動生成するために必要なクラス定義です。
  // _$<クラス名>という命名規則になっています。Riverpodの仕様です。
  // product_provider.g.dartを見ると、AutoDisposeAsyncNotifierProviderというProviderが生成されているのがわかります。
  @override
  Future<List<Map<String, dynamic>>> build() async {
    return fetchProducts();
  }

  // appendという関数を作って、fetchProductsを呼び出して、元のデータに追加してください
  Future<void> append() async {
    // Notifierを使った場合、`state`という変数しか再代入できないようになっています。
    // requireValueは、AsyncValueの中身を取得するための変数。初期化されていない場合などはエラー
    final current = state.requireValue;
    final next = await fetchProducts();
    // currentとnextを結合すると、要素が全部連結された配列を返します。
    // [1,2,3,4] + [1,2,3,4] = [1,2,3,4,1,2,3,4]
    final result = current + next;
    // stateには、AsyncValueという型が入っています。AsyncValueは、AsyncLoading, AsyncData, AsyncErrorの3つの状態を持ちます。
    state = const AsyncLoading();
    state = AsyncValue.data(result); // AsyncData(result)
  }
}

Future<List<Map<String, dynamic>>> fetchProducts() async {
  final response = await http.get(
    Uri.parse(
      'https://script.google.com/macros/s/AKfycbxhvuNcXRPIdS74WdGdf3J_A7D56bOMLbO----HuNZRf-gRbMlohKM3JV2iehafOa-s/exec',
    ),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch products');
  }

  final data = jsonDecode(response.body) as List<dynamic>;
  return data.cast<Map<String, dynamic>>();
}
