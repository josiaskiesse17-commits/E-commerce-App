import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import 'product_providers.dart';




enum SortOption {
  priceLowToHigh,
  priceHighToLow,
  rating,
}

final searchQueryProvider = StateProvider<String>(
  (ref) => '',
);

final categoryProvider = StateProvider<String?>(
  (ref) => null,
);

final sortProvider = StateProvider<SortOption?>(
  (ref) => null,
);

final filteredProductsProvider =
    Provider<AsyncValue<List<Product>>>(
  (ref) {
    final productsAsync = ref.watch(productsProvider);

    return productsAsync.when(
      data: (products) {
        final search =
            ref.watch(searchQueryProvider).toLowerCase();

        final category =
            ref.watch(categoryProvider);

        final sort =
            ref.watch(sortProvider);

        var filtered = products.where((product) {
          final matchesSearch =
              product.name.toLowerCase().contains(search);

          final matchesCategory =
              category == null ||
              product.category == category;

          return matchesSearch && matchesCategory;
        }).toList();

        switch (sort) {
          case SortOption.priceLowToHigh:
            filtered.sort(
              (a, b) => a.price.compareTo(b.price),
            );
            break;

          case SortOption.priceHighToLow:
            filtered.sort(
              (a, b) => b.price.compareTo(a.price),
            );
            break;

          case SortOption.rating:
            filtered.sort(
              (a, b) => b.rating.compareTo(a.rating),
            );
            break;

          case null:
            break;
        }

        return AsyncValue.data(filtered);
      },

      loading: () => const AsyncValue.loading(),

      error: (error, stackTrace) =>
          AsyncValue.error(error, stackTrace),
    );
  },
);