import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:healthcare_management_app/apis/auth.dart';
import 'package:healthcare_management_app/apis/user_api.dart';
import 'package:healthcare_management_app/dto/login_dto.dart';
import '../dto/register.dart';
import '../models/user.dart'; // Giả sử bạn có một model User


class AuthProvider with ChangeNotifier {
  final Auth authApi;
  String? _token;
  User? _currentUser; // lay thong tin user

  AuthProvider({required this.authApi});

  // Getter cho token
  String? get token => _token;
  User? get currentUser => _currentUser;

  // Phương thức đăng ký
  Future<void> register(Register regis) async {
    await authApi.register(regis);
    notifyListeners();
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
