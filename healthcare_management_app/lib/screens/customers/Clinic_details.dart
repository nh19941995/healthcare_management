import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../dto/Doctor_dto.dart';
import '../../models/Clinic.dart';
import '../comons/theme.dart';
import 'List_Clinic__Screen.dart';
import 'Doctor_Detail_Screen.dart';

class MedicalFacilityDetails extends StatefulWidget {
  final Clinic facility;

  MedicalFacilityDetails({required this.facility});

  @override
  _MedicalFacilityDetails createState() => _MedicalFacilityDetails();
}

class _MedicalFacilityDetails extends State<MedicalFacilityDetails> {
  TextEditingController _searchController = TextEditingController();
  List<DoctorDTO> filteredDoctors = []; // Thay đổi thành List<DoctorDTO>
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
        final List<dynamic> doctorsDto = data['doctorsDto'];

        setState(() {
          filteredDoctors = doctorsDto.map((doctorJson) => DoctorDTO.fromJson(doctorJson)).toList();
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
        return doctor.username!.toLowerCase().contains(query);
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
    );
  }
}

class DoctorCard extends StatelessWidget {
  final DoctorDTO doctor;

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
              radius: 40,
              backgroundImage: AssetImage(doctor.avatar ?? 'lib/assets/default_avatar.png'),
            ),
            SizedBox(height: 10),
            Text(
              doctor.username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(doctor.specializationId.toString()), // Hiển thị ID chuyên môn
            SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Icon(Icons.star, color: Colors.amber),
            //     Text('Chưa có đánh giá'), // Có thể thêm thông tin đánh giá nếu có
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
