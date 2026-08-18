import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addProduct(Product product) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex == -1) {
      state = [
        ...state,
        CartItem(
          product: product,
          quantity: 1,
        ),
      ];
      return;
    }

    final updated = [...state];

    updated[existingIndex] = updated[existingIndex].copyWith(
      quantity: updated[existingIndex].quantity + 1,
    );

    state = updated;
  }

  void removeProduct(int productId) {
    state = state
        .where(
          (item) => item.product.id != productId,
        )
        .toList();
  }

  void increaseQuantity(int productId) {
    final updated = state.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(
          quantity: item.quantity + 1,
        );
      }

      return item;
    }).toList();

    state = updated;
  }

  void decreaseQuantity(int productId) {
    final existing = state.firstWhere(
      (item) => item.product.id == productId,
    );

    if (existing.quantity <= 1) {
      removeProduct(productId);
      return;
    }

    final updated = state.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(
          quantity: item.quantity - 1,
        );
      }

      return item;
    }).toList();

    state = updated;
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

final cartItemCountProvider = Provider<int>(
  (ref) {
    final cart = ref.watch(cartProvider);

    return cart.fold(
      0,
      (total, item) => total + item.quantity,
    );
  },
);

final cartTotalProvider = Provider<double>(
  (ref) {
    final cart = ref.watch(cartProvider);

    return cart.fold(
      0,
      (total, item) => total + item.totalPrice,
    );
  },
);