import 'package:flutter/material.dart';
import 'package:healthcare_management_app/screens/comons/Update_profile.dart';
import 'package:healthcare_management_app/screens/comons/login.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';
import 'package:healthcare_management_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../doctor/Update_doctor.dart';

class MenuUtils {
  static void showVerticalMenu(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userDto = userProvider.user;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mục "Cập nhật thông tin người dùng"
              GestureDetector(
                onTap: () {
                  // Điều hướng đến trang chỉnh sửa thông tin người dùng
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(userDTO: userDto),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Text('Cập nhật thông tin', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              // Nếu userDto.roles không phải null và có vai trò "Doctor", hiển thị mục "Cập nhật thông tin bác sĩ"
              if (userDto?.roles?.any((role) => role.name == 'DOCTOR') ?? false) ...[
                Divider(color: Colors.white),
                GestureDetector(
                  onTap: () {
                    // Điều hướng đến trang chỉnh sửa thông tin bác sĩ
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateDoctorProfileScreen(user:userDto),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(Icons.medical_services, color: Colors.white, size: 30),
                        SizedBox(width: 10),
                        Text('Cập nhật thông tin bác sĩ', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],

              // Mục "Đăng xuất"
              GestureDetector(
                onTap: () {
                  _showLogoutConfirmation(context, userProvider);
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Text('Đăng xuất', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void _showLogoutConfirmation(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận đăng xuất'),
          content: Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng popup
              },
            ),
            TextButton(
              child: Text('Đăng xuất'),
              onPressed: () {
                userProvider.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()), // Đường dẫn đến màn hình đăng nhập
                      (Route<dynamic> route) => false, // Xóa tất cả các route trước đó
                );
              },
            ),
          ],
        );
      },
    );
  }
}
