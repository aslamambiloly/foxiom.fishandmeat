import 'package:ecom_one/services/api/products.api.dart';

class AffordablesController {
  const AffordablesController();

  Future<Map<String, dynamic>> fetchProducts() {
    return ProductsApi().fetchProducts();
  }

  Future<List<Map<String, dynamic>>> fetchAffordableProducts({
    int count = 5,
    num maxPrice = 500,
  }) async {
    final response = await fetchProducts();
    if (response['success'] != true || response['data'] == null) {
      throw Exception('Failed to load products');
    }
    final all =
        (response['data']['products'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
    final affordable =
        all.where((p) {
          final price = p['price'];
          final num priceNum =
              price is num
                  ? price
                  : num.tryParse(price.toString()) ?? double.infinity;
          return priceNum <= maxPrice;
        }).toList();
    return affordable.length > count
        ? affordable.take(count).toList()
        : affordable;
  }
}
