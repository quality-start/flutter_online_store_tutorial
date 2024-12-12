// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductFilterImpl _$$ProductFilterImplFromJson(Map<String, dynamic> json) =>
    _$ProductFilterImpl(
      memories: (json['memories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      minPrice: (json['minPrice'] as num?)?.toInt(),
      maxPrice: (json['maxPrice'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ProductFilterImplToJson(_$ProductFilterImpl instance) =>
    <String, dynamic>{
      'memories': instance.memories,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
    };
