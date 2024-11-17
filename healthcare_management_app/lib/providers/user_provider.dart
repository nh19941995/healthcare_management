
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/apis/auth.dart'; // Auth API import
import 'package:healthcare_management_app/apis/user_api.dart';
import 'package:healthcare_management_app/dto/login_dto.dart';
import 'package:healthcare_management_app/dto/user_dto.dart';
import 'package:flutter/foundation.dart'; // Thêm dòng này để kiểm tra nền tảng

class UserProvider with ChangeNotifier {
  final UserApi userApi;
  final Auth authApi; // Added Auth API to UserProvider

  UserProvider({required this.userApi, required this.authApi}); // Updated constructor

  final List<UserDTO> _list = [];
  List<UserDTO> get list => _list;
  UserDTO? _user;
  String? image;

  UserDTO? get user => _user;

  Future getAllUser() async {
    final users = await UserApi().getUsersByAdmin();
    _list.clear();
    _list.addAll(users);

    // In ra danh sách _list để kiểm tra
    print('Danh sách các user:');
    for (var user in _list) {
      print(user); // Sử dụng toString() của Clinic hoặc in ra các thuộc tính cụ thể
    }

    notifyListeners();
  }
  // Update existing user information in API and list
  Future<void> updateUser(UserDTO user) async {
    final updatedUser = await userApi.updateUser(user);
    final index = _list.indexWhere((element) => element.id == updatedUser.id);
    if (index != -1) {
      _list[index] = updatedUser as UserDTO;
      notifyListeners();
    }
  }

  // Fetch current user information based on username
  Future<void> fetchUser() async {
    UserDTO fetchedUser = await UserApi().getUserByUserName();
    _user = fetchedUser;
    print("id: ${fetchedUser.id}");
    notifyListeners();
  }

  void logout() {
    _user = null; // Xóa thông tin người dùng
    notifyListeners(); // Thông báo cho UI rằng thông tin người dùng đã thay đổi
  }

  Future<void> updateUserRole(String username, String role) async {
    final updateRole = await userApi.updateUserRole(username, role);
    notifyListeners();
  }

  Future<void> deleteUser(String username) async {
    final deleteuser = userApi.deleteUser(username);
    list.removeWhere((user) => user.username == username);
    notifyListeners();
  }



   Future<String?> uploadImage(dynamic imageFile) async {
    try {
      String? imageUrl;
          imageUrl = await userApi.uploadImageAsFormData(imageFile);
      // Cập nhật và thông báo thay đổi
      image = imageUrl;
      notifyListeners();

    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

}
