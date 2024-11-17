import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_management_app/dto/Appointment_dto.dart';
import 'package:healthcare_management_app/providers/Appointment_provider.dart';
import 'package:healthcare_management_app/screens/comons/admin_Bottom_NavBar.dart';
import 'package:healthcare_management_app/screens/comons/show_vertical_menu.dart';

class BookingTableScreen extends StatefulWidget {
  @override
  _BookingTableScreenState createState() => _BookingTableScreenState();
}

class _BookingTableScreenState extends State<BookingTableScreen> {
  String searchQuery = '';
  String selectedStatus = 'ALL';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().getAllAppointment();
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
                  subtitle: Text(booking.appointmentDate.toString() ?? "N/A"), // Hiển thị ngày tạo
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


  @override
  Widget build(BuildContext context) {
    final appointments = context.watch<AppointmentProvider>().listAppointmentAll;
    List<AppointmentDTO> filteredBookings = appointments.where((booking) {
      return booking.patient.fullName!.toLowerCase().contains(searchQuery.toLowerCase()) &&
          (selectedStatus == 'ALL' || booking.status == selectedStatus);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Make an appointment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth; // Chiều rộng khả dụng
          return Column(
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
                        'ALL',
                        'PENDING',
                        'CANCELLED',
                        'CONFIRMED',
                        'COMPLETED'
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
                  scrollDirection: Axis.horizontal, // Cuộn ngang
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: screenWidth), // Đảm bảo bảng không nhỏ hơn màn hình
                    child: DataTable(
                      columnSpacing: 12,
                      columns: [
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('Patient')),
                        DataColumn(label: Text('Info')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: filteredBookings.map((booking) {
                        Color statusColor(String status) {
                          switch (status) {
                            case 'PENDING':
                              return Colors.orange;
                            case 'CANCELLED':
                              return Colors.red;
                            case 'CONFIRMED':
                              return Colors.blueAccent;
                            case 'COMPLETED':
                              return Colors.green;
                            default:
                              return Colors.grey;
                          }
                        }

                        return DataRow(cells: [
                          DataCell(Text(booking.id.toString())), // Hiển thị ID
                          DataCell(Text(booking.patient.fullName!)), // Hiển thị tên bệnh nhân
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.blue),
                              onPressed: () => showBookingInfo(context, booking), // Hiển thị thông tin booking
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: AdminBottomNavbar(
        currentIndex: 0,
        onTap: (index) {
          // Handle other navigation
        },
        onSetupPressed: () {
          MenuUtils.showVerticalMenu(context); // Hiển thị menu khi nhấn Setup
        },
        onHomePressed: () {},
      ),
    );
  }

}
