import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cart_provider.dart';
import '../providers/filter_provider.dart';
import '../widgets/product_grid.dart';
import 'cart_screen.dart';
import 'favorite_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final cartCount =
        ref.watch(cartItemCountProvider);

    final category =
        ref.watch(categoryProvider);

    final sort =
        ref.watch(sortProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),

          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CartScreen(),
                      ),
                    );
                  },
                ),

                if (cartCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: CircleAvatar(
                      radius: 9,
                      child: Text(
                        '$cartCount',
                        style:
                            const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],

          bottom: const TabBar(
            tabs: [
              Tab(text: 'Products'),
              Tab(text: 'Favorites'),
              Tab(text: 'Profile'),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: (value) {
                      ref
                          .read(
                            searchQueryProvider
                                .notifier,
                          )
                          .state = value;
                    },
                    decoration:
                        const InputDecoration(
                      hintText:
                          'Search products...',
                      prefixIcon:
                          Icon(Icons.search),
                      border:
                          OutlineInputBorder(),
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child:
                            DropdownButton<String?>(
                          value: category,
                          isExpanded: true,
                          hint: const Text(
                            'Category',
                          ),
                          items: const [
                            DropdownMenuItem<
                                String?>(
                              value: null,
                              child: Text(
                                'All categories',
                              ),
                            ),
                            DropdownMenuItem(
                              value:
                                  'Electronics',
                              child: Text(
                                'Electronics',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'Fashion',
                              child: Text(
                                'Fashion',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'Home',
                              child: Text(
                                'Home',
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            ref
                                .read(
                                  categoryProvider
                                      .notifier,
                                )
                                .state = value;
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child:
                            DropdownButton<
                                SortOption?>(
                          value: sort,
                          isExpanded: true,
                          hint: const Text(
                            'Sort',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: null,
                              child: Text(
                                'Default',
                              ),
                            ),
                            DropdownMenuItem(
                              value: SortOption
                                  .priceLowToHigh,
                              child: Text(
                                'Price ↑',
                              ),
                            ),
                            DropdownMenuItem(
                              value: SortOption
                                  .priceHighToLow,
                              child: Text(
                                'Price ↓',
                              ),
                            ),
                            DropdownMenuItem(
                              value:
                                  SortOption.rating,
                              child: Text(
                                'Rating',
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            ref
                                .read(
                                  sortProvider
                                      .notifier,
                                )
                                .state = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                const Expanded(
                  child: ProductGrid(),
                ),
              ],
            ),

            const FavoritesScreen(),

            const ProfileScreen(),
          ],
        ),
      ),
    );
  }
}