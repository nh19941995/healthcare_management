import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../dto/Doctor_dto.dart';
import '../../models/Clinic.dart';
import '../../models/GetDoctorProfile.dart';
import '../comons/customBottomNavBar.dart';
import '../comons/show_vertical_menu.dart';
import '../comons/theme.dart';
import 'Home_customer.dart';
import 'List_Clinic__Screen.dart';
import 'Doctor_information.dart';

class MedicalFacilityDetails extends StatefulWidget {
  final Clinic facility;

  MedicalFacilityDetails({required this.facility});

  @override
  _MedicalFacilityDetails createState() => _MedicalFacilityDetails();
}

class _MedicalFacilityDetails extends State<MedicalFacilityDetails> {
  TextEditingController _searchController = TextEditingController();
  List<GetDoctorProfile> filteredDoctors = []; // Thay đổi thành List<DoctorDTO>
  String get clinicsUrl => "http://localhost:8080/api/clinics/${widget.facility.id}";

  @override
  void initState() {
    super.initState();
    doctorApi(); // Gọi phương thức lấy dữ liệu bác sĩ
    _searchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> doctorApi() async {
    final String clinicsUrl = 'http://localhost:8080/api/clinics/${widget.facility.id}';

    try {
      final response = await http.get(Uri.parse(clinicsUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> doctorsDto = data['doctors'];

        setState(() {
          filteredDoctors = doctorsDto.map((doctorJson) => GetDoctorProfile.fromJson(doctorJson)).toList();
        });
      } else {
        throw Exception('Không thể lấy dữ liệu bác sĩ: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu bác sĩ: $e');
    }
  }

  void _filterDoctors() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = filteredDoctors.where((doctor) {
        return doctor.fullName!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết cơ sở y tế'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Địa chỉ:',
                      style: AppTheme.theme.textTheme.displaySmall,
                    ),
                    Text(
                      widget.facility.name,
                      style: AppTheme.theme.textTheme.displaySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.mediumSpacing),
          Text('Danh sách bác sĩ', style: AppTheme.theme.textTheme.displayLarge),
          SizedBox(height: AppTheme.mediumSpacing),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                return DoctorCard(doctor: filteredDoctors[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle other navigation
        },
        onSetupPressed: () {
          MenuUtils.showVerticalMenu(context);// Hiển thị menu khi nhấn Setup
        },
        onHomePressed: (){
          // Điều hướng về trang HomeCustomer
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeCustomer()),
          );
        },
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final GetDoctorProfile doctor;

  const DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailScreen(doctor: doctor),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: doctor.avatar != null
                  ? NetworkImage(doctor.avatar!)
                  : AssetImage('lib/assets/Avatar.png') as ImageProvider,
              radius: 40, // Kích thước của avatar
            ),
            SizedBox(height: 10),
            Text(
              doctor.fullName ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              doctor.medicalTraining!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              doctor.description ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
