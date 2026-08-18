import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorites_provider.dart';
import '../providers/product_providers.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final favorites =
        ref.watch(favoritesProvider);

    final productsAsync =
        ref.watch(productsProvider);

    return productsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),

      error: (error, stackTrace) =>
          Center(
        child: Text(
          'Error: $error',
        ),
      ),

      data: (products) {
        final favoriteProducts =
            products
                .where(
                  (product) =>
                      favorites.contains(
                    product.id,
                  ),
                )
                .toList();

        if (favoriteProducts.isEmpty) {
          return const Center(
            child: Text(
              'No favorite products yet',
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemCount: favoriteProducts.length,
          itemBuilder: (_, index) {
            return ProductCard(
              product:
                  favoriteProducts[index],
            );
          },
        );
      },
    );
  }
}