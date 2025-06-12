import 'package:ecom_one/utils/toast.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ecom_one/services/api/products.api.dart';
import 'package:ecom_one/services/api/users.api.dart';

class BottomSheetController extends GetxController {
  BottomSheetController(this.productId);

  final reviewText = TextEditingController();
  final String productId;
  final _api = ProductsApi();
  final _usersApi = UsersApi();
  final seeMoreReviews = false.obs;
  Rxn<Map<String, dynamic>> details = Rxn<Map<String, dynamic>>();
  final pincode = TextEditingController();
  final isChecking = false.obs;
  final RxnBool pinAvailable = RxnBool();
  RxList<int> availabilityList = <int>[].obs;
  final RxMap<String, String> _userNames = <String, String>{}.obs;

  String getUsername(String userId) => _userNames[userId] ?? 'Unknown';

  final dialogRating = 0.0.obs;

  Future<void> submitRating(context) async {
    final rating = dialogRating.value;
    final reviewBody = reviewText.text.trim();

    final result = await _api.submitReview(
      productId: productId,
      rating: rating,
      review: reviewBody,
    );

    if (result['success'] == true) {
      ToastHelper.showSuccessToast(
        context,
        'Success',
        result['message'] ?? 'Review added',
      );
      await fetchDetails();
      reviewText.clear();
      dialogRating.value = 0.0;
      seeMoreReviews.value = true;
    } else {
      ToastHelper.showErrorToast(
        context,
        'Error',
        result['message'] ?? 'Failed to submit review',
      );
    }
  }

  /// Fetch product details
  Future<Map<String, dynamic>> fetchDetails() async {
    final rsp = await _api.fetchProductById(productId);
    if (rsp['success'] == true && rsp['data'] != null) {
      final data = rsp['data'] as Map<String, dynamic>;
      details.value = data;

      final p = data['product'] as Map<String, dynamic>;
      final raw = p['availability'] as List<dynamic>? ?? [];
      availabilityList.assignAll(raw.cast<num>().map((n) => n.toInt()));
    }
    return rsp;
  }

  /// username lookup + cache
  Future<String> fetchUsername(String userId) async {
    if (_userNames.containsKey(userId)) {
      return _userNames[userId]!;
    }

    try {
      final rsp = await _usersApi.fetchUserById(userId);
      if (rsp['success'] == true && rsp['data'] != null) {
        final username =
            (rsp['data'] as Map<String, dynamic>)['username'] as String;
        _userNames[userId] = username;
        return username;
      }
    } catch (_) {}

    _userNames[userId] = 'Unknown';
    return 'Unknown';
  }

  void checkPincode() {
    final pin = int.tryParse(pincode.text.trim());
    if (pin == null || pincode.text.trim().length != 6) {
      pinAvailable.value = false;
      return;
    }
    isChecking.value = true;
    Future.delayed(Duration(milliseconds: 500), () {
      pinAvailable.value = availabilityList.contains(pin);
      isChecking.value = false;
    });
  }
}
