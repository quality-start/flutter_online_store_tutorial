// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_filter.freezed.dart';
part 'product_filter.g.dart';

@freezed
class ProductFilter with _$ProductFilter {
  const factory ProductFilter({
    // メモリ
    List<String>? memories,
    // 最安値
    int? minPrice,
    // 最高値
    int? maxPrice,
  }) = _ProductFilter;
  factory ProductFilter.fromJson(Map<String, dynamic> json) => _$ProductFilterFromJson(json);
}
/*
{
  "memories": ["16GB", "32GB"],
  "minPrice": 10000,
  "maxPrice": 50000
}
https://xxxx.com?memories=16GB,32GB&minPrice=10000&maxPrice=50000
*/