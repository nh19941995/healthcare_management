import 'package:flutter/material.dart';

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
  List<Map<String, dynamic>> doctors = [
    {
      'name': 'Dr. Bellamy N',
      'specialty': 'Virologist',
      'rating': 4.5,
      'reviews': 135,
      'image': 'lib/assets/doctor1.png',
      'description':
      'Dr. Bellamy N is an expert in viral infections and has over 15 years of experience in treating patients with complex viral diseases. She is known for her research in the field of virology and has contributed to numerous studies on vaccine development.',
    },
    {
      'name': 'Dr. Mensah T',
      'specialty': 'Oncologist',
      'rating': 4.3,
      'reviews': 130,
      'image': 'lib/assets/doctor2.png',
      'description':
      'Dr. Mensah T specializes in oncology and has helped hundreds of patients in their battle against cancer. He is passionate about finding the best treatments tailored to each individual, with a strong focus on research in cancer therapy.',
    },
    {
      'name': 'Dr. Klimisch J',
      'specialty': 'Surgeon',
      'rating': 4.5,
      'reviews': 135,
      'image': 'lib/assets/doctor3.png',
      'description':
      'Dr. Klimisch J is a highly skilled surgeon with expertise in minimally invasive surgeries. He has performed over 1,000 successful operations and is known for his attention to detail and care for his patients.',
    },
    {
      'name': 'Dr. Martinez K',
      'specialty': 'Pediatrician',
      'rating': 4.3,
      'reviews': 130,
      'image': 'lib/assets/doctor4.png',
      'description':
      'Dr. Martinez K has dedicated her career to helping children. She is a compassionate pediatrician who believes in building trust with both the children she treats and their parents. Her focus is on preventive care and childhood development.',
    },
    {
      'name': 'Dr. Klimisch J',
      'specialty': 'Surgeon',
      'rating': 4.5,
      'reviews': 135,
      'image': 'lib/assets/doctor3.png',
      'description':
      'Dr. Klimisch J is a highly skilled surgeon with expertise in minimally invasive surgeries. He has performed over 1,000 successful operations and is known for his attention to detail and care for his patients.',
    },
    {
      'name': 'Dr. Martinez K',
      'specialty': 'Pediatrician',
      'rating': 4.3,
      'reviews': 130,
      'image': 'lib/assets/doctor4.png',
      'description':
      'Dr. Martinez K has dedicated her career to helping children. She is a compassionate pediatrician who believes in building trust with both the children she treats and their parents. Her focus is on preventive care and childhood development.',
    },
    {
      'name': 'Dr. Klimisch J',
      'specialty': 'Surgeon',
      'rating': 4.5,
      'reviews': 135,
      'image': 'lib/assets/doctor3.png',
      'description':
      'Dr. Klimisch J is a highly skilled surgeon with expertise in minimally invasive surgeries. He has performed over 1,000 successful operations and is known for his attention to detail and care for his patients.',
    },
    {
      'name': 'Dr. Martinez K',
      'specialty': 'Pediatrician',
      'rating': 4.3,
      'reviews': 130,
      'image': 'lib/assets/doctor4.png',
      'description':
      'Dr. Martinez K has dedicated her career to helping children. She is a compassionate pediatrician who believes in building trust with both the children she treats and their parents. Her focus is on preventive care and childhood development.',
    }
  ];

  List<Map<String, dynamic>> filteredDoctors = [];

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
        return doctor['name'].toLowerCase().contains(query);
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
  final Map<String, dynamic> doctor;

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
              backgroundImage: AssetImage(doctor['image']),
            ),
            SizedBox(height: 10),
            Text(
              doctor['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(doctor['specialty']),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber),
                Text('${doctor['rating']} (${doctor['reviews']} reviews)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}