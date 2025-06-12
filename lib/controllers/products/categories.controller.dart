import 'package:ecom_one/services/api/products.api.dart';

class CategoriesController {
  CategoriesController();

  final ProductsApi _api = ProductsApi();

  Future<List<String>> fetchAllCategories() async {
    final response = await _api.fetchProducts();
    if (response['success'] != true || response['data'] == null) {
      throw Exception('Failed to load products for categories');
    }

    final raw = response['data']['products'] as List<dynamic>;
    final seen = <String>{};

    for (var p in raw) {
      if (p is Map<String, dynamic> && p['category'] is String) {
        final cat = (p['category'] as String).trim();
        // use lowercase key for dedupe
        seen.add(cat.toLowerCase());
      }
    }

    // Format each as Capitalized (first letter uppercase)
    final formatted =
        seen.map((lower) {
          if (lower.isEmpty) return lower;
          final lc = lower.toLowerCase();
          return lc[0].toUpperCase() + lc.substring(1);
        }).toList();

    formatted.sort();

    return formatted;
  }
}
