import 'package:flutter/material.dart';
import 'package:flutter_online_store_tutorial/product_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DummyProductWidget extends ConsumerWidget {
  const DummyProductWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dummyProduct = ref.watch(dummyProductProvider);
    // AsyncValueのwhenメソッドを使ったビルドの出し分け。
    // FutureBuilderと使い方同じだけど、snapshotの分岐がなくなっている。
    return dummyProduct.when(
      data: (data) => Text(data.toString()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: CircularProgressIndicator.new,
    );
  }
}

class DummyProductWidgetSwitch extends ConsumerWidget {
  const DummyProductWidgetSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dummyProduct = ref.watch(dummyProductProvider);
    return switch (dummyProduct) {
      AsyncData(:final value) => Center(child: Text(value.toString())),
      AsyncError(:final error) => Center(child: Text(error.toString())),
      // パターンマッチの場合、AsyncLoadingとAsyncValueの2つがあるが、どちらも読み込み中でOK
      // whenメソッドが好きだが、公式のサンプルはこのパターンマッチ。
      // パターンマッチは共通の親クラスを持つサブクラスの一覧でSwitchできるみたいなものです。
      // sealed class パターンマッチとかでぐぐると、色々サンプル出てきます。関数型プログラミングでは必須。
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
