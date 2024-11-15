import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/Appointment_dto.dart';
import 'package:healthcare_management_app/dto/user_dto.dart';
import 'package:healthcare_management_app/providers/Doctor_provider.dart';
import 'package:healthcare_management_app/screens/comons/customBottomNavBar.dart';
import 'package:healthcare_management_app/screens/comons/show_vertical_menu.dart';
import 'package:provider/provider.dart';

import 'Create_Prescription_Screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  final UserDTO user;
  DoctorHomeScreen({required this.user});

  @override
  _DoctorHomeScreen createState() => _DoctorHomeScreen();
}

class _DoctorHomeScreen extends State<DoctorHomeScreen> {
  String searchQuery = '';
  String selectedStatus = 'Tất cả';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProvider>().getAllAppointmentEachDoctor();
    });
  }

  void showBookingInfo(BuildContext context, AppointmentDTO booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Booking Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blueAccent,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Patient:', booking.patient.fullName!),
                _buildInfoRow('Doctor:', booking.doctor.fullName!),
                Text('Date: ${booking.createdAt}'),
                Text('Time slot : ${booking.timeSlot.startAt}'),
                _buildInfoRow('Phone:', booking.patient.phone!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void showStatusOptions(BuildContext context, AppointmentDTO booking) {
    String selectedStatus = booking.status;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Status'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (String status in ['CANCELLED', 'COMPLETED'])
                    RadioListTile<String>(
                      title: Text(status),
                      value: status,
                      groupValue: selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                //context.read<DoctorProvider>().ch(booking.id, selectedStatus);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      case 'CONFIRMED':
        return Colors.green;
      case 'COMPLETED':
        return Colors.blue;
      case 'NO_SHOW':
        return Colors.grey;
      case 'RESCHEDULED':
        return Colors.purple;
      default:
        return Colors.blueAccent;
    }
  }

  // Hàm tạo đơn thuốc
  void createPrescription(BuildContext context, AppointmentDTO booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Prescription for ${booking.patient.fullName}'),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Thêm các trường thông tin cần thiết để tạo đơn thuốc
                Text('Medication details...'),
                // Có thể thêm các trường nhập liệu nếu cần
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Xử lý tạo đơn thuốc ở đây
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePrescriptionScreen(
                        booking:booking
                    ),
                  ),
                );
              },
              child: Text('Create Prescription'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listAppointment = context.watch<DoctorProvider>().listAppointment;
    List<AppointmentDTO> filteredBookings = listAppointment.where((booking) {
      return booking.patient.fullName!.toLowerCase().contains(searchQuery.toLowerCase()) &&
          (selectedStatus == 'Tất cả' || booking.status == selectedStatus);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Appointment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search by name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                  items: [
                    'Tất cả',
                    'PENDING',
                    'CANCELLED',
                    'CONFIRMED',
                    'COMPLETED',
                    'NO_SHOW',
                    'RESCHEDULED',
                  ].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: DataTable(
                        columnSpacing: constraints.maxWidth * 0.05,
                        columns: [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Patient')),
                          DataColumn(label: Text('Info')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Prescription')), // Cột mới cho nút tạo đơn thuốc
                        ],
                        rows: filteredBookings.map((booking) {
                          return DataRow(cells: [
                            DataCell(Text(booking.id.toString())),
                            DataCell(Text(booking.patient.fullName!)),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.info, color: Colors.blue),
                                onPressed: () => showBookingInfo(context, booking),
                              ),
                            ),
                            DataCell(
                              InkWell(
                                onTap: () => showStatusOptions(context, booking),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(booking.status),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    booking.status,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.medical_services, color: Colors.green),
                                onPressed: () => createPrescription(context, booking),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                );
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
        },
      ),
    );
  }
}
