import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/providers/user_provider.dart';
import 'package:healthcare_management_app/screens/comons/show_vertical_menu.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healthcare_management_app/dto/register.dart';
import 'package:healthcare_management_app/enum.dart';
import 'package:healthcare_management_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html; // Chỉ sử dụng trên Web
import 'package:flutter/foundation.dart'; // Để sử dụng kIsWeb

import '../../dto/user_dto.dart';
import '../customers/Home_customer.dart';
import 'customBottomNavBar.dart';
import 'login.dart';

class EditProfileScreen extends StatefulWidget {
  final UserDTO? userDTO;

  const EditProfileScreen({super.key, required this.userDTO});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _avatarBytes;
  Gender? _selectedGender = Gender.MALE;

  String? _fullNameError;
  String? _phoneError;
  String? _emailError;
  // String? _passwordError;
  // String? _rePasswordError;
  String? _addressError;
  String? _signError;
  String? _descriptionError;

  bool _obscurePassword = true;
  bool _obscureRePassword = true;
  bool _isUploadingImage = false;
  html.File? _pickedFile;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    // _passwordController.dispose();
    // _rePasswordController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.userDTO != null) {
      _fullNameController.text = widget.userDTO!.fullName ?? '';
      _phoneController.text = widget.userDTO!.phone ?? '';
      _emailController.text = widget.userDTO!.email ?? '';
      _addressController.text = widget.userDTO!.address ?? '';
      _selectedGender =
          widget.userDTO!.gender == 'MALE' ? Gender.MALE : Gender.FEMALE;
      _descriptionController.text = widget.userDTO!.description ?? '';

      // Nếu avatar có sẵn, tải và hiển thị nó
      if (widget.userDTO!.avatar != null) {
        setState(() {
          _avatarBytes = widget.userDTO!.avatar!;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      if (kIsWeb) {
        html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
          ..accept = 'image/*'
          ..multiple = false;

        uploadInput.click();

        uploadInput.onChange.listen((e) async {
          final files = uploadInput.files;
          if (files!.isEmpty) return;

          final reader = html.FileReader();
          reader.readAsDataUrl(files[0]);
          reader.onLoadEnd.listen((event) {
            setState(() {
              _avatarBytes = reader.result
                  as String; // Dùng base64 để hiển thị ngay lập tức
            });
            _uploadImage(files[0]);
          });
        });
      } else {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          Uint8List fileBytes = await pickedFile.readAsBytes();
          setState(() {
            //_avatarCurrent = fileBytes; // Hiển thị ngay lập tức ảnh đã chọn
          });
          _uploadImage(fileBytes);
        }
      }
    } catch (e) {
      setState(() {
        _signError = 'There was an error selecting an image';
      });
      print("Error picking image: $e");
    }
  }

