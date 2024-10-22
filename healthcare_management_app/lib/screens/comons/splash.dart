import 'package:flutter/material.dart';
import 'package:healthcare_management_app/screens/comons/login.dart';
import 'package:healthcare_management_app/screens/comons/sign_up.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Màu nền
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tiêu đề "Welcome to Self Care"
              Text(
                "Welcome to",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              Text(
                "Self Care",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 40),
              // Hình ảnh trung tâm (có thể thay thế bằng Asset Image)
              Container(
                height: 200,
                child: Image.asset('lib/assets/Lifesavers.png'),
              ),
              SizedBox(height: 40),
              // Nút "Sign Up"
              SizedBox(
                width: double.infinity, // Chiếm toàn bộ chiều rộng
                child: ElevatedButton(
                  style: AppTheme.elevatedButtonStyle, // Sử dụng style từ AppTheme
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text('Sign Up'),
                ),
              ),
              SizedBox(height: 20),
              // Nút "Login"
              SizedBox(
                width: double.infinity, // Chiếm toàn bộ chiều rộng
                child: OutlinedButton(
                  style: AppTheme.outlinedButtonStyle, // Sử dụng style từ AppTheme
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
