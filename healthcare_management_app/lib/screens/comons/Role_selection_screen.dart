import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthcare_management_app/screens/admins/Booking_Table_Screen.dart';

import '../customers/Home_customer.dart';

class RoleSelectionScreen extends StatelessWidget {
  final bool showAdmin;

  RoleSelectionScreen({required this.showAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn vai trò"),
      ),
      body: Column(
        children: [
          if (showAdmin)
            RoleCard(roleName: "Admin", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BookingTableScreen()));
            }),
          RoleCard(roleName: "Bác sĩ", onTap: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorHomeScreen()));
          }),
          RoleCard(roleName: "Khách hàng", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeCustomer()));
          }),
        ],
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