  Future<void> _uploadImage(dynamic imageFile) async {
    setState(() {
      _isUploadingImage = true;
    });

    try {
      // Gửi `imageFile` lên server
      String? avatarUrl =
          await Provider.of<UserProvider>(context, listen: false)
              .uploadImage(imageFile);
      if (avatarUrl != null) {
        setState(() {
          _avatarBytes = avatarUrl; // Cập nhật URL ảnh từ server
        });
      }
    } catch (e) {
      setState(() {
        _signError = 'There was an error selecting an image';
      });
      print("Error uploading image: $e");
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  void _signUp() async {
    setState(() {
      _fullNameError = null;
      _phoneError = null;
      _emailError = null;
      // _passwordError = null;
      // _rePasswordError = null;
      _addressError = null;
      _signError = null;
      _descriptionError = null;
    });

    String fullName = _fullNameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    // String password = _passwordController.text;
    // String rePassword = _rePasswordController.text;
    String address = _addressController.text;
    String description = _descriptionController.text;
    bool hasError = false;

    if (fullName.length < 5 || fullName.length > 50) {
      setState(() {
        _fullNameError = 'Full Name must be from 5 to 50 characters';
      });
      hasError = true;
    }

    if (phone.length < 9 ||
        phone.length > 12 ||
        !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      setState(() {
        _phoneError = 'Phone must be numeric and between 9 and 12 characters';
      });
      hasError = true;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        _emailError = 'Email is not in correct format';
      });
      hasError = true;
    }

    // if (password != rePassword) {
    //   setState(() {
    //     _passwordError = 'Password and Re-password must match';
    //   });
    //   hasError = true;
    // }

    if (address.length < 5 || address.length > 300) {
      setState(() {
        _addressError = 'Address must be from 5 to 300 characters';
      });
      hasError = true;
    }
    if (description.length < 5 || address.length > 300) {
      setState(() {
        _addressError = 'description must be from 5 to 300 characters';
      });
      hasError = true;
    }

    //if (hasError) return;

    String gender = _selectedGender == Gender.MALE ? 'MALE' : 'FEMALE';
    String avarta = "";

    if (_pickedFile != null) {
      String? avatarUrl =
          await Provider.of<UserProvider>(context, listen: false)
              .uploadImage(_pickedFile);
      avarta = avatarUrl ?? "";
    }

    UserDTO updatedUser = UserDTO(
      id: widget.userDTO?.id,
      address: address,
      description: description,
      email: email,
      gender: gender,
      fullName: fullName,
      phone: phone,
      username: widget.userDTO!.username,
      avatar: avarta,
    );

    try {
      await Provider.of<UserProvider>(context, listen: false)
          .updateUser(updatedUser);
      _showUpdateSuccessDialog();
    } catch (e) {
      setState(() =>
          _signError = 'The name already exists, please choose another name');
      print("Error updating user: $e");
    }
  }

  void _showUpdateSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Updated successfully'),
        content: Text(
            'Your information has been successfully updated. Please log in again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng hộp thoại
              Navigator.push(
                  context, MaterialPageRoute(builder: (content) => Login()));
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Information'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text("Wellcome",
                    style: Theme.of(context).textTheme.displayLarge),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    backgroundImage: _avatarBytes != null
                        ? (_avatarBytes!.startsWith('data:image')
                            ? MemoryImage(
                                base64Decode(_avatarBytes!.split(',').last))
                            : NetworkImage(_avatarBytes!)) as ImageProvider
                        : AssetImage('lib/assets/Avatar.png'),
                    radius: 36,
                  ),
                ),

                if (_isUploadingImage) CircularProgressIndicator(),
                Text('Tap to select an image'),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  errorText: _fullNameError,
                ),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  errorText: _phoneError,
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  errorText: _emailError,
                  keyboardType: TextInputType.emailAddress,
                ),
                // _buildTextField(
                //   controller: _passwordController,
                //   label: 'Password',
                //   errorText: _passwordError,
                //   obscureText: _obscurePassword,
                //   onToggleObscureText: () {
                //     setState(() {
                //       _obscurePassword = !_obscurePassword;
                //     });
                //   },
                // ),
                // _buildTextField(
                //   controller: _rePasswordController,
                //   label: 'Re-password',
                //   errorText: _rePasswordError,
                //   obscureText: _obscureRePassword,
                //   onToggleObscureText: () {
                //     setState(() {
                //       _obscureRePassword = !_obscureRePassword;
                //     });
                //   },
                // ),
                _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  errorText: _addressError,
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
                SizedBox(height: 5),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5, // Cho phép nhập không giới hạn dòng
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your description here...',
                  ),
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),

                SizedBox(height: AppTheme.smallSpacing),

                if (_signError != null)
                  Text(_signError!, style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, // Chiếm toàn bộ chiều rộng
                  child: ElevatedButton(
                    style: AppTheme
                        .elevatedButtonStyle, // Sử dụng style từ AppTheme
                    onPressed: _signUp,
                    child: Text('Update'),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 0,
          onTap: (index) {
            // Handle other navigation
          },
          onSetupPressed: () {
            MenuUtils.showVerticalMenu(context); // Hiển thị menu khi nhấn Setup
          },
          onHomePressed: () {
            // Điều hướng về trang HomeCustomer
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeCustomer()),
            );
          },
        ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    VoidCallback? onToggleObscureText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            errorText: errorText,
            suffixIcon: onToggleObscureText != null
                ? IconButton(
                    icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: onToggleObscureText,
                  )
                : null,
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
