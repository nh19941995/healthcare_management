import 'package:flutter/material.dart';
import 'package:healthcare_management_app/screens/customers/Medical_facility_details.dart';

class HealthcareFacility {
  final String name;
  final String imagePath;

  HealthcareFacility(this.name, this.imagePath);
}

class ChooseHealthcareScreen extends StatefulWidget {
  @override
  _ChooseHealthcareScreenState createState() => _ChooseHealthcareScreenState();
}

class _ChooseHealthcareScreenState extends State<ChooseHealthcareScreen> {
  TextEditingController _searchController = TextEditingController();
  final List<HealthcareFacility> facilities = [
    HealthcareFacility('Lifesavers Online', 'lib/assets/Lifesavers Online.png'),
    HealthcareFacility('City Health Clinic', 'lib/assets/Lifesavers Online.png'),
    HealthcareFacility('MedCare Hospital', 'lib/assets/Lifesavers Online.png'),
    HealthcareFacility('Green Valley Clinic', 'lib/assets/Lifesavers Online.png'),
    // Add more facilities if needed
  ];

  List<HealthcareFacility> filteredFacilities = [];

  @override
  void initState() {
    super.initState();
    filteredFacilities = facilities; // Initialize with the full list
    _searchController.addListener(_filterFacilities); // Listen for changes in the search bar
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFacilities() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredFacilities = facilities.where((facility) {
        return facility.name.toLowerCase().contains(query);
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
            Navigator.pop(context); // Navigate back
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
                  crossAxisCount: 2, // Number of columns
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
                        // Handle tap on healthcare facility
                        print('Tapped on ${facility.name}');
                        // Điều hướng tới DoctorDetailScreen khi nhấn vào thẻ bác sĩ
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
                            facility.imagePath,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            facility.name,
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
