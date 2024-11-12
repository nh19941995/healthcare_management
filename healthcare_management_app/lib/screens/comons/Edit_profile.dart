import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/user_dto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_management_app/providers/user_provider.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';
import '../../enum.dart';

class EditProfileScreen extends StatefulWidget {
  final UserDTO? userDTO;

  const EditProfileScreen({super.key, required this.userDTO});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  File? _image;

  // Error variables
  String? _fullNameError;
  String? _phoneError;
  String? _emailError;
  String? _addressError;
  Gender? _selectedGender;
  String? _descriptionError;
  int? id;

  @override
  void initState() {
    super.initState();
    id = widget.userDTO?.id;
    _fullNameController.text = widget.userDTO?.username ?? '';
    _phoneController.text = widget.userDTO?.phone ?? '';
    _emailController.text = widget.userDTO?.email ?? '';
    _addressController.text = widget.userDTO?.address ?? '';
    _selectedGender = widget.userDTO?.gender == 'MALE' ? Gender.MALE : Gender.FEMALE;
    _descriptionController.text = widget.userDTO?.description ?? '';
    _imagePath = widget.userDTO?.avatar;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _update() async {
    setState(() {
      _fullNameError = null;
      _phoneError = null;
      _emailError = null;
      _addressError = null;
    });

    String fullName = _fullNameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    String address = _addressController.text;

    bool hasError = false;

    if (fullName.length < 5 || fullName.length > 50) {
      setState(() {
        _fullNameError = 'Full Name must be between 5 and 50 characters';
      });
      hasError = true;
    }

    if (phone.length < 9 || phone.length > 12 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
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

    if (address.length < 10 || address.length > 300) {
      setState(() {
        _addressError = 'Address must be between 10 and 300 characters';
      });
      hasError = true;
    }

    if (hasError) return;

    String gender = _selectedGender == Gender.MALE ? 'MALE' : 'FEMALE';

    UserDTO updatedUser = UserDTO(
      id: id,
      address: address,
      avatar: _imagePath,
      description: _descriptionController.text,
      email: email,
      gender: gender,
      fullName: fullName,
      phone: phone,
      username: fullName,
      roles: [],
    );

    try {
      await Provider.of<UserProvider>(context, listen: false).updateUser(updatedUser);
      _showUpdateSuccessDialog();
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imagePath = pickedFile.path;
      });
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
                Navigator.pop(context);
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
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.largeSpacing),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (_imagePath != null && _imagePath!.isNotEmpty
                          ? NetworkImage(_imagePath!)
                          : AssetImage('lib/assets/Avatar.png')) as ImageProvider,
                    ),
                    const SizedBox(height: AppTheme.mediumSpacing),
                    TextButton(
                      onPressed: _pickImage,
                      child: Text(
                        'Change Picture',
                        style: AppTheme.theme.textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.largeSpacing),
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
              const SizedBox(height: AppTheme.smallSpacing),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  errorText: _descriptionError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppTheme.largeSpacing),
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
    );
  }
}
