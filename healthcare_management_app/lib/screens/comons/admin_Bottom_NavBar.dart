import 'package:flutter/material.dart';
import 'package:healthcare_management_app/screens/comons/Notification_Screen.dart';
import 'User_List_Screen.dart';

class AdminBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onSetupPressed;
  final VoidCallback onHomePressed;

  const AdminBottomNavbar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.onSetupPressed,
    required this.onHomePressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Đảm bảo label luôn hiển thị
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.notifications),
            //   label: 'Notify',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setup',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts), // Thay icon User Permissions
              label: 'User Management',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey, // Màu icon không chọn
          onTap: (index) {
            if (index == 1) {
              onSetupPressed(); // Gọi callback khi nhấn vào Setup
            } else if (index == 0) {
              // // Điều hướng đến trang NotificationPage khi nhấn vào Notify
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => NotificationPage()),
              // );
              onHomePressed();
             }else if(index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserListScreen()),
              );
            }
            else {
              onTap(index);
            }
          },
        ),
      ],
    );
  }
}

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = [
//     Center(child: Text('Home Screen')),
//     Center(child: Text('Notification Screen')),
//     Center(child: Text('Setup Screen')),
//     UserListScreen(), // Thay thế bằng widget danh sách người dùng thực tế
//   ];
//
//   void _onItemTapped(int index) {
//     if (index == 3) {
//       // Hành động khi bấm vào icon "User Permissions"
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => UserListScreen()), // Điều hướng đến danh sách người dùng
//       );
//     } else {
//       setState(() {
//         _currentIndex = index;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentIndex < 3 ? _screens[_currentIndex] : Container(), // Không hiển thị màn hình nếu đang điều hướng
//       bottomNavigationBar: AdminBottomNavbar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
