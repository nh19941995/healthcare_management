import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/models/user.dart';
import 'package:healthcare_management_app/screens/comons/edit_profile.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';
import '../comons/customBottomNavBar.dart';
import 'List_Clinic__Screen.dart';
import 'list_doctor.dart';

class Booking extends StatelessWidget {

  const Booking({super.key});

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
        title: const Text('Make an appointment'),
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
                                  'Doctor',
                                  style: AppTheme.theme.textTheme.displayMedium,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0), // Minimum padding
                              child: Align(
                                alignment: Alignment.center, // Center the image
                                child: Image.asset(
                                  'lib/assets/Stomach.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToScreen(context, DoctorSelectionScreen()); // Navigate to the profile information screen
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
                                  'Medical facility',
                                  style: AppTheme.theme.textTheme.displayMedium,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0), // Minimum padding
                              child: Align(
                                alignment: Alignment.center, // Center the image
                                child: Image.asset(
                                  'lib/assets/Bag.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToScreen(context, ListClinic()); // Navigate to the profile information screen
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
                                  'Medical Services',
                                  style: AppTheme.theme.textTheme.displayMedium,
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
                         // _navigateToScreen(context, EditProfileScreen()); // Navigate to the profile information screen
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
