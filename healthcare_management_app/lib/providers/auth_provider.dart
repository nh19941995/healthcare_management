import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:healthcare_management_app/apis/auth.dart';
import 'package:healthcare_management_app/apis/user_api.dart';
import 'package:healthcare_management_app/dto/login_dto.dart';
import '../dto/register.dart';
import '../models/user.dart'; // Giả sử bạn có một model User
import '../models/role.dart'; // Giả sử bạn có một model Role

class AuthProvider with ChangeNotifier {
  final Auth authApi;
  String? _token;
  User? _currentUser;

  AuthProvider({required this.authApi});

  // Getter cho token
  String? get token => _token;
  User? get currentUser => _currentUser;

  // Phương thức đăng ký
  Future<void> register(Register regis) async {
    await authApi.register(regis);
    notifyListeners();
  }

  // Phương thức đăng nhập
  Future<void> login(LoginDto loginDto) async {
    try {
      // Gọi API đăng nhập và nhận phản hồi HTTP
      final response = await authApi.login(loginDto);

      // Chuyển đổi phản hồi JSON thành Map (giải mã body từ response)
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Kiểm tra nếu phản hồi chứa token
      if (jsonResponse.containsKey('token')) {
        _token = jsonResponse['token']; // Gán token
        notifyListeners();
      } else {
        throw Exception('Không tìm thấy token trong phản hồi');
      }
    } catch (error) {
      throw Exception('Đăng nhập thất bại: $error'); // Xử lý lỗi
    }
  }


  // Phương thức để lấy thông tin người dùng dựa trên token
  Future<void> getUserInfo() async {
    try {
      if (_token != null) {
        final response = await authApi.getUserInfo(_token!); // Gọi API để lấy thông tin người dùng
        _currentUser = User.fromJson(response as Map<String, dynamic>); // Chuyển đổi từ JSON sang đối tượng User
        notifyListeners(); // Thông báo cho mọi widget đang lắng nghe
      }
    } catch (error) {
      throw error; // Xử lý lỗi nếu có
    }
  }

}
