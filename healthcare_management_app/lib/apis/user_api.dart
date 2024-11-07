import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:healthcare_management_app/models/user.dart';

import '../dto/user_dto.dart';
import '../models/role.dart';
import '../screens/comons/TokenManager.dart';

const baseURL = "http://localhost:8080/users";
const baseUpdateUser = "http://localhost:8080/api/users";

class UserApi {
  late String username;

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
  // Phương thức để cập nhật thông tin người dùng
  Future<User> updateUser(UserDTO user) async {
    final String? token = TokenManager().getToken();

    final response = await http.put(
      Uri.parse(baseUpdateUser), // Địa chỉ API để cập nhật người dùng
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
        'Content-Type': 'application/json', // Định dạng nội dung
      },
      body: jsonEncode(user.toJson()), // Chuyển đổi UserDTO thành JSON
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to update user. Status code: ${response.statusCode}');
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
  Future<UserDTO> getUserByUserName() async {
    final String? username = TokenManager().getUserSub();
    final String? token = TokenManager().getToken(); // Lấy token từ TokenManager

    print('Username: $username');
    print('Token: $token'); // In token ra để kiểm tra nếu cần

    final String urlGetUser = 'http://localhost:8080/api/users/$username';

    final response = await http.get(
      Uri.parse(urlGetUser),
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
      },
    );

    if (response.statusCode == 200) {
      // Chuyển đổi phản hồi sang UTF-8
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print('Data from API: $data'); // In ra dữ liệu từ API để kiểm tra

      return UserDTO.fromJson(data);
    } else {
      print('Failed to load user data. Status code: ${response.statusCode}');
      throw Exception('Failed to load user data');
    }
  }
  //

}
