import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/Doctor_dto.dart';

import '../../models/user.dart';
import 'Doctor_Detail_Screen.dart';

class DoctorSelectionScreen extends StatefulWidget {
  final User user;

  const DoctorSelectionScreen({super.key, required this.user});
  @override
  _DoctorSelectionScreenState createState() => _DoctorSelectionScreenState();
}

class _DoctorSelectionScreenState extends State<DoctorSelectionScreen> {
  TextEditingController _searchController = TextEditingController();
  // Tạo fake data cho DoctorDTO
  List<DoctorDTO> doctors = [
    DoctorDTO(
      id: 1,
      achievements: 'Published research in viral treatments, Nobel award nominee',
      medicalTraining: 'Harvard Medical School',
      clinicId: 101,
      specializationId: 201,
      status: 'ACTIVE',
      lockReason: null,
      username: 'dr_bellamy',
      avatar: 'lib/assets/doctor1.png',
    ),
    DoctorDTO(
      id: 2,
      achievements: 'Awarded Oncologist of the Year, published over 20 studies',
      medicalTraining: 'Johns Hopkins University',
      clinicId: 102,
      specializationId: 202,
      status: 'ACTIVE',
      lockReason: null,
      username: 'dr_mensah',
      avatar: 'lib/assets/doctor2.png',
    ),
    DoctorDTO(
      id: 3,
      achievements: 'Performed over 1,000 successful surgeries',
      medicalTraining: 'Stanford University',
      clinicId: 103,
      specializationId: 203,
      status: 'LOCKED',
      lockReason: 'Under investigation',
      username: 'dr_klimisch',
      avatar: 'lib/assets/doctor3.png',
    ),
    DoctorDTO(
      id: 4,
      achievements: 'Specialized in child development, awarded Pediatrician of the Year',
      medicalTraining: 'UCLA Medical School',
      clinicId: 104,
      specializationId: 204,
      status: 'ACTIVE',
      lockReason: null,
      username: 'dr_martinez',
      avatar: 'lib/assets/doctor4.png',
    ),
    // Thêm các đối tượng giả khác tương tự...
  ];


  List<DoctorDTO> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    filteredDoctors = doctors;
    _searchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDoctors() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        return doctor.username.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn thông tin bác sĩ'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bác sĩ',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
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
        // Điều hướng tới DoctorDetailScreen khi nhấn vào thẻ bác sĩ
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
              backgroundImage: AssetImage(doctor.avatar ?? 'lib/assets/Avatar.png'),
            ),
            SizedBox(height: 10),
            Text(
              doctor.username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(doctor.achievements),
            // SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Icon(Icons.star, color: Colors.amber),
            //     Text('${doctor['rating']} (${doctor['reviews']} reviews)'),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}