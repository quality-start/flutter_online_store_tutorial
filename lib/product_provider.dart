import 'dart:convert';

import 'package:flutter_online_store_tutorial/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_provider.g.dart';

// FutureProvider
@riverpod
Future<List<Map<String, dynamic>>> dummyProduct(Ref ref) async {
  final response = await http.get(
    Uri.parse(
      'https://dummyjson.com/products?limit=10&skip=10&select=title,price',
    ),
  );
  return jsonDecode(response.body) as List<Map<String, dynamic>>;
}

// AsyncNotifierProvider
@riverpod
class AsyncProduct extends _$AsyncProduct {
  @override
  FutureOr<List<Map<String, dynamic>>> build() async {
    return fetchProducts();
  }
}
