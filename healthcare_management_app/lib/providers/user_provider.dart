import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/apis/auth.dart'; // Auth API import
import 'package:healthcare_management_app/apis/user_api.dart';
import 'package:healthcare_management_app/dto/login_dto.dart';
import 'package:healthcare_management_app/dto/user_dto.dart';
import 'package:healthcare_management_app/models/user.dart';
import 'package:healthcare_management_app/screens/comons/login.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserProvider with ChangeNotifier {
  final UserApi userApi;
  final Auth authApi; // Added Auth API to UserProvider

  UserProvider({required this.userApi, required this.authApi}); // Updated constructor

  final List<User> _list = [];
  List<User> get list => _list;
  UserDTO? _user;

  UserDTO? get user => _user;


  // Fetch all users from the API
  Future<void> getAllUser() async {
    try {
      String jsonResponse = await userApi.getAllUsers();
      var decodedJson = jsonDecode(jsonResponse);

      var embedded = decodedJson['_embedded'];
      if (embedded != null && embedded['users'] != null) {
        var usersJson = embedded['users'];

        _list.clear();

        for (var userJson in usersJson) {
          User user = User(
            id: userJson['id'] ?? 0,
            name: userJson['name'] ?? 'Unknown',
            email: userJson['email'] ?? '',
            status: userJson['status'] ?? '',
            createdAt: userJson['createdAt'] != null
                ? DateTime.parse(userJson['createdAt'])
                : DateTime.now(),
            address: userJson['address'] ?? '',
            avatar: userJson['avatar'] ?? '',
            deletedAt: userJson['deletedAt'] != null
                ? DateTime.parse(userJson['deletedAt'])
                : null,
            description: userJson['description'] ?? '',
            gender: userJson['gender'] ?? '',
            lockReason: userJson['lockReason'] ?? '',
            password: userJson['password'] ?? '',
            phone: userJson['phone'] ?? '',
            updatedAt: userJson['updatedAt'] != null
                ? DateTime.parse(userJson['updatedAt'])
                : null,
            roleId: null, // Update if you have a roleId field
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

  // Insert new user into API and list
  Future<void> insertUser(User user) async {
    final newUser = await userApi.addUser(user);
    _list.add(newUser);
    notifyListeners();
  }

  // Update existing user information in API and list
  Future<void> updateUser(UserDTO user) async {
    final updatedUser = await userApi.updateUser(user);
    final index = _list.indexWhere((element) => element.id == updatedUser.id);
    if (index != -1) {
      _list[index] = updatedUser;
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

  // Log out the user and reset the current user data
  // Future<void> logout() async {
  //   await authApi.logout(); // Clear user session in Auth API
  //   _currentUser = null;
  //   _list.clear();
  //   notifyListeners();
  // }
  void logout() {
    _user = null; // Xóa thông tin người dùng
    notifyListeners(); // Thông báo cho UI rằng thông tin người dùng đã thay đổi
  }
}
