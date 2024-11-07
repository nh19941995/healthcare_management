import 'package:flutter/material.dart';
import 'package:healthcare_management_app/models/Clinic.dart';
import 'package:healthcare_management_app/providers/Clinic_Provider.dart';
import 'package:healthcare_management_app/screens/customers/Clinic_details.dart';
import 'package:provider/provider.dart';

class ListClinic extends StatefulWidget {
  @override
  _ListClinic createState() => _ListClinic();
}

class _ListClinic extends State<ListClinic> {
  TextEditingController _searchController = TextEditingController();
  List<Clinic> filteredFacilities = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final clinicProvider = context.read<ClinicProvider>();
      clinicProvider.getAllClinic().then((_) {
        setState(() {
          print(clinicProvider.list);
          filteredFacilities = clinicProvider.list; // Lấy danh sách sau khi đã cập nhật
        });
      });
    });
    _searchController.addListener(_filterFacilities);
  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFacilities() {
    String query = _searchController.text.toLowerCase();
    final listClinic = context.read<ClinicProvider>().list;
    setState(() {
      filteredFacilities = listClinic.where((facility) {
        return facility.name!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn cơ sở y tế'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm cơ sở y tế',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            // Grid of healthcare facilities
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: filteredFacilities.length,
                itemBuilder: (context, index) {
                  final facility = filteredFacilities[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 4.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicalFacilityDetails(facility: facility),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            //facility.image!,
                            'lib/assets/hospital-facility.png',
                            width: 80, // Chỉnh kích thước width theo nhu cầu
                            height: 80, // Chỉnh kích thước height theo nhu cầu
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            facility.name!,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
