import 'package:flutter/material.dart';
//import 'package:healthcare_management_app/screens/comons/Notification_Screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onSetupPressed;
  final VoidCallback onHomePressed;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.onSetupPressed,
    required this.onHomePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        // Tạm thời comment phần Notify
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.notifications),
        //   label: 'Notify',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Setup',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      onTap: (index) {
        if (index == 0) {
          onHomePressed(); // Gọi callback khi nhấn vào Home
        } else if (index == 1) {
          // Tạm thời không thực hiện hành động nào khi bấm vào Notify
          // Đoạn này đã được comment
          onSetupPressed();
        } else {
        // Gọi callback khi nhấn vào Setup
        }
      },
    );
  }
}
