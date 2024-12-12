// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dummyProductHash() => r'0fe809e8d126ed5471a7c3dadfdfc2fcdafcb541';

/// See also [dummyProduct].
@ProviderFor(dummyProduct)
final dummyProductProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  dummyProduct,
  name: r'dummyProductProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dummyProductHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DummyProductRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$asyncProductHash() => r'1af31786ea0305d49b60aeb382169290ce442a24';

/// See also [AsyncProduct].
@ProviderFor(AsyncProduct)
final asyncProductProvider = AutoDisposeAsyncNotifierProvider<AsyncProduct,
    List<Map<String, dynamic>>>.internal(
  AsyncProduct.new,
  name: r'asyncProductProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$asyncProductHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AsyncProduct = AutoDisposeAsyncNotifier<List<Map<String, dynamic>>>;
String _$searchConditionHash() => r'b4f78eb753a8ae2180d3b8baa9be02884387b482';

/// See also [SearchCondition].
@ProviderFor(SearchCondition)
final searchConditionProvider =
    NotifierProvider<SearchCondition, ProductFilter>.internal(
  SearchCondition.new,
  name: r'searchConditionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchConditionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchCondition = Notifier<ProductFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
