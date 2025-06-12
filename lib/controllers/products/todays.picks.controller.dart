import 'package:ecom_one/services/api/products.api.dart';

class TodaysPicksController {
  Future<Map<String, dynamic>> fetchProducts() {
    return ProductsApi().fetchProducts();
  }

  Future<List<Map<String, dynamic>>> fetchRandomProducts({
    int count = 5,
  }) async {
    final response = await fetchProducts();
    if (response['success'] != true || response['data'] == null) {
      throw Exception('Failed to load products');
    }
    final products =
        (response['data']['products'] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .toList();
    products.shuffle();
    return products.take(count).toList();
  }
}
