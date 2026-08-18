import '../data/mock_products.dart';
import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> getProducts() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    return mockProducts;
  }
}