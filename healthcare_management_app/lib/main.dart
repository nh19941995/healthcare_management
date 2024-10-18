import 'package:flutter/material.dart';
import 'package:healthcare_management_app/services/user_service.dart';

import 'models/user.dart'; // Thay thế bằng đường dẫn đúng

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Data Fetch',
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Data Fetch'),
        ),
        body: Center(
          child: FutureBuilder<User?>(
            future: UserService.fetchUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Text('User Name: ${snapshot.data!.name}');
              } else {
                return Text('No user data found.');
              }
            },
          ),
        ),
      ),
    );
  }
}