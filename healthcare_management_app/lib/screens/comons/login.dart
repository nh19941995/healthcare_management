import 'package:flutter/material.dart';
import 'package:healthcare_management_app/screens/comons/login.dart';
import 'package:healthcare_management_app/screens/comons/sign_up.dart';
import 'package:healthcare_management_app/screens/customers/home_customer.dart';


import '../../models/user.dart';
import '../admins/admin_home.dart';
import '../doctor/doctor_home.dart'; // Đảm bảo bạn đã tạo HomeCustomer

class Login extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  // Biến để điều khiển ẩn/hiện mật khẩu
  bool _obscurePassword = true;

  // Thông tin người dùng giả
  // Dữ liệu giả cho người dùng
  final List<User> fakeUsers = [
    User(
      id: '1',
      name: 'John Doe',
      email: '1',
      password: '1',
      address: '123 Main St',
      phone: '123-456-7890',
      avatar: 'path/to/avatar1.png',
      status: 'ACTIVE',
      createdAt: DateTime.now(),
      deletedAt: null,
      description: 'Regular user',
      gender: 'Male',
      lockReason: null,
      updatedAt: DateTime.now(),
      roleId: 1, // Vai trò 1 vào HomeCustomer
    ),
    User(
      id: '2',
      name: 'Jane Smith',
      email: 'janesmith@example.com',
      password: 'password123',
      address: '456 Elm St',
      phone: '234-567-8901',
      avatar: 'path/to/avatar2.png',
      status: 'ACTIVE',
      createdAt: DateTime.now(),
      deletedAt: null,
      description: 'Admin user',
      gender: 'Female',
      lockReason: null,
      updatedAt: DateTime.now(),
      roleId: 2, // Vai trò 2 vào Admin Home
    ),
    User(
      id: '3',
      name: 'Mike Johnson',
      email: 'mikejohnson@example.com',
      password: 'password123',
      address: '789 Oak St',
      phone: '345-678-9012',
      avatar: 'path/to/avatar3.png',
      status: 'ACTIVE',
      createdAt: DateTime.now(),
      deletedAt: null,
      description: 'Manager user',
      gender: 'Male',
      lockReason: null,
      updatedAt: DateTime.now(),
      roleId: 3, // Vai trò 3 vào Manager Home
    ),
  ];


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    setState(() {
      _emailError = null;
      _passwordError = null;

      String email = _emailController.text;
      String password = _passwordController.text;

      // Kiểm tra thông tin đăng nhập
      if (email.isEmpty) {
        _emailError = "Email không được để trống";
      }
      if (password.isEmpty) {
        _passwordError = "Mật khẩu không được để trống";
      }

      // Tìm kiếm người dùng trong danh sách giả
      User? user;

      for (var u in fakeUsers) {
        if (u.email == email && u.password == password) {
          user = u; // Lưu người dùng tìm thấy
          break; // Thoát khỏi vòng lặp
        }
      }

      if (user != null) {
        // Điều hướng theo vai trò
        if (user.roleId == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeCustomer(user: user!)),
          );
        } else if (user.roleId == 2) {
          // Điều hướng đến màn hình cho vai trò 2
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHome()),
          );
        } else if (user.roleId == 3) {
          // Điều hướng đến màn hình cho vai trò 3
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DoctorHome()),
          );
        }
      } else {
        _emailError = "Thông tin đăng nhập không đúng";
        _passwordError = "Thông tin đăng nhập không đúng";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Text(
                "Welcome",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 40),
              // Hình ảnh trung tâm
              Container(
                height: 200,
                child: Image.asset('lib/assets/Lifesavers.png'),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  errorText: _emailError,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  errorText: _passwordError,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _login,
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don’t have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
