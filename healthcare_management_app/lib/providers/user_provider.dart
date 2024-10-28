import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/apis/auth.dart'; // Nhập khẩu Auth API
import 'package:healthcare_management_app/apis/user_api.dart';
import 'package:healthcare_management_app/dto/login_dto.dart';
import 'package:healthcare_management_app/models/user.dart';
import 'package:healthcare_management_app/screens/comons/login.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserProvider with ChangeNotifier {
  final UserApi userApi;
  final Auth authApi; // Thêm Auth API vào UserProvider

  UserProvider({required this.userApi, required this.authApi}); // Cập nhật constructor

  final List<User> _list = [];
  List<User> get list => _list;

  User? _currentUser; // Lưu thông tin người dùng hiện tại
  User? get currentUser => _currentUser; // Getter cho currentUser

  // Phương thức để lấy tất cả người dùng từ API
  Future<void> getAllUser() async {
    try {
      String jsonResponse = await userApi.getAllUsers();
      var decodedJson = jsonDecode(jsonResponse);

      var embedded = decodedJson['_embedded'];
      if (embedded != null && embedded['users'] != null) {
        var usersJson = embedded['users'];

        _list.clear();

        for (var userJson in usersJson) {
          int id = userJson['id'] ?? 0; // Gán giá trị mặc định nếu null
          String name = userJson['name'] ?? 'Unknown'; // Gán giá trị mặc định nếu null
          String username = userJson['username'] ?? 'Unknown'; // Gán giá trị mặc định nếu null
          String email = userJson['email'] ?? ''; // Gán giá trị mặc định nếu null
          String status = userJson['status'] ?? ''; // Gán giá trị mặc định nếu null
          DateTime createdAt = userJson['createdAt'] != null
              ? DateTime.parse(userJson['createdAt'])
              : DateTime.now(); // Gán giá trị mặc định nếu null

          User user = User(
            id: id,
            name: name,
            email: email,
            status: status,
            createdAt: createdAt,
            address: userJson['address'] ?? '', // Gán giá trị mặc định nếu null
            avatar: userJson['avatar'] ?? '',
            deletedAt: userJson['deletedAt'] != null
                ? DateTime.parse(userJson['deletedAt'])
                : null,
            description: userJson['description'] ?? '', // Gán giá trị mặc định nếu null
            gender: userJson['gender'] ?? '', // Gán giá trị mặc định nếu null
            lockReason: userJson['lockReason'] ?? '', // Gán giá trị mặc định nếu null
            password: userJson['password'] ?? '', // Gán giá trị mặc định nếu null
            phone: userJson['phone'] ?? '', // Gán giá trị mặc định nếu null
            updatedAt: userJson['updatedAt'] != null
                ? DateTime.parse(userJson['updatedAt'])
                : null,
            roleId: null, // Nếu bạn có trường roleId, cập nhật ở đây
          );

          _list.add(user);
        }

        notifyListeners();
      } else {
        print('No users found');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  // Phương thức để lấy thông tin người dùng dựa trên token
  Future<void> getUserInfo(String token) async {
    try {
      if (token.isNotEmpty) {
        Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
        String username = jwtDecodedToken['username'];

        // Tạo một đối tượng User từ thông tin trong token
        _currentUser = LoginDto(username: username) as User?; // Cập nhật theo cách bạn đã định nghĩa lớp User

        notifyListeners(); // Thông báo cho mọi widget đang lắng nghe
      } else {
        throw Exception('Token không hợp lệ');
      }
    } catch (error) {
      print('Error fetching user info: $error');
      throw error; // Ném lại lỗi để xử lý ở nơi gọi
    }
  }

  Future<void> insertUser(User user) async {
    final newUser = await userApi.addUser(user);
    _list.add(newUser); // Sửa từ 'list.add(newUser);' thành '_list.add(newUser);'
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    final newUser = await userApi.updateUser(user);
    final index = _list.indexWhere((element) => element.id == newUser.id); // Sửa từ 'list.indexWhere' thành '_list.indexWhere'
    if (index != -1) {
      _list[index] = newUser; // Cập nhật người dùng trong danh sách
      notifyListeners();
    }
  }

// Bạn có thể thêm các phương thức khác như lockUser ở đây
}
