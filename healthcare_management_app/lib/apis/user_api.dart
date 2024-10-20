import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:healthcare_management_app/models/user.dart';

const baseURL = "http://localhost:8080/users";

class UserApi {
  Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse(baseURL));

    if (response.statusCode == 200) {
      final decodeResponse = jsonDecode(response.body) as List;
      // In thông tin người dùng ra console
      for (var userJson in decodeResponse) {
        User user = User.fromJson(userJson);
        print('User ID: ${user.id}, Name: ${user.name}, Email: ${user.email}');
      }
      return decodeResponse.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

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

  Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseURL/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> updateProduct(User user) async {
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

  Future<void> lockUser(int id) async {
    final response = await http.put(
      Uri.parse('$baseURL/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': 'LOCKED'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to lock user: ${response.statusCode}');
    }
  }
}
