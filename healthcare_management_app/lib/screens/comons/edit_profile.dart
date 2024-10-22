import 'package:flutter/material.dart';
import 'package:healthcare_management_app/models/user.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';

import '../../enum.dart';

class EditProfileScreen extends StatelessWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.largeSpacing),
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
                  const SizedBox(height: AppTheme.mediumSpacing),
                  TextButton(
                    onPressed: () {
                      // Hành động khi nhấn 'Change Picture'
                    },
                    child: Text(
                      'Change Picture',
                      style: AppTheme.theme.textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.largeSpacing),

            // Form để chỉnh sửa thông tin người dùng
            TextFormField(
              initialValue: user.name, // Tên người dùng từ đối tượng user
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.smallSpacing),
            TextFormField(
              initialValue: user.email, // Email từ đối tượng user
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.smallSpacing),
            TextFormField(
              initialValue: user.phone, // Số điện thoại từ đối tượng user
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.smallSpacing),
            TextFormField(
              initialValue: user.password, // Mật khẩu từ đối tượng user
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Để ẩn mật khẩu
            ),
            const SizedBox(height: AppTheme.smallSpacing),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Text("Gender", style: TextStyle(fontSize: 16)),
            //     SizedBox(width: 20),
            //     Row(
            //       children: [
            //         Radio<Gender>(
            //           value: Gender.MALE, // Sử dụng enum MALE
            //           groupValue: _selectedGender,
            //           onChanged: (Gender? value) {
            //             setState(() {
            //               _selectedGender = value; // Cập nhật giá trị
            //             });
            //           },
            //         ),
            //         Text("Male"),
            //       ],
            //     ),
            //     SizedBox(width: AppTheme.largeSpacing),
            //     Row(
            //       children: [
            //         Radio<Gender>(
            //           value: Gender.FEMALE, // Sử dụng enum FEMALE
            //           groupValue: _selectedGender,
            //           onChanged: (Gender? value) {
            //             setState(() {
            //               _selectedGender = value; // Cập nhật giá trị
            //             });
            //           },
            //         ),
            //         Text("Female"),
            //       ],
            //     ),
            //   ],
            // ),
            SizedBox(height: AppTheme.smallSpacing),
            TextFormField(
              initialValue: user.address, // Mật khẩu từ đối tượng user
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.largeSpacing),
            SizedBox(
              width: double.infinity, // Chiếm toàn bộ chiều rộng
              child: ElevatedButton(
                style: AppTheme.elevatedButtonStyle, // Sử dụng style từ AppTheme
                onPressed: ()=>{},
                child: Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
