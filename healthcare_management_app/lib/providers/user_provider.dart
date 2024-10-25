import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/apis/user_api.dart';
import 'package:healthcare_management_app/dto/register.dart';
import 'package:healthcare_management_app/models/user.dart';

class UserProvider with ChangeNotifier {
  final UserApi userApi;

  UserProvider({required this.userApi});

  final List<User> _list = [];
  List<User> get list => _list;


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
          // In ra thông tin người dùng ra console
          print('ID: $id, Name: $name, Username: $username, Email: $email, Status: $status, Created At: $createdAt');

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

  Future<User?> getUserByUsername(String username, String? token) async {
    try {
      return await userApi.getUserByUsername(username, token);
    } catch (error) {
      throw error; // Xử lý lỗi nếu cần
    }
  }

  // Future<void> lockUser(int id) async {
  //   await userApi.lockUser(id);
  //
  //   // Cập nhật danh sách người dùng
  //   int index = _list.indexWhere((user) => user.id == id); // Sửa từ 'list.indexWhere' thành '_list.indexWhere'
  //   if (index != -1) {
  //     _list[index].status = 'LOCKED'; // Cập nhật trạng thái thành 'LOCKED'
  //     notifyListeners();
  //   }
  // }
}
