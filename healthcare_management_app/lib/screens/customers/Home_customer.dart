import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/user_dto.dart';
import 'package:healthcare_management_app/models/user.dart';
import 'package:healthcare_management_app/providers/user_provider.dart';
import 'package:healthcare_management_app/screens/comons/Update_profile.dart';
import 'package:healthcare_management_app/screens/comons/login.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';
import 'package:healthcare_management_app/screens/customers/Schedule_management.dart';
import 'package:healthcare_management_app/screens/customers/Make_an_appointment.dart';
//import 'package:healthcare_management_app/screens/customers/health_index.dart';
import 'package:healthcare_management_app/screens/customers/Qa.dart';
import 'package:provider/provider.dart';
import '../comons/TokenManager.dart';
import '../comons/customBottomNavBar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../comons/show_vertical_menu.dart';

class HomeCustomer extends StatefulWidget {


  const HomeCustomer({super.key});

  @override
  _HomeCustomerState createState() => _HomeCustomerState();
}

class _HomeCustomerState extends State<HomeCustomer> {
  late UserProvider userProvider;
  UserDTO? userDto;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);

    // Bắt đầu fetch user và cập nhật trạng thái
    userProvider.fetchUser().then((_) {
      setState(() {
        userDto = userProvider.user; // Cập nhật user sau khi fetch
      });
    });

  }

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
        title: const Text("Home"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại danh sách lịch sử khám bệnh
          },
        ),
      ),
      body: SingleChildScrollView(
        // Thêm SingleChildScrollView để cuộn
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.defaultPadding),
          child: Column(
            children: [
              // Hiển thị tên người dùng và avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Welcome ${userDto?.fullName}',
                      style: AppTheme.theme.textTheme.displayLarge,
                      overflow: TextOverflow.ellipsis, // Hiển thị dấu "..." nếu văn bản quá dài
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: userDto?.avatar != null
                        ? NetworkImage(userDto!.avatar!)
                        : const AssetImage('lib/assets/Avatar.png')
                    as ImageProvider,
                    radius: 24, // Kích thước của avatar
                  ),
                ],
              ),
              SizedBox(height: AppTheme.largeSpacing),
              Column(
                children: [
                  // Các mục như Thông tin cá nhân, Đặt lịch khám, Lịch sử khám, Tư vấn online
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
                                  'Information',
                                  style: AppTheme.theme.textTheme.displayMedium,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'lib/assets/office-man.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToScreen(
                              context, EditProfileScreen(userDTO: userDto));
                        },
                      ),
                    ),
                  ),
                  // Các Card khác
                  SizedBox(
                    height: 160.0,
                    child: Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(AppTheme.Padding8),
                                child: Text(
                                  'Make an appointment',
                                  style: AppTheme.theme.textTheme.displayMedium,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'lib/assets/Bag.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToScreen(context, Booking());
                        },
                      ),
                    ),
                  ),
                  // Mục Lịch sử khám
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
                                  'Schedule Management',
                                  style: AppTheme.theme.textTheme.displayMedium,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0), // Padding tối thiểu
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'lib/assets/Lifesavers Stethoscope.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToScreen(context, AppointmentHistoryApp()); // Chuyển đến màn hình lịch sử khám
                        },
                      ),
                    ),
                  ),

                  // Mục Tư vấn online
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
                                  'Q&A',
                                  style: AppTheme.theme.textTheme.displayMedium,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0), // Padding tối thiểu
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'lib/assets/Lifesavers Bust.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToScreen(context, OnlineConsultation()); // Chuyển đến màn hình tư vấn online
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle other navigation
        },
        onSetupPressed: () {
          MenuUtils.showVerticalMenu(context); // Hiển thị menu khi nhấn Setup
        },
        onHomePressed: () {},
      ),
    );
  }

}
