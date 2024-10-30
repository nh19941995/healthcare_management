import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/models/user.dart';
import 'package:healthcare_management_app/screens/comons/edit_profile.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';
import '../comons/customBottomNavBar.dart';

class HealthIndex extends StatelessWidget {
  final User user;

  const HealthIndex({super.key, required this.user});

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
        title: const Text('Health index'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          children: [
            // Hiển thị tên người dùng và avatar
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
                                  'BMI & BSA',
                                  style: AppTheme.theme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0), // Minimum padding
                              child: Align(
                                alignment: Alignment.center, // Center the image
                                child: Image.asset(
                                  'lib/assets/Lifesavers Heart.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          //_navigateToScreen(context, EditProfileScreen(user: user)); // Navigate to the profile information screen
                        },
                      ),
                    ),
                  ),
                  // Mục Đặt co so y te
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(AppTheme.Padding8),
                                child: Text(
                                  'Blood pressure',
                                  style: AppTheme.theme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0), // Minimum padding
                              child: Align(
                                alignment: Alignment.center, // Center the image
                                child: Image.asset(
                                  'lib/assets/Lifesavers Heart.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                         // _navigateToScreen(context, EditProfileScreen(user: user)); // Navigate to the profile information screen
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(AppTheme.Padding8),
                                child: Text(
                                  'Temperature',
                                  style: AppTheme.theme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0), // Minimum padding
                              child: Align(
                                alignment: Alignment.center, // Center the image
                                child: Image.asset(
                                  'lib/assets/Lifesavers Electrocardiogram.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          //_navigateToScreen(context, EditProfileScreen(user: user)); // Navigate to the profile information screen
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
