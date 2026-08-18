import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final favorites =
        ref.watch(favoritesProvider);

    final isFavorite =
        favorites.contains(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(
                    favoritesProvider
                        .notifier,
                  )
                  .toggleFavorite(
                    product.id,
                  );
            },
            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: isFavorite
                  ? Colors.red
                  : null,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(16),
              child: Image.network(
                product.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              product.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                Text(
                  '${product.rating}',
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              product.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref
                      .read(
                        cartProvider.notifier,
                      )
                      .addProduct(product);

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Product added to cart',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart,
                ),
                label: const Text(
                  'Add to cart',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}