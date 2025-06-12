import 'package:ecom_one/services/api/products.api.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

enum SortMode { priceAsc, priceDesc, ratingDesc, alpha }

class SearchActivityController extends GetxController {
  final TextEditingController search = TextEditingController();
  final _api = ProductsApi();
  String? _initialCategory;

  // loading & data
  final isLoading = true.obs;
  final allProducts = <Map<String, dynamic>>[].obs;
  final filteredProducts = <Map<String, dynamic>>[].obs;

  // filter & sort state
  final allCategories = <String>[].obs;
  final selectedCategories = <String>{}.obs;
  final minPrice = 0.0.obs, maxPrice = 1000.0.obs;
  final inStockOnly = false.obs;
  final minRating = 0.0.obs;
  final sortMode = SortMode.priceAsc.obs;
  final enableRatingFilter = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initialCategory = Get.arguments as String?;
    fetchAllProducts();
  }

  @override
  void onReady() {
    super.onReady();
    if (_initialCategory != null) {
      ever(isLoading, (loading) {
        if (loading == false && _initialCategory != null) {
          selectedCategories.add(_initialCategory!);
          applyFilters();
          _initialCategory = null;
        }
      });
    }
  }

  Future<void> fetchAllProducts() async {
    isLoading.value = true;
    final rsp = await _api.fetchProducts();
    if (rsp['success'] == true && rsp['data'] != null) {
      final list =
          (rsp['data']['products'] as List).cast<Map<String, dynamic>>();

      // compute avgRating per product
      for (var p in list) {
        final reviews = (p['reviews'] as List?)?.cast<Map>() ?? [];
        if (reviews.isEmpty) {
          p['avgRating'] = 0.0;
        } else {
          final sum = reviews
              .map((r) => (r['rating'] as num).toDouble())
              .reduce((a, b) => a + b);
          p['avgRating'] = sum / reviews.length;
        }
      }

      // collect unique categories (title case)
      final cats = <String>{};
      for (var p in list) {
        final c = p['category'] as String? ?? '';
        final formatted =
            c.isEmpty
                ? c
                : '${c[0].toUpperCase()}${c.substring(1).toLowerCase()}';
        cats.add(formatted);
        p['category'] = formatted;
      }

      allCategories.assignAll(cats.toList()..sort());
      allProducts.assignAll(list);
    } else {
      allProducts.clear();
      allCategories.clear();
    }

    // initialize filters
    if (allProducts.isNotEmpty) {
      final prices = allProducts.map((p) => (p['price'] as num).toDouble());
      minPrice.value = prices.reduce((a, b) => a < b ? a : b);
      maxPrice.value = prices.reduce((a, b) => a > b ? a : b);
    }
    applyFilters();
    isLoading.value = false;
  }

  void doSearch() {
    applyFilters();
  }

  void applyFilters() {
    final q = search.text.trim().toLowerCase();
    final filtered =
        allProducts.where((p) {
          final title = (p['title'] as String).toLowerCase();
          final cat = p['category'] as String;
          final price = (p['price'] as num).toDouble();
          final stock = (p['stock'] as num).toInt();
          final rating = p['avgRating'] as double;

          if (q.isNotEmpty && !title.contains(q)) return false;
          if (selectedCategories.isNotEmpty &&
              !selectedCategories.contains(cat)) {
            return false;
          }
          if (price < minPrice.value || price > maxPrice.value) return false;
          if (inStockOnly.value && stock <= 0) return false;
          if (rating < minRating.value) return false;
          return true;
        }).toList();

    filteredProducts.assignAll(filtered);
    applySort();
  }

  void applySort() {
    final list = filteredProducts.toList();
    switch (sortMode.value) {
      case SortMode.priceAsc:
        list.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
        break;
      case SortMode.priceDesc:
        list.sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
        break;
      case SortMode.ratingDesc:
        list.sort(
          (a, b) =>
              (b['avgRating'] as double).compareTo(a['avgRating'] as double),
        );
        break;
      case SortMode.alpha:
        list.sort(
          (a, b) => (a['title'] as String).compareTo(b['title'] as String),
        );
        break;
    }
    filteredProducts.assignAll(list);
  }
}
