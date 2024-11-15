import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/Appointment_dto.dart';
import 'package:healthcare_management_app/providers/Receptionist_provider.dart';
import 'package:healthcare_management_app/screens/comons/customBottomNavBar.dart';
import 'package:healthcare_management_app/screens/comons/show_vertical_menu.dart';
import 'package:provider/provider.dart';

class ReceptionistHome extends StatefulWidget {
  @override
  _ReceptionistHome createState() => _ReceptionistHome();
}

class _ReceptionistHome extends State<ReceptionistHome> {
  String searchQuery = '';
  String selectedStatus = 'Tất cả';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReceptionistProvider>().getAllAppointment();
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
              Text('Patient: ${booking.patient.fullName!}'),
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
                  for (String status in ['PENDING', 'CANCELLED', 'CONFIRMED']) //PENDING|CONFIRMED|COMPLETED|NO_SHOW|CANCELLED|RESCHEDULED
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
                  // if (selectedStatus == 'CANCELLED')
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: TextField(
                  //       decoration: InputDecoration(
                  //         labelText: 'Lý do từ chối',
                  //         border: OutlineInputBorder(),
                  //       ),
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
                context.read<ReceptionistProvider>().changeStatus(booking.id, selectedStatus);
                context.read<ReceptionistProvider>().getAllAppointment();
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
                  // Handle deletion here
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
    final listAppointment = context.watch<ReceptionistProvider>().listAppointment;
    List<AppointmentDTO> filteredBookings = listAppointment.where((booking) {
      return booking.patient
          .toString()
          .toLowerCase()
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
                // DropdownButton<String>(
                //   value: selectedStatus,
                //   onChanged: (value) {
                //     setState(() {
                //       selectedStatus = value!;
                //     });
                //   },
                //   items: [
                //     'Tất cả',
                //     'Chấp nhận',
                //     'Đang xử lý',
                //     'Từ chối',
                //   ].map((status) {
                //     return DropdownMenuItem(
                //       value: status,
                //       child: Text(status),
                //     );
                //   }).toList(),
                // ),
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
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: DataTable(
                        columnSpacing: constraints.maxWidth * 0.05, // Responsive column spacing
                        columns: [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Patient')),
                          DataColumn(label: Text('Info')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Delete')),
                        ],
                        rows: filteredBookings.map((booking) {
                          // Configure your row cells
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
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0), // Adjust the padding value as needed
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      padding: EdgeInsets.symmetric(horizontal: 12), // Adjust horizontal padding if needed
                                    ),
                                    onPressed: () => showStatusOptions(context, booking),
                                    child: Text(
                                      booking.status,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
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
                );
              },
            ),
          ),

        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle other navigation
        },
        onSetupPressed: () {
          MenuUtils.showVerticalMenu(context); // Show menu on Setup press
        },
        onHomePressed: (){},
      ),
    );
  }
}
