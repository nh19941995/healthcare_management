import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/Appointment_dto.dart';
import 'package:healthcare_management_app/providers/Appointment_provider.dart';
import 'package:healthcare_management_app/screens/comons/admin_Bottom_NavBar.dart';
import 'package:healthcare_management_app/screens/comons/customBottomNavBar.dart';
import 'package:healthcare_management_app/screens/comons/show_vertical_menu.dart';
import 'package:provider/provider.dart';

import '../comons/User_List_Screen.dart';

class BookingTableScreen extends StatefulWidget {
  @override
  _BookingTableScreenState createState() => _BookingTableScreenState();
}

class _BookingTableScreenState extends State<BookingTableScreen> {
  final List<Map<String, dynamic>> bookings = [
    {
      'id': '01',
      'title': 'Tạo module mới',
      'patient': 'Nguyen Van A',
      'doctor': 'Nguyen Van B',
      'date': '12/06/2023',
      'status': 'Đang xử lý',
      'phone': '0123456789',
      'reason': '',
    },
    {
      'id': '02',
      'title': 'Nút mua hàng lỗi',
      'patient': 'Nguyen Van C',
      'doctor': 'Nguyen Van D',
      'date': '12/06/2023',
      'status': 'Đang xử lý',
      'phone': '0987654321',
      'reason': '',
    },
    {
      'id': '03',
      'title': 'Giỏ hàng tải chậm',
      'patient': 'Nguyen Van E',
      'doctor': 'Nguyen Van F',
      'date': '12/06/2023',
      'status': 'Từ chối',
      'phone': '0112233445',
      'reason': 'Lý do từ chối',
    },
    {
      'id': '04',
      'title': 'Tạo module chat',
      'patient': 'Nguyen Van G',
      'doctor': 'Nguyen Van H',
      'date': '12/06/2023',
      'status': 'Chấp nhận',
      'phone': '0998877665',
      'reason': '',
    },
  ];



  String searchQuery = '';
  String selectedStatus = 'Tất cả';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().getAllAppointment();
      print("getAllAppointment ${context.read<AppointmentProvider>().listAppointmentAll}");
    });
  }


  void showBookingInfo(BuildContext context, AppointmentDTO booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Booking Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Patient: ${booking.patient.fullName}'),
              Text('Doctor: ${booking.doctor.fullName}'),
              Text('Date: ${booking.createdAt}'),
              Text('Phone: ${booking.patient.phone}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
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
                  for (String status in ['PENDING', 'CANCELLED', 'CONFIRMED'])
                    RadioListTile<String>(
                      title: Text(status),
                      value: status,
                      groupValue: selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                          // if (selectedStatus != 'Từ chối') {
                          //   booking['reason'] = '';
                          // }
                        });
                      },
                    ),
                  // if (selectedStatus == 'Từ chối')
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: TextField(
                  //       decoration: InputDecoration(
                  //         labelText: 'Lý do từ chối',
                  //         border: OutlineInputBorder(),
                  //       ),
                  //       onChanged: (value) {
                  //         booking['reason'] = value;
                  //       },
                  //     ),
                  //   ),
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
                setState(() {
                  booking.status = selectedStatus;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void confirmDeleteBooking(BuildContext context, AppointmentDTO booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Bạn có chắc chắn muốn xóa mục này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  bookings.remove(booking);
                });
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointments = context.watch<AppointmentProvider>().listAppointmentAll;
    List<AppointmentDTO> filteredBookings = appointments.where((booking) {
      return booking.patient.fullName!.toLowerCase()
          .contains(searchQuery.toLowerCase()) &&
          (selectedStatus == 'Tất cả' || booking.status == selectedStatus);
    }).toList();


    return Scaffold(
      appBar: AppBar(
        title: Text('Make an appointment'),
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
                      labelText: 'Tìm kiếm theo tên',
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
                    'Chấp nhận',
                    'Đang xử lý',
                    'Từ chối',
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DataTable(
                    columnSpacing: 12,
                    columns: [
                      DataColumn(label: Expanded(child: Text('#'))),
                      DataColumn(label: Expanded(child: Text('Patient'))),
                      DataColumn(label: Expanded(child: Text('Info'))),
                      DataColumn(label: Expanded(child: Text('Status'))),
                      DataColumn(label: Expanded(child: Text('Delete'))),
                    ],
                    rows: filteredBookings.map((booking) {
                      Color statusColor;
                      if (booking.status == 'CONFIRMED') {
                        statusColor = Colors.green;
                      } else if (booking.status == 'PENDING') {
                        statusColor = Colors.blue;
                      } else {
                        statusColor = Colors.red;
                      }

                      return DataRow(cells: [
                        DataCell(Text(booking.id.toString())),
                        DataCell(Text(booking.patient.fullName!)),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.blue),
                            onPressed: () => showBookingInfo(context, booking),
                          ),
                        ),
                        DataCell(
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: statusColor,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onPressed: () =>
                                showStatusOptions(context, booking),
                            child: Text(
                              booking.status,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.grey),
                            onPressed: () => confirmDeleteBooking(context, booking),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Thêm CustomBottomNavBar ở đây
      bottomNavigationBar:AdminBottomNavbar(
        currentIndex: 0,
        onTap: (index) {
          // Handle other navigation
        },
        onSetupPressed: () {
          MenuUtils.showVerticalMenu(context);// Hiển thị menu khi nhấn Setup
        },
        onHomePressed: (){},
      ),
    );
  }
}
