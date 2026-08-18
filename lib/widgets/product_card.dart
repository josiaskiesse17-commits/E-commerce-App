import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends ConsumerStatefulWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductCard> createState() =>
      _ProductCardState();
}

class _ProductCardState
    extends ConsumerState<ProductCard> {
  bool _addedToCart = false;

  void _addToCart() {
    ref
        .read(cartProvider.notifier)
        .addProduct(widget.product);

    setState(() {
      _addedToCart = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart'),
        duration: Duration(seconds: 1),
      ),
    );

    Future.delayed(
      const Duration(milliseconds: 1200),
      () {
        if (mounted) {
          setState(() {
            _addedToCart = false;
          });
        }
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final favorites =
        ref.watch(favoritesProvider);

    final isFavorite =
        favorites.contains(widget.product.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ProductDetailScreen(
                product: widget.product,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag:
                          'product-image-${widget.product.id}',
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (
                              context,
                              error,
                              stackTrace,
                            ) {
                          return const Icon(
                            Icons.image_not_supported,
                          );
                        },
                      ),
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor:
                          Colors.white,
                      child: IconButton(
                        onPressed: () {
                          ref
                              .read(
                                favoritesProvider
                                    .notifier,
                              )
                              .toggleFavorite(
                                widget.product.id,
                              );
                        },
                        icon: AnimatedScale(
                          scale: isFavorite
                              ? 1.2
                              : 1.0,
                          duration:
                              const Duration(
                            milliseconds: 200,
                          ),
                          curve:
                              Curves.easeOutBack,
                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      Text(
                        widget.product.rating
                            .toString(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  SizedBox(
                    width: double.infinity,
                    child: AnimatedSwitcher(
                      duration:
                          const Duration(
                        milliseconds: 250,
                      ),
                      transitionBuilder:
                          (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child:
                          ElevatedButton.icon(
                        key: ValueKey(
                          _addedToCart,
                        ),
                        onPressed: _addedToCart
                            ? null
                            : _addToCart,
                        icon: Icon(
                          _addedToCart
                              ? Icons.check
                              : Icons.shopping_cart,
                        ),
                        label: Text(
                          _addedToCart
                              ? 'Added!'
                              : 'Add to cart',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}