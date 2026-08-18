import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_providers.dart';

import '../providers/filter_provider.dart';
import 'product_card.dart';

class ProductGrid extends ConsumerWidget {
  const ProductGrid({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final productsAsync =
        ref.watch(filteredProductsProvider);

    return productsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),

      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
            ),

            const SizedBox(height: 12),

            const Text(
              'Failed to load products',
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                ref.invalidate(productsProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),

      data: (products) {
        if (products.isEmpty) {
          return const Center(
            child: Text(
              'No products found',
            ),
          );
        }

        return GridView.builder(
          padding:
              const EdgeInsets.all(12),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemCount: products.length,
          itemBuilder: (_, index) {
            return ProductCard(
              product: products[index],
            );
          },
        );
      },
    );
  }
}