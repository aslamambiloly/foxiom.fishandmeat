import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductsApi {
  static const String _baseUrl = "https://fishandmeatapp.onrender.com/api";

  Future<Map<String, dynamic>> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      return {'success': false, 'message': 'Authentication token not found'};
    }

    final url = Uri.parse('$_baseUrl/products/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> fetchProductById(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      return {'success': false, 'message': 'Authentication token not found'};
    }
    final url = Uri.parse('$_baseUrl/products/$productId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> submitReview({
    required String productId,
    required double rating,
    required String review,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      return {'success': false, 'message': 'Authentication token not found'};
    }

    final url = Uri.parse('$_baseUrl/products/$productId/review');
    try {
      final resp = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'rating': rating, 'review': review}),
      );

      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      // If the server wants you to detect HTTP errors separately:
      if (resp.statusCode != 200 && resp.statusCode != 201) {
        return {
          'success': false,
          'message': body['message'] ?? 'Server error ${resp.statusCode}',
        };
      }

      return body;
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
