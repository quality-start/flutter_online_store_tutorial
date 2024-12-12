# Riverpod generator

2023 年の 1 月に、Riverpod のコードジェネレーターがリリースされました。

ジェネレーターを使うことで Riverpod で最も複雑だった Provider を生成・更新するコードを作らなくても良くなります！ ジェネレーター以前に Riverpod を使っていた私には、とても大きなニュースでした。

ジェネレーターが出てくるまでは、Riverpod の記法に合わせるために煩雑な表現を必要でした。

## Provider をジェネレーターで生成する

`Repository`レイヤーのようなメソッドを公開するだけのクラスのオブジェクトを生成する場合、外部から値を変更できない `Provider`が最適です。

```dart

@Riverpod(keepAlive: true)
CityRepository cityRepository(CityRepositoryRef ref) => CityRepository();

class CityRepository {
  Future<List<VendorCity>> fetchCity() async {
    final jsonString = await rootBundle.loadString('assets/sales_brand_city.json');
    final parsed = jsonDecode(jsonString);
    final response = (parsed as List).cast<Map<String, dynamic>>();
    final result = response.map<VendorCity>(VendorCity.fromJson).toList();
    return result;
  }
}
```

Riverpod のアノテーションには、ややこしいのですが、`@Riverpod()` と `@riverpod` があります。どちらも同じように見えますが、前者は関数になっているので、引数に値を渡すことが出来ます。レポジトリレイヤーのクラスのオブジェクトは Flutter アプリ全体でシングルトンで良いので、`keepAlive`を`true`にしています。

`keepAlive`は、自分を参照している UI がいなくなっても、Provider オブジェクトを保有するかどうかのフラグです。デフォルト値は `false`で、自分を参照している UI が Widget ツリーから消えると、Provider も破棄されます。Widget ツリーに再構築されると、Provider も再構築されます。

この定義でソースコードを自動生成すると、以下のようなコードが生成されます。

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cityRepositoryHash() => r'f5ad4a5870e40517f576cc54d435111d926f7c54';

@ProviderFor(cityRepository)
final cityRepositoryProvider = Provider<CityRepository>.internal(
  cityRepository,
  name: r'cityRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cityRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CityRepositoryRef = ProviderRef<CityRepository>;
```

`cityRepositoryProvider` という `Provider`が生成されており、アプリからこの変数を参照することが出来ます。

Hash 値は Hot Reload に対応するためのもので、最後の `typedef`は、Riverpod のお作法によるものです。アプリケーションにはあまり関係のない部分です。

## FutureProvider をジェネレーターで自動生成する

一覧を非同期で取得するだけで良いデータの場合、Riverpod は `FutureProvider` を推奨しています。プロフィールの編集のように、データを非同期で取得してから、値を変更し画面を更新する必要がある場合は不適切で、その場合は、`AsyncNotifier`を使います。これは後ほど使い方を解説します。

```dart
@Riverpod()
Future<List<VendorCity>> fetchCity(FetchCityRef ref) async {
  return ref.read(cityRepositoryProvider).fetchCity();
}
```

コードはこれだけで良いです。こうすることで、`fetchCityProvider` が自動生成され`AsyncValue`で受け取れるので、`when`でパターンマッチが可能です。メソッドの戻り値が`return`されるまで、ステータスは自動的に`loading`になります。

ジェネレーター登場以前の場合、同じことをやるにもこういうコードを書かねばなりませんでした。煩雑な表現だと思います。

```dart
final cityListProvider =
    StateNotifierProvider.autoDispose<CityState, AsyncValue<List<VenderCity>>>(CityState.new);

class CityState extends StateNotifier<AsyncValue<List<VenderCity>>> {
  CityState(this.ref) : super(const AsyncValue.loading()) {
    initialize();
  }
  final Ref ref;

  Future<void> initialize() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(cityRepositoryProvider).fetchCity();
    });
  }
}
```

この煩雑な表現が Flutter 初学者が Riverpod のコードを使う時にブチ当たる壁だったので、コードジェネレーターの導入は大正解だと思っています。

## Notifier をジェネレーターで自動生成する

`Notifier`は、従来の `StateProvider`と`StateNotifierProvider`が一つになったもので、初期化処理で取得したデータを更新する必要がある場合に利用します。

- ボタンをタップする度にカウントアップする
- 検索条件を変えたら件数を変えるとか
- 取ってきたデータをフィルターする
- アップデートしてプレビューする
- アプリケーション全体で共有する状態を管理する（ログイン済か否か等）

公式のサンプルがわかりやすいので、そちらを一部抜粋します。

```dart
@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() {
    return [];
  }

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void removeTodo(String todoId) {
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }
}
```

これだけで `Notifier` と `NotifierProvider` が自動生成されます。

`Notifier`は、T 型の`state`という変数に新しいオブジェクトが代入される度に、自分を`watch`している UI が更新されます。

### AsyncNotifier をジェネレーターで自動生成する

(https://docs-v2.riverpod.dev/docs/providers/notifier_provider)[Riverpod公式のAsyncNotifierサンプル]がわかりやすいので、一部変えてそのまま持ってきました。

```dart
@riverpod
class AsyncTodoList extends _$AsyncTodoList {
  Future<List<Todo>> _fetchTodo() async {
    final json = await http.get('api/todo');
    final todoList = jsonDecode(json) as List<Map<String, dynamic>>;
    return todoList.map(Todo.fromJson).toList();
  }

  @override
  FutureOr<List<Todo>> build() async {
    return _fetchTodo();
  }

  Future<void> addTodo(Todo todo) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await http.post('api/todo', todo.toJson());
      return _fetchTodo();
    });
  }
  Future<void> removeTodo(String todoId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await http.delete('api/todo/$todoId');
      return _fetchTodo();
    });
  }
```

見ての通り、`async`があるかないかと、状態を更新する前に `AsyncValue.loading()` で UI にローディングを出すように変えています。
