import 'package:flutter/material.dart';
import 'package:flutter_online_store_tutorial/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterScreen extends ConsumerWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(filtersProvider);
    final filterNotifier = ref.read(filtersProvider.notifier);

    final priceRange = ref.watch(priceRangeProvider);
    final priceRangeNotifier = ref.read(priceRangeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Filters'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionTile(
                title: const Text('Built-in memory'),
                children: [
                  const SizedBox(height: 16),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: filters.keys.map((key) {
                      return CheckboxListTile(
                        title: Text(key),
                        value: filters[key],
                        onChanged: (_) => filterNotifier.toggle(key),
                      );
                    }).toList(),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Price'),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'From: ${priceRange.start.toInt()}',
                            style: const TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'To: ${priceRange.end.toInt()}',
                            style: const TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RangeSlider(
                    values: priceRange,
                    max: 5000,
                    divisions: 50,
                    labels: RangeLabels(
                      priceRange.start.toStringAsFixed(0),
                      priceRange.end.toStringAsFixed(0),
                    ),
                    onChanged: (newRange) {
                      priceRangeNotifier.update((state) => newRange);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Apply button
              ElevatedButton(
                onPressed: () {
                  // 適用されたフィルターの状態を外部に反映
                  final appliedFilters = filters.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();
                  final appliedPriceRange = priceRange;

                  // StateProviderに反映
                  ref.read(appliedFiltersProvider.notifier).state = appliedFilters;
                  ref.read(appliedPriceRangeProvider.notifier).state = appliedPriceRange;

                  // 画面を閉じる
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
