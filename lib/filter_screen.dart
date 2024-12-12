import 'package:flutter/material.dart';
import 'package:flutter_online_store_tutorial/product_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterScreen extends ConsumerWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(searchConditionProvider);
    final notifier = ref.read(searchConditionProvider.notifier);

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
                  for (final memory in [
                    '16GB',
                    '32GB',
                    '64GB',
                    '128GB',
                    '256GB',
                    '512GB',
                  ])
                    CheckboxListTile(
                      title: Text(memory),
                      value: filtered.memories?.contains(memory) ?? false,
                      onChanged: (value) {
                        notifier.setMemories(memory: memory, selected: value ?? false);
                      },
                    ),
                ],
              ),
              const ExpansionTile(
                title: Text('Price'),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'From: ',
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'To: ',
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*
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
                  ),*/
                ],
              ),
              const SizedBox(height: 16),
              // Apply button
              ElevatedButton(
                onPressed: () {
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
