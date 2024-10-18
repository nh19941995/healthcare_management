import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserService {
  static const String _baseUrl = 'http://172.27.48.1:8080/public'; // Đổi địa chỉ IP nếu cần

  static Future<User?> fetchUser() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
}