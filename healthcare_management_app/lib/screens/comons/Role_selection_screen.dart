import 'package:flutter/material.dart';
import 'package:healthcare_management_app/screens/comons/customBottomNavBar.dart';
import 'package:healthcare_management_app/screens/comons/login.dart';
import 'package:healthcare_management_app/screens/comons/show_vertical_menu.dart';

class RoleSelectionScreen extends StatelessWidget {
  final List<Map<String, dynamic>> rolesToShow;

  RoleSelectionScreen({required this.rolesToShow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select role"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: rolesToShow.map((role) {
          return RoleCard(
            roleName: role['roleName'],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => role['screen']),
              );
            },
          );
        }).toList(),
      ),
      bottomNavigationBar:CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle other navigation
        },
        onSetupPressed: () {
          MenuUtils.showVerticalMenu(context);// Hiển thị menu khi nhấn Setup
        },
        onHomePressed: (){
          // // Điều hướng về trang HomeCustomer
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => Login()),
          // );
        },
      ),
    );
  }
}
class RoleCard extends StatelessWidget {
  final String roleName;
  final VoidCallback onTap;

  RoleCard({required this.roleName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(roleName, style: TextStyle(fontSize: 18)),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}
