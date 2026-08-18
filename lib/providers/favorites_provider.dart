import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/favorites_repository.dart';

final favoritesRepositoryProvider =
    Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(),
);

class FavoritesNotifier extends StateNotifier<Set<int>> {
  final FavoritesRepository repository;

  FavoritesNotifier(this.repository) : super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    state = await repository.loadFavorites();
  }

  Future<void> toggleFavorite(int productId) async {
    final updated = {...state};

    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }

    state = updated;

    await repository.saveFavorites(state);
  }

  bool isFavorite(int productId) {
    return state.contains(productId);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<int>>(
  (ref) {
    final repository =
        ref.watch(favoritesRepositoryProvider);

    return FavoritesNotifier(repository);
  },
);