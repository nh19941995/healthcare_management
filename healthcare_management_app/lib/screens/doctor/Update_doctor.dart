import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dto/Doctor_dto.dart';
import '../../dto/update_doctor_dto.dart';
import '../../dto/user_dto.dart';
import '../../models/Clinic.dart';
import '../../models/GetDoctorProfile.dart';
import '../../models/Specialization.dart';
import '../../providers/Doctor_provider.dart';
import '../../providers/Clinic_Provider.dart';
import '../../providers/Specializations_provider.dart';
import '../comons/customBottomNavBar.dart';
import '../comons/login.dart';
import '../comons/show_vertical_menu.dart';
import '../comons/theme.dart';
import 'doctor_home.dart';

class UpdateDoctorProfileScreen extends StatefulWidget {
  final UserDTO? user;

  UpdateDoctorProfileScreen({required this.user});

  @override
  _UpdateDoctorProfileScreen createState() => _UpdateDoctorProfileScreen();
}

class _UpdateDoctorProfileScreen extends State<UpdateDoctorProfileScreen> {
  final TextEditingController _achievementsController = TextEditingController();
  final TextEditingController _medicalTrainingController = TextEditingController();
  int? _selectedClinicId;
  int? _selectedSpecializationId;
  List<DropdownMenuItem<int>> _clinicItems = [];
  List<DropdownMenuItem<int>> _specializationItems = [];
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


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
      await context.read<DoctorProvider>().getDoctorByUserName();
      GetDoctorProfile? doctorDTO = context.read<DoctorProvider>().doctor_pro;

      // Pre-fill form fields if doctorDTO is available
      if (doctorDTO != null) {
        _achievementsController.text = doctorDTO.achievements ?? '';
        _medicalTrainingController.text = doctorDTO.medicalTraining ?? '';
        _selectedClinicId = doctorDTO.clinic?.id;
        _selectedSpecializationId = doctorDTO.specialization?.id;
        _fullNameController.text = widget.user!.fullName ?? '';
        _emailController.text = widget.user!.email ?? '';
        _addressController.text = widget.user!.address ?? '';
        _phoneController.text = widget.user!.phone ?? '';
        _genderController.text = widget.user!.gender ?? '';
        _descriptionController.text = widget.user!.description ?? '';
      }

      // Load clinic and specialization data
      await context.read<SpecializationsProvider>().getAllSpecializations();
      await context.read<ClinicProvider>().getAllClinic();

      // Initialize dropdown items
      _loadClinics();
      _loadSpecializations();

      setState(() {});
    } catch (e) {
      print(e); // Debug lỗi
      _showErrorDialog('Error Loading Data', 'Failed to load profile or related data.');
    }
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

  void _saveProfile() async {
    UpdateDoctorDto updatedDoctor = UpdateDoctorDto(
      achievements: _achievementsController.text,
      medicalTraining: _medicalTrainingController.text,
      clinicId: _selectedClinicId,
      specializationId: _selectedSpecializationId,
      gender: _genderController.text,
      description: _descriptionController.text,
      fullName: _fullNameController.text,
      email: _emailController.text,
      address: _addressController.text,
      phone: _phoneController.text,
    );


    try {
      await context.read<DoctorProvider>().updateDoctor(updatedDoctor);
      _showUpdateSuccessDialog();
    } catch (e) {
      print(e); // Debug lỗi
      _showErrorDialog('Update Failed', 'An error occurred while updating your profile.');
    }
  }

  void _showUpdateSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Successful'),
        content: Text('Your profile has been updated successfully. Please log in again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                    (route) => false,
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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

  @override
  void dispose() {
    _achievementsController.dispose();
    _medicalTrainingController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Doctor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text("Welcome : ${widget.user?.fullName}", style: Theme.of(context).textTheme.displayLarge),
              SizedBox(height: 20),
              _buildTextField(_fullNameController, 'Full Name'),
              _buildTextField(_emailController, 'Email'),
              _buildTextField(_addressController, 'Address'),
              _buildTextField(_phoneController, 'Phone'),
              _buildTextField(_genderController, 'Gender'),
              _buildTextField(_descriptionController, 'Description'),

              _buildTextField(_achievementsController, 'Achievements'),
              _buildTextField(_medicalTrainingController, 'Medical Training'),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: AppTheme.elevatedButtonStyle,
                  onPressed: _saveProfile,
                  child: Text('Save'),
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
            MaterialPageRoute(builder: (context) => DoctorHomeScreen(user: widget.user!,)),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
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
}
