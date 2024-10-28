import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/login_dto.dart';
import 'package:healthcare_management_app/providers/auth_provider.dart';
import 'package:healthcare_management_app/screens/admins/Medical_Examination_Screen.dart';
import 'package:healthcare_management_app/screens/comons/sign_up.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';
import 'package:http/http.dart' as http;
import 'package:healthcare_management_app/screens/customers/home_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../apis/auth.dart';
import '../../models/user.dart';
import '../admins/admin_home.dart';
import '../doctor/doctor_home.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'TokenManager.dart'; // Thêm import này để sử dụng UserProvider


class Login extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
late final Auth authApi;

class _LoginScreenState extends State<Login> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _userNameError;
  String? _passwordError;

  // Biến để điều khiển ẩn/hiện mật khẩu
  bool _obscurePassword = true;
  late SharedPreferences pres;

  User user = User(
    id: 3,
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
  );

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSheredPref();
  }
  void initSheredPref() async {
    pres = await SharedPreferences.getInstance();
  }


  void _login() async {
    setState(() {
      _userNameError = null;
      _passwordError = null;
    });

    String username = _userNameController.text;
    String password = _passwordController.text;

    if (username.isEmpty) {
      setState(() {
        _userNameError = "Username không được để trống";
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        _passwordError = "Mật khẩu không được để trống";
      });
      return;
    }

    var regBody = {
      "username": username,
      "password": password
    };

    try {
      var response = await http.post(Uri.parse(loginUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      // In ra nội dung phản hồi từ server để kiểm tra
      print('Response status: ${response.statusCode}');
      

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        // Kiểm tra nếu token tồn tại
        if (jsonResponse['token'] != null) {
          var myToken = jsonResponse['token'];
          pres.setString('token', myToken);
          TokenManager().setToken(myToken);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeCustomer(user: user,token:myToken)),
          );
        } else {
          setState(() {
            _userNameError = "Phản hồi không hợp lệ từ server";
          });
        }
      } else {
        setState(() {
          _userNameError = "Lỗi server: ${response.statusCode}";
        });
      }
    } catch (error) {
      setState(() {
        _userNameError = "Đã xảy ra lỗi: $error";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: AppTheme.xLargeSpacing),
              Text(
                "Welcome",
                style: AppTheme.theme.textTheme.headlineLarge,
              ),
              Text(
                "Login",
                style: AppTheme.theme.textTheme.headlineLarge,
              ),
              SizedBox(height: AppTheme.xLargeSpacing),
              // Hình ảnh trung tâm
              Container(
                child: Image.asset('lib/assets/Lifesavers.png'),
              ),
              SizedBox(height: AppTheme.xLargeSpacing),
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  errorText: _userNameError,
                ),
              ),
              SizedBox(height: AppTheme.smallSpacing),
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
              SizedBox(height: AppTheme.mediumSpacing),
              SizedBox(
                width: double.infinity, // Chiếm toàn bộ chiều rộng
                child: ElevatedButton(
                  style: AppTheme.elevatedButtonStyle, // Sử dụng style từ AppTheme
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ),
              SizedBox(height: AppTheme.largeSpacing),
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
