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
  String selectedStatus = 'CONFIRMED';

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<DoctorProvider>().getAllAppointmentEachDoctor();
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<DoctorProvider>().getMuntilStatusAppointmentEachDoctor(selectedStatus);
    });
  }

  void showBookingInfo(BuildContext context, AppointmentDTO booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Booking Information',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView( // Đảm bảo nội dung cuộn được nếu quá dài
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text('Patient'),
                  subtitle: Text(booking.patient.fullName ?? "N/A"),
                ),
                ListTile(
                  leading: Icon(Icons.person_outline, color: Colors.green),
                  title: Text('Doctor'),
                  subtitle: Text(booking.doctor.fullName ?? "N/A"),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.orange),
                  title: Text('Date'),
                  subtitle: Text(booking.appointmentDate?.toString() ?? "N/A"), // Hiển thị ngày tạo
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: Colors.purple),
                  title: Text('Timeslot'),
                  subtitle: Text(booking.timeSlot.startAt ?? "N/A"), // Hiển thị timeslot
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.red),
                  title: Text('Phone'),
                  subtitle: Text(booking.patient.phone ?? "N/A"), // Hiển thị số điện thoại
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.blue),
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
    String currentStatus = booking.status; // Lấy status hiện tại của booking

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Sử dụng StatefulBuilder để quản lý trạng thái trong dialog
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Change Status'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: ['CANCELLED', 'COMPLETED','CONFIRMED'].map((status) {
                  return RadioListTile<String>(
                    title: Text(status),
                    value: status,
                    groupValue: currentStatus, // Liên kết với status hiện tại
                    onChanged: (value) {
                      setState(() {
                        currentStatus = value!; // Cập nhật status khi chọn
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // Gọi hàm thay đổi trạng thái từ Provider
                    await context
                        .read<DoctorProvider>()
                        .changeStatus(booking.id, currentStatus);

                    // Cập nhật lại danh sách sau khi thay đổi
                    await context
                        .read<DoctorProvider>()
                        .getMuntilStatusAppointmentEachDoctor(selectedStatus);

                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
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
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
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
              onPressed: () async {
                // Di chuyển đến trang tạo đơn thuốc
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePrescriptionScreen(
                      booking: booking,
                    ),
                  ),
                ).then((_) async {
                  // Khi quay lại từ trang tạo đơn thuốc, cập nhật trạng thái của cuộc hẹn thành COMPLETED
                  await context.read<DoctorProvider>().changeStatus(booking.id, 'COMPLETED');

                  // Cập nhật lại danh sách cuộc hẹn sau khi thay đổi trạng thái
                  await context.read<DoctorProvider>().getMuntilStatusAppointmentEachDoctor(selectedStatus);
                });
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
    final isLoading = context.watch<DoctorProvider>().isLoading;
    final listAppointment = context.watch<DoctorProvider>().listAppointmentMultilStatus;
    //final listAppointment = context.watch<DoctorProvider>().listAppointment;
    List<AppointmentDTO> filteredBookings = listAppointment.where((booking) {
      final matchesSearch = booking.patient.fullName!.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = booking.status == selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Appointment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:  isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị vòng quay khi đang load
          : Column(
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
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() {
                        selectedStatus = value;
                      });
                      await context.read<DoctorProvider>().getMuntilStatusAppointmentEachDoctor(selectedStatus);
                    }
                  },
                  items: [
                    'PENDING',
                    'CANCELLED',
                    'CONFIRMED',
                    'COMPLETED',
                  ].map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredBookings.isEmpty
                ? Center(child: Text('No appointments found'))
                : LayoutBuilder(
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
                          Color statusColor(String status) {
                            switch (status) {
                              case 'PENDING':
                                return Colors.orange;
                              case 'CANCELLED':
                                return Colors.red;
                              case 'CONFIRMED':
                                return Colors.blue;
                              case 'COMPLETED':
                                return Colors.green;
                              default:
                                return Colors.blueAccent;
                            }
                          }
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
                                    color: statusColor(booking.status),
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
                                icon: Icon(
                                  Icons.medical_services,
                                  color: (booking.status == 'CANCELLED' || booking.status == 'COMPLETED')
                                      ? Colors.grey
                                      : Colors.green,
                                ),
                                onPressed: (booking.status == 'CANCELLED' || booking.status == 'COMPLETED')
                                    ? null
                                    : () => createPrescription(context, booking),
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