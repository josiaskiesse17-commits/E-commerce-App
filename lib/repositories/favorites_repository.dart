import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  static const String _key = 'favorite_product_ids';

  Future<Set<int>> loadFavorites() async {
    final preferences = await SharedPreferences.getInstance();

    final ids = preferences.getStringList(_key) ?? [];

    return ids.map(int.parse).toSet();
  }

  Future<void> saveFavorites(Set<int> ids) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setStringList(
      _key,
      ids.map((id) => id.toString()).toList(),
    );
  }
}