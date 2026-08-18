import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final cart = ref.watch(cartProvider);

    final total =
        ref.watch(cartTotalProvider);

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: const Center(
          child: Text(
            'Your cart is empty',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (_, index) {
                final item = cart[index];

                return ListTile(
                  leading: Image.network(
                    item.product.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),

                  title: Text(
                    item.product.name,
                  ),

                  subtitle: Text(
                    '\$${item.product.price.toStringAsFixed(2)}',
                  ),

                  trailing: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove,
                        ),
                        onPressed: () {
                          ref
                              .read(
                                cartProvider
                                    .notifier,
                              )
                              .decreaseQuantity(
                                item.product.id,
                              );
                        },
                      ),

                      Text(
                        '${item.quantity}',
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.add,
                        ),
                        onPressed: () {
                          ref
                              .read(
                                cartProvider
                                    .notifier,
                              )
                              .increaseQuantity(
                                item.product.id,
                              );
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                        ),
                        onPressed: () {
                          ref
                              .read(
                                cartProvider
                                    .notifier,
                              )
                              .removeProduct(
                                item.product.id,
                              );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),

                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}