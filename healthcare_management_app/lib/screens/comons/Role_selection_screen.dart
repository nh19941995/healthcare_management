import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  final List<Map<String, dynamic>> rolesToShow;

  RoleSelectionScreen({required this.rolesToShow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn vai trò"),
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
