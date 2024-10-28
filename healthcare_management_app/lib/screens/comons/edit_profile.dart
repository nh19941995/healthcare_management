import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_management_app/models/user.dart';
import 'package:healthcare_management_app/providers/user_provider.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';

import '../../enum.dart';
import 'customBottomNavBar.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _addressController = TextEditingController();

  String? _fullNameError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  String? _rePasswordError;
  String? _addressError;
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();
    // Initialize the text fields with the current user data
    _fullNameController.text = widget.user.name ?? '';
    _phoneController.text = widget.user.phone ?? '';
    _emailController.text = widget.user.email ?? '';
    _passwordController.text = widget.user.password ?? '';
    _addressController.text = widget.user.address ?? '';
    _selectedGender = widget.user.gender == 'MALE' ? Gender.MALE : Gender.FEMALE;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _update() async {
    // Clear previous errors
    setState(() {
      _fullNameError = null;
      _phoneError = null;
      _emailError = null;
      _passwordError = null;
      _addressError = null;
    });

    // Get data from controllers
    String fullName = _fullNameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String address = _addressController.text;

    // Validate fields
    bool hasError = false;

    if (fullName.length < 5 || fullName.length > 50) {
      setState(() {
        _fullNameError = 'Full Name must be between 5 and 50 characters';
      });
      hasError = true;
    }

    if (phone.length < 1 || phone.length > 12 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      setState(() {
        _phoneError = 'Phone number must be numeric and between 9 to 12 characters';
      });
      hasError = true;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        _emailError = 'Email format is invalid';
      });
      hasError = true;
    }


    if (address.length < 1 || address.length > 300) {
      setState(() {
        _addressError = 'Address must be between 10 and 300 characters';
      });
      hasError = true;
    }

    // Stop if there are errors
    if (hasError) return;

    // If no errors, update user
    String gender = _selectedGender == Gender.MALE ? 'MALE' : 'FEMALE';

    User updatedUser = User(
      id: widget.user.id,
      address: address,
      avatar: widget.user.avatar,
      createdAt: widget.user.createdAt,
      deletedAt: widget.user.deletedAt,
      description: widget.user.description,
      email: email,
      gender: gender,
      lockReason: widget.user.lockReason,
      name: fullName,
      password: password,
      phone: phone,
      status: widget.user.status,
      updatedAt: DateTime.now(),
      roleId: widget.user.roleId,
    );

    try {
      print(updatedUser.toString());
      await Provider.of<UserProvider>(context, listen: false).updateUser(updatedUser);
      _showUpdateSuccessDialog();
    } catch (e) {
      // Handle API error
      print("Error updating user: $e");
    }
  }

  void _showUpdateSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('User profile updated successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Close EditProfileScreen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.largeSpacing),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Avatar and Change Picture Button
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('lib/assets/Avatar.png'), // Use user's avatar
                    ),
                    const SizedBox(height: AppTheme.mediumSpacing),
                    TextButton(
                      onPressed: () {
                        // Action for changing picture
                      },
                      child: Text(
                        'Change Picture',
                        style: AppTheme.theme.textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.largeSpacing),

              // Form for editing user information
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  errorText: _fullNameError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.smallSpacing),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _emailError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.smallSpacing),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  errorText: _phoneError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.smallSpacing),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _passwordError,
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: AppTheme.smallSpacing),

              // Gender Selection
              Row(
                children: [
                  const Text("Gender"),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ListTile(
                      title: const Text("Male"),
                      leading: Radio<Gender>(
                        value: Gender.MALE,
                        groupValue: _selectedGender,
                        onChanged: (Gender? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text("Female"),
                      leading: Radio<Gender>(
                        value: Gender.FEMALE,
                        groupValue: _selectedGender,
                        onChanged: (Gender? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.smallSpacing),

              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  errorText: _addressError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.largeSpacing),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: AppTheme.elevatedButtonStyle,
                  onPressed: _update,
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation
        },
      ),
    );
  }
}
