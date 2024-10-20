import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/models/user.dart';
import 'package:healthcare_management_app/screens/comons/edit_profile.dart';
import '../comons/customBottomNavBar.dart';

class HomeCustomer extends StatelessWidget {
  final User user;

  const HomeCustomer({super.key, required this.user});

  // Điều hướng tới màn hình tương ứng
  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dịch vụ khách hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Hiển thị tên người dùng và avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Xin chào ${user.name}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('lib/assets/Avatar.png'), // Đường dẫn đến avatar
                  radius: 24, // Kích thước của avatar
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  // Mục Thông tin cá nhân
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Thông tin cá nhân',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0), // Thêm padding cho ảnh
                              child: Image.asset(
                                'lib/assets/Stomach.png', // Đường dẫn ảnh
                                height: double.infinity, // Ảnh sẽ chiếm toàn bộ chiều cao của Card
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToScreen(context, EditProfileScreen(user: user)); // Chuyển đến màn hình thông tin cá nhân
                        },
                      ),
                    ),
                  ),

                  // Mục Đặt lịch khám
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Đặt lịch khám',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'lib/assets/Bag.png',
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          //_navigateToScreen(context, AppointmentScreen()); // Chuyển đến màn hình đặt lịch khám
                        },
                      ),
                    ),
                  ),

                  // Mục Chỉ số sức khỏe
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Chỉ số sức khỏe',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'lib/assets/Lifesavers Electrocardiogram.png',
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                         // _navigateToScreen(context, HealthMetricsScreen()); // Chuyển đến màn hình chỉ số sức khỏe
                        },
                      ),
                    ),
                  ),

                  // Mục Lịch sử khám
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Lịch sử khám',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'lib/assets/Lifesavers Stethoscope.png',
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          //_navigateToScreen(context, MedicalHistoryScreen()); // Chuyển đến màn hình lịch sử khám
                        },
                      ),
                    ),
                  ),

                  // Mục Tư vấn online
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Tư vấn online',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'lib/assets/Lifesavers Bust.png',
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                         // _navigateToScreen(context, OnlineConsultationScreen()); // Chuyển đến màn hình tư vấn online
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation
        },
      ),
    );
  }
}
