import 'package:flutter/material.dart';
import 'package:healthcare_management_app/models/Clinic.dart';
import 'package:healthcare_management_app/providers/Clinic_Provider.dart';
import 'package:healthcare_management_app/screens/customers/Clinic_details.dart';
import 'package:provider/provider.dart';

import '../comons/customBottomNavBar.dart';
import '../comons/show_vertical_menu.dart';
import 'Home_customer.dart';

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
                  crossAxisCount: 2, // Số cột trong grid
                  crossAxisSpacing: 16.0, // Khoảng cách giữa các cột
                  mainAxisSpacing: 16.0, // Khoảng cách giữa các hàng
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
                        mainAxisAlignment: MainAxisAlignment.start, // Căn chỉnh các widget con ở đầu
                        crossAxisAlignment: CrossAxisAlignment.center, // Căn chỉnh theo chiều ngang
                        children: [
                          SizedBox(height: 8.0), // Thêm khoảng cách phía trên ảnh
                          // Kiểm tra điều kiện và sử dụng Image phù hợp
                          // facility?.image != null
                          //     ? ClipRRect(
                          //   borderRadius: BorderRadius.circular(10.0), // Bo góc cho ảnh
                          //   child: Image.network(
                          //     facility!.image!,
                          //     width: 100, // Kích thước cố định cho ảnh
                          //     height: 100, // Kích thước cố định cho ảnh
                          //     fit: BoxFit.cover, // Lấp đầy không gian ảnh mà không bị méo
                          //   ),
                          // )
                             // :
                          CircleAvatar(
                            backgroundImage: facility.image != null
                                ? NetworkImage(facility.image!)
                                : AssetImage('lib/assets/Avatar.png') as ImageProvider,
                            radius: 40, // Kích thước của avatar
                          ),
                          const SizedBox(height: 8.0), // Khoảng cách giữa ảnh và tên
                          // Hiển thị tên cơ sở
                          Text(
                            facility?.name ?? 'Tên cơ sở', // Dự phòng nếu tên không có
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center, // Căn giữa tên
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
