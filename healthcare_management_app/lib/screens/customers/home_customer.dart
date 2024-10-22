import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/models/user.dart';
import 'package:healthcare_management_app/screens/comons/edit_profile.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';
import 'package:healthcare_management_app/screens/customers/booking.dart';
import 'package:healthcare_management_app/screens/customers/health_index.dart';
import 'package:healthcare_management_app/screens/customers/online_consultation.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          children: [
            // Hiển thị tên người dùng và avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Xin chào ${user.name}',
                  style: AppTheme.theme.textTheme.displayMedium,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('lib/assets/Avatar.png'), // Đường dẫn đến avatar
                  radius: 24, // Kích thước của avatar
                ),
              ],
            ),
            SizedBox(height: AppTheme.largeSpacing),
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
                                padding: const EdgeInsets.all(AppTheme.Padding8),
                                child: Text(
                                  'Thông tin cá nhân',
                                  style: AppTheme.theme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0), // Padding tối thiểu
                              child: Image.asset(
                                'lib/assets/Stomach.png',
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
                                padding: const EdgeInsets.all(AppTheme.Padding8),
                                child: Text(
                                  'Đặt lịch khám',
                                  style: AppTheme.theme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0), // Padding tối thiểu
                              child: Image.asset(
                                'lib/assets/Bag.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToScreen(context, Booking(user: user));
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
                                padding: const EdgeInsets.all(AppTheme.Padding8),
                                child: Text(
                                  'Chỉ số sức khỏe',
                                  style: AppTheme.theme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0), // Padding tối thiểu
                              child: Image.asset(
                                'lib/assets/Lifesavers Electrocardiogram.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToScreen(context, HealthIndex(user: user)); // Chuyển đến màn hình chỉ số sức khỏe
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
                                padding: const EdgeInsets.all(AppTheme.Padding8),
                                child: Text(
                                  'Lịch sử khám',
                                  style: AppTheme.theme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0), // Padding tối thiểu
                              child: Image.asset(
                                'lib/assets/Lifesavers Stethoscope.png',
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
                                padding: const EdgeInsets.all(AppTheme.Padding8),
                                child: Text(
                                  'Tư vấn online',
                                  style: AppTheme.theme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0), // Padding tối thiểu
                              child: Image.asset(
                                'lib/assets/Lifesavers Bust.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToScreen(context, OnlineConsultation(user:user)); // Chuyển đến màn hình tư vấn online
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
