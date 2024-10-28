import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:healthcare_management_app/models/user.dart';

import '../models/role.dart';

const baseURL = "http://localhost:8080/users";

class UserApi {
  // Phương thức để lấy tất cả người dùng
  Future<String> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse(baseURL));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Phương thức để thêm người dùng
  Future<User> addUser(User user) async {
    final response = await http.post(
      Uri.parse(baseURL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add user');
    }
  }

  // Phương thức để lấy thông tin người dùng theo ID
  Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseURL/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  // Phương thức để cập nhật thông tin người dùng
  Future<User> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$baseURL/${user.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  // // Phương thức để khóa người dùng
  // Future<void> lockUser(int id) async {
  //   final response = await http.put(
  //     Uri.parse('$baseURL/$id'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({'status': 'LOCKED'}),
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to lock user: ${response.statusCode}');
  //   }
  // }

  // Phương thức để lấy thông tin người dùng theo username
  Future<User> getUserByUsername(String username, String? token) async {
    final response = await http.get(
      Uri.parse('$baseURL?username=$username'),
      headers: {
        'Authorization': 'Bearer $token', // Gửi token trong header
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user by username');
    }
  }
  Future<List<Role>> getRolesByUserId(int userId, String? token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/$userId/roles'), // Đường dẫn lấy vai trò
        headers: {
          'Authorization': 'Bearer $token', // Thêm token vào header
        },
      );

      if (response.statusCode == 200) {
        // In ra phản hồi để kiểm tra
        print('Response body: ${response.body}');

        final List<dynamic> rolesJson = jsonDecode(response.body); // Giải mã JSON
        return List<Role>.from(rolesJson.map((data) => Role.fromJson(data))); // Chuyển đổi thành List<Role>
      } else {
        throw Exception('Failed to load roles for user: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching roles: $error');
    }
  }

}
