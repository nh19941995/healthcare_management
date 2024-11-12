import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/register.dart';
import 'package:healthcare_management_app/enum.dart';
import 'package:healthcare_management_app/models/user.dart';
import 'package:healthcare_management_app/providers/auth_provider.dart';
import 'package:healthcare_management_app/providers/user_provider.dart';
import 'package:healthcare_management_app/screens/comons/login.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUp> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Gender? _selectedGender = Gender.MALE; // Gán giá trị mặc định là MALE
  String? _fullNameError;
  String? _userNameError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  String? _rePasswordError;
  String? _addressError;

  bool _obscurePassword = true;
  bool _obscureRePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _signUp() async {
    setState(() {
      _fullNameError = null;
      _userNameError = null;
      _phoneError = null;
      _emailError = null;
      _passwordError = null;
      _rePasswordError = null;
      _addressError = null;
    });

    String fullName = _fullNameController.text;
    String username = _userNameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String rePassword = _rePasswordController.text;
    String address = _addressController.text;

    bool hasError = false;

    if (fullName.length < 5 || fullName.length > 50) {
      setState(() {
        _fullNameError = 'Full Name phải từ 5 đến 50 ký tự';
      });
      hasError = true;
    }

    if (username.length < 5 || !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
      setState(() {
        _userNameError = 'Username phải từ 5 ký tự trở lên và không dấu';
      });
      hasError = true;
    }

    if (phone.length < 9 || phone.length > 12 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      setState(() {
        _phoneError = 'Phone phải là số và từ 9 đến 12 ký tự';
      });
      hasError = true;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        _emailError = 'Email không đúng định dạng';
      });
      hasError = true;
    }

    if (password != rePassword) {
      setState(() {
        _passwordError = 'Password và Re-password phải trùng khớp';
      });
      hasError = true;
    }

    if (address.length < 10 || address.length > 300) {
      setState(() {
        _addressError = 'Address phải từ 10 đến 300 ký tự';
      });
      hasError = true;
    }

    if (hasError) return;

    String gender = _selectedGender == Gender.MALE ? 'MALE' : 'FEMALE';

    Register register = Register(
        username: username,
        password: password,
        gender: gender,
        email: email,
        phone: phone,
        address: address,
        fullName: fullName,
        description: "Người dùng thử nghiệm",
        //avatar: 'lib/assets/Avatar.png'
    );

    try {
      await Provider.of<AuthProvider>(context, listen: false).register(register);
      _showSignUpSuccessDialog();
    } catch (e) {
      print("Error inserting user: $e");
    }
  }
  // Hàm hiển thị Dialog đăng ký thành công
  void _showSignUpSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đăng ký thành công!'),
          content: Text('Bạn có muốn đăng nhập ngay bây giờ không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng Dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng Dialog
                // Điều hướng tới màn hình login
                _navigateToLogin();
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }
// Hàm điều hướng tới màn hình Login
  void _navigateToLogin() {
    // Thực hiện điều hướng sang màn hình đăng nhập, tùy thuộc vào logic của bạn
    // Ví dụ:
    // Navigator.pushNamed(context, '/login');
    Navigator.push(context,
        MaterialPageRoute(builder:
            (content) => Login()));

  }


  // UI code below
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: AppTheme.xLargeSpacing),
              Text("Sign Up", style: AppTheme.headerStyle),
              SizedBox(height: AppTheme.xLargeSpacing),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                  errorText: _fullNameError,
                ),
              ),
              SizedBox(height: AppTheme.smallSpacing),
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
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                  errorText: _phoneError,
                ),
              ),
              SizedBox(height: AppTheme.smallSpacing),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  errorText: _emailError,
                ),
              ),
              SizedBox(height: AppTheme.smallSpacing),
              // Trường nhập Password với nút bật/tắt hiển thị mật khẩu
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
              SizedBox(height: AppTheme.smallSpacing),
              // Trường nhập Re-password với nút bật/tắt hiển thị mật khẩu
              TextField(
                controller: _rePasswordController,
                obscureText: _obscureRePassword,
                decoration: InputDecoration(
                  labelText: "Re password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureRePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureRePassword = !_obscureRePassword;
                      });
                    },
                  ),
                  errorText: _rePasswordError,
                ),
              ),
              SizedBox(height: AppTheme.smallSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Gender", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      Radio<Gender>(
                        value: Gender.MALE, // Sử dụng enum MALE
                        groupValue: _selectedGender,
                        onChanged: (Gender? value) {
                          setState(() {
                            _selectedGender = value; // Cập nhật giá trị
                          });
                        },
                      ),
                      Text("Male"),
                    ],
                  ),
                  SizedBox(width: AppTheme.largeSpacing),
                  Row(
                    children: [
                      Radio<Gender>(
                        value: Gender.FEMALE, // Sử dụng enum FEMALE
                        groupValue: _selectedGender,
                        onChanged: (Gender? value) {
                          setState(() {
                            _selectedGender = value; // Cập nhật giá trị
                          });
                        },
                      ),
                      Text("Female"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppTheme.smallSpacing),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                  errorText: _addressError,
                ),
              ),
              SizedBox(height: AppTheme.largeSpacing),
              SizedBox(
                width: double.infinity, // Chiếm toàn bộ chiều rộng
                child: ElevatedButton(
                  style: AppTheme.elevatedButtonStyle, // Sử dụng style từ AppTheme
                  onPressed: _signUp,
                  child: Text('Sign Up'),
                ),
              ),
              SizedBox(height: AppTheme.largeSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      // Điều hướng tới trang Login
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (cotent)=> Login())
                      );
                    },
                    child: Text(
                      "Login",
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
