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
          content: SingleChildScrollView(
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
                  subtitle: Text(booking.appointmentDate.toString() ?? "N/A"),
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: Colors.purple),
                  title: Text('Timeslot'),
                  subtitle: Text(booking.timeSlot.startAt ?? "N/A"),
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.red),
                  title: Text('Phone'),
                  subtitle: Text(booking.patient.phone ?? "N/A"),
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
          double screenWidth = constraints.maxWidth;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
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
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          border: OutlineInputBorder(),
                        ),
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
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: screenWidth),
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
                          DataCell(Text(booking.id.toString())),
                          DataCell(Text(booking.patient.fullName!)),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.blue),
                              onPressed: () => showBookingInfo(context, booking),
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
          MenuUtils.showVerticalMenu(context);
        },
        onHomePressed: () {},
      ),
    );
  }
}
