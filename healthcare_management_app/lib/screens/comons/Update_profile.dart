import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/providers/user_provider.dart';
import 'package:healthcare_management_app/screens/comons/show_vertical_menu.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healthcare_management_app/enum.dart';
import 'package:healthcare_management_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html; // Chỉ sử dụng trên Web
import 'package:flutter/foundation.dart'; // Để sử dụng kIsWeb

import '../../dto/updateUserForDoctorDto.dart';
import '../../dto/user_dto.dart';
import '../../models/Clinic.dart';
import '../../models/GetDoctorProfile.dart';
import '../../models/Specialization.dart';
import '../../providers/Clinic_Provider.dart';
import '../../providers/Doctor_provider.dart';
import '../../providers/Specializations_provider.dart';
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
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _achievementsController = TextEditingController();
  final TextEditingController _medicalTrainingController = TextEditingController();
   int? _selectedClinicId;
  int? _selectedSpecializationId;
  List<DropdownMenuItem<int>> _clinicItems = [];
  List<DropdownMenuItem<int>> _specializationItems = [];

  String? _avatarBytes;
  Gender? _selectedGender = Gender.MALE;

  String? _fullNameError;
  String? _phoneError;
  String? _emailError;
  String? _addressError;
  String? _signError;
  String? _descriptionError;
  String? _achievementError;
  String? _medicalTrainingError;

  bool _obscurePassword = true;
  bool _obscureRePassword = true;
  bool _isUploadingImage = false;
  html.File? _pickedFile;

  bool _isDoctor = false;  // Biến để kiểm tra người dùng có phải là bác sĩ không

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _achievementsController.dispose();
    _medicalTrainingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });


  }
  Future<void> _loadData() async {
    try {
      // Fetch doctor data
      // Pre-fill form fields if doctorDTO is available
      if(widget.userDTO != null) {
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

        // Kiểm tra xem có vai trò "DOCTOR" không trong danh sách roles
      }
      if (widget.userDTO!.roles != null && widget.userDTO!.roles!.isNotEmpty) {
        bool hasDoctorRole = widget.userDTO!.roles!.any((role) => role.name == "DOCTOR");
         await context.read<DoctorProvider>().getDoctorByUserName();
         await context.read<SpecializationsProvider>().getAllSpecializations();
         await context.read<ClinicProvider>().getAllClinic();

        if (hasDoctorRole) {
          setState(() {
            _isDoctor = true; // Nếu là bác sĩ thì cho phép hiển thị các trường liên quan đến bác sĩ
          });

          // Nếu là bác sĩ, lấy thông tin bác sĩ
          context.read<DoctorProvider>().getDoctorByUserName();
          GetDoctorProfile? doctorDTO = context.read<DoctorProvider>().doctor_pro;
          _achievementsController.text = doctorDTO?.achievements ?? '';
          _medicalTrainingController.text = doctorDTO?.medicalTraining ?? '';
          _selectedClinicId = doctorDTO?.clinic?.id;
          _selectedSpecializationId = doctorDTO?.specialization?.id;
        }
      }

      _loadClinics();
      _loadSpecializations();

      setState(() {});
    } catch (e) {
      print(e); // Debug lỗi
    }
  }
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  void _loadClinics() {
    List<Clinic> clinics = context.read<ClinicProvider>().list;
    if (clinics.isNotEmpty) {
      _clinicItems = clinics.map((clinic) {
        return DropdownMenuItem<int>(
          value: clinic.id,
          child: Text(clinic.name),
        );
      }).toList();
    } else {
      _clinicItems = [];
    }
  }

  void _loadSpecializations() {
    List<Specialization> specializations = context.read<SpecializationsProvider>().list;
    if (specializations.isNotEmpty) {
      _specializationItems = specializations.map((specialization) {
        return DropdownMenuItem<int>(
          value: specialization.id,
          child: Text(specialization.name!),
        );
      }).toList();
    } else {
      _specializationItems = [];
    }
  }


  // Các phương thức loadClinics và loadSpecializations không thay đổi

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
    // Reset lỗi
    setState(() {
      _fullNameError = null;
      _phoneError = null;
      _emailError = null;
      _addressError = null;
      _signError = null;
      _descriptionError = null;
      _achievementError = null;
      _medicalTrainingError = null;
    });

    // Lấy dữ liệu từ các controller
    String fullName = _fullNameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    String address = _addressController.text;
    String description = _descriptionController.text;
    String achievements = _achievementsController.text;
    String medicalTraining = _medicalTrainingController.text;
    int? clinicId = _selectedClinicId;
    int? specializationId = _selectedSpecializationId;

    bool hasError = false;

    // Kiểm tra lỗi đầu vào
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

    if (address.length < 5 || address.length > 300) {
      setState(() {
        _addressError = 'Address must be from 5 to 300 characters';
      });
      hasError = true;
    }

    if (description.length < 5 || description.length > 300) {
      setState(() {
        _descriptionError = 'Description must be from 5 to 300 characters';
      });
      hasError = true;
    }

    if (hasError) return; // Nếu có lỗi, dừng thực thi

    // Xác định giới tính và tải avatar (nếu có)
    String gender = _selectedGender == Gender.MALE ? 'MALE' : 'FEMALE';
    String avatar = "";

    if (_pickedFile != null) {
      String? avatarUrl =
      await Provider.of<UserProvider>(context, listen: false)
          .uploadImage(_pickedFile);
      avatar = avatarUrl ?? "";
    }
    if(_pickedFile != null && _isDoctor) {
      String? avatarUrl =
      await Provider.of<UserProvider>(context, listen: false)
          .uploadImage(_pickedFile);
      avatar = avatarUrl ?? "";
    }

    // Chuẩn bị dữ liệu cho API
    UserDTO updatedUser = UserDTO(
      id: widget.userDTO?.id,
      address: address,
      description: description,
      email: email,
      gender: gender,
      fullName: fullName,
      phone: phone,
      username: widget.userDTO!.username,
      avatar: avatar,
    );

    UpdateUserForDoctorDto updateUserForDoctorDto = UpdateUserForDoctorDto(
      id: widget.userDTO!.id,
      fullName: fullName,
      username: widget.userDTO!.username,
      email: email,
      address: address,
      phone: phone,
      gender: gender,
      description: description,
      achievements: achievements,
      medicalTraining: medicalTraining,
      clinicId: clinicId,
      specializationId: specializationId,
      avatar: avatar,
    );

    // Gửi dữ liệu đến API
    try {
      if (_isDoctor) {
        await Provider.of<UserProvider>(context, listen: false)
            .updateUserForDoctor(updateUserForDoctorDto);
      } else {
        await Provider.of<UserProvider>(context, listen: false)
            .updateUser(updatedUser);
      }

      // Hiển thị thông báo thành công
      _showUpdateSuccessDialog();
    } catch (e) {
      // Xử lý lỗi
      setState(() {
        _signError = 'The name already exists, please choose another name';
      });
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                  radius: 48,
                ),
              ),

              if (_isUploadingImage) CircularProgressIndicator(),
              Text('Tap to select an image'),
              SizedBox(height: 20),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  errorText: _fullNameError,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                  errorText: _phoneError,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: _emailError,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  errorText: _addressError,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  errorText: _descriptionError,
                ),
              ),
              const SizedBox(height: 10),

              // Các trường liên quan đến bác sĩ chỉ hiển thị nếu người dùng là bác sĩ
              if (_isDoctor) ...[
                TextField(
                  controller: _achievementsController,
                  decoration: InputDecoration(
                    labelText: "Achievements",
                    errorText: _achievementError,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _medicalTrainingController,
                  decoration: InputDecoration(
                    labelText: "Medical Training",
                    errorText: _medicalTrainingError,
                  ),
                ),
                const SizedBox(height: 10),
                // Dropdown cho Clinic và Specialization
                _buildDropdown(_clinicItems, 'Clinic', (value) {
                  setState(() {
                    _selectedClinicId = value;
                  });
                }, _selectedClinicId),
                _buildDropdown(_specializationItems, 'Specialization', (value) {
                  setState(() {
                    _selectedSpecializationId = value;
                  });
                }, _selectedSpecializationId),
                SizedBox(height: 30),

              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Chiếm toàn bộ chiều rộng
                child: ElevatedButton(
                  style: AppTheme.elevatedButtonStyle, // Sử dụng style từ AppTheme
                  onPressed: _signUp,
                  child: Text('Save Changes')
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget _buildDropdown(List<DropdownMenuItem<int>> items, String label, ValueChanged<int?> onChanged, int? value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      value: value,
      items: items.isNotEmpty
          ? items
          : [DropdownMenuItem(value: null, child: Text('Loading...'))],
      onChanged: onChanged,
    ),
  );
}
