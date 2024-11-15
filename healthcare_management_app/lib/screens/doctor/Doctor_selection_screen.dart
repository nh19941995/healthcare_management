import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/Doctor_dto.dart';
import 'package:healthcare_management_app/providers/Doctor_provider.dart';
import 'package:provider/provider.dart';

import '../customers/Doctor_Detail_Screen.dart';

class DoctorSelectionScreen extends StatefulWidget {
  const DoctorSelectionScreen({super.key});

  @override
  _DoctorSelectionScreenState createState() => _DoctorSelectionScreenState();
}

class _DoctorSelectionScreenState extends State<DoctorSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DoctorDTO> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final doctorProvider = context.read<DoctorProvider>();
      doctorProvider.getAllDoctor().then((_) {
        setState(() {
          filteredDoctors = doctorProvider.list;
        });
      });
    });
    _searchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterDoctors);
    _searchController.dispose();
    super.dispose();
  }

  void _filterDoctors() {
    String query = _searchController.text.toLowerCase();
    final listDoctor = context.read<DoctorProvider>().list;
    setState(() {
      filteredDoctors = listDoctor.where((doctor) {
        return doctor.fullName?.toLowerCase().contains(query) ?? false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn thông tin bác sĩ'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bác sĩ',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              backgroundImage: doctor.avatar != null
                  ? NetworkImage(doctor.avatar!) as ImageProvider
                  : const AssetImage('lib/assets/Avatar.png'),
              radius: 30, // Kích thước avatar
            ),
            const SizedBox(height: 10),
            Text(
              doctor.fullName ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              doctor.medicalTraining ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              doctor.achievements ?? '',
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