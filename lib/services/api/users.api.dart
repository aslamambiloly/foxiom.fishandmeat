// lib/services/api/users.api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsersApi {
  static const _baseUrl = 'https://fishandmeatapp.onrender.com/api';

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$_baseUrl/admin/users');
    final resp = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      return (body['data'] as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<Map<String, dynamic>> fetchUserById(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$_baseUrl/admin/user/$userId');
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
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }
}
