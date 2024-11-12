import 'package:flutter/material.dart';
import 'package:healthcare_management_app/screens/comons/Notification_Screen.dart';


class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onSetupPressed;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.onSetupPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notify',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Setup',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      onTap: (index) {
        if (index == 2) {
          onSetupPressed(); // Gọi callback khi nhấn vào Setup
        } else if (index == 1) {
          // Điều hướng đến trang NotificationPage khi nhấn vào Notify
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationPage()),
          );
        } else {
          onTap(index);
        }
      },
    );
  }
}
