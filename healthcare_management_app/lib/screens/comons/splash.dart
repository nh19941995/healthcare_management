// Splash.dart
import 'package:flutter/material.dart';

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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 75, vertical: 15), backgroundColor: Colors.deepPurple, // Màu nền nút
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Hành động khi nhấn Sign Up
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18,color: Colors.white),

                ),
              ),
              SizedBox(height: 20),
              // Nút "Login"
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.deepPurple, padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  side: BorderSide(color: Colors.deepPurple, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Hành động khi nhấn Login
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
