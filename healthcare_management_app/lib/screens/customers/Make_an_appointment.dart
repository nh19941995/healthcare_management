import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/models/user.dart';
import 'package:healthcare_management_app/screens/comons/Edit_profile.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';
import '../comons/customBottomNavBar.dart';
import 'List_Clinic__Screen.dart';
import 'Doctor_selection_screen.dart';

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
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          children: [
            // Hiển thị tên người dùng và avatar (có thể thêm ở đây)
            SizedBox(height: AppTheme.largeSpacing),
            Expanded(
              child: Column(
                children: [
                  // Mục Thông tin cá nhân
                  SizedBox(
                    height: 160.0, // Đặt chiều cao gấp đôi cho Card
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
                              padding: const EdgeInsets.all(4.0), // Padding tối thiểu
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'lib/assets/doctor.png',
                                  width: 100, // Chỉnh kích thước width theo nhu cầu
                                  height: 100, // Chỉnh kích thước height theo nhu cầu
                                  fit: BoxFit.cover, // Hoặc BoxFit.contain tùy vào cách bạn muốn hiển thị
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToScreen(context, DoctorSelectionScreen());
                        },
                      ),
                    ),
                  ),
                  // Mục Đặt cơ sở y tế
                  SizedBox(
                    height: 160.0, // Đặt chiều cao gấp đôi cho Card
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
                              padding: const EdgeInsets.all(4.0), // Padding tối thiểu
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'lib/assets/hospital-facility.png',
                                  width: 100, // Chỉnh kích thước width theo nhu cầu
                                  height: 100, // Chỉnh kích thước height theo nhu cầu
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToScreen(context, ListClinic());
                        },
                      ),
                    ),
                  ),
                  // Uncomment the following section to add Medical Services option
                  // Mục Dịch vụ y tế
                  /*
                  SizedBox(
                    height: 160.0, // Đặt chiều cao gấp đôi cho Card
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
                              padding: const EdgeInsets.all(4.0), // Padding tối thiểu
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'lib/assets/Lifesavers Electrocardiogram.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // _navigateToScreen(context, EditProfileScreen());
                        },
                      ),
                    ),
                  ),
                  */
                ],
              ),
            ),
          ],
        ),
      ),
      // Uncomment the following section to add bottom navigation bar
      // bottomNavigationBar: CustomBottomNavBar(
      //   currentIndex: 0,
      //   onTap: (index) {
      //     // Handle bottom navigation
      //   },
      // ),
    );
  }
}
