import 'package:flutter/material.dart';
import 'package:healthcare_management_app/apis/user_api.dart';
import 'package:healthcare_management_app/models/user.dart';

class UserProvider with ChangeNotifier {
  final UserApi userApi;

  UserProvider({required this.userApi});

  final List<User> _list = [];
  List<User> get list => _list;

  Future<void> getAllUser() async {
    final users = await userApi.getAllUsers();
    _list.clear();
    _list.addAll(users);
    notifyListeners();
  }

  Future<void> insertUser(User user) async {
    final newUser = await userApi.addUser(user);
    _list.add(newUser); // Sửa từ 'list.add(newUser);' thành '_list.add(newUser);'
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    final newUser = await userApi.updateProduct(user);
    final index = _list.indexWhere((element) => element.id == newUser.id); // Sửa từ 'list.indexWhere' thành '_list.indexWhere'
    if (index != -1) {
      _list[index] = newUser; // Cập nhật người dùng trong danh sách
      notifyListeners();
    }
  }

  Future<void> lockUser(int id) async {
    await userApi.lockUser(id);

    // Cập nhật danh sách người dùng
    int index = _list.indexWhere((user) => user.id == id); // Sửa từ 'list.indexWhere' thành '_list.indexWhere'
    if (index != -1) {
      _list[index].status = 'LOCKED'; // Cập nhật trạng thái thành 'LOCKED'
      notifyListeners();
    }
  }
}
