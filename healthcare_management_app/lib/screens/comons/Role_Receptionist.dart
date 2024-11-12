import 'package:flutter/material.dart';
import 'package:healthcare_management_app/screens/customers/Home_customer.dart';


class RoleReceptionistScreen extends StatelessWidget {
  RoleReceptionistScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn vai trò"),
      ),
      body: Column(
        children: [
          // Không hiển thị vai trò Admin và Bác sĩ
          RoleCard(roleName: "Khách hàng", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeCustomer()));
          }),
          RoleCard(roleName: "Nhân viên lễ tân", onTap: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context) => ReceptionistHome()));
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
