import 'package:flutter/material.dart';
import 'package:healthcare_management_app/models/user.dart';

class EditProfileScreen extends StatelessWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar và nút thay đổi ảnh
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('lib/assets/Avatar.png'), // Sử dụng ảnh từ user
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Hành động khi nhấn 'Change Picture'
                    },
                    child: const Text(
                      'Change Picture',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form để chỉnh sửa thông tin người dùng
            TextFormField(
              initialValue: user.name, // Tên người dùng từ đối tượng user
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: user.email, // Email từ đối tượng user
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: user.phone, // Số điện thoại từ đối tượng user
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: user.password, // Mật khẩu từ đối tượng user
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Để ẩn mật khẩu
            ),
            const SizedBox(height: 30),

            // Nút cập nhật
            ElevatedButton(
              onPressed: () {
                // Hành động khi nhấn 'Update'
              },
              child: const Text('Update'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
