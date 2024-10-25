import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/screens/customers/Appointment_Booking.dart';

import '../comons/theme.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  DoctorDetailScreen({required this.doctor});

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  DateTime selectedDate = DateTime.now();
  List<DateTime> daysInMonth = [];

  @override
  void initState() {
    super.initState();
    _updateDaysInMonth();
  }

  void _updateDaysInMonth() {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    daysInMonth = List.generate(lastDayOfMonth.day, (index) {
      return DateTime(selectedDate.year, selectedDate.month, index + 1);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _updateDaysInMonth();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết bác sĩ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(widget.doctor['image']),
              ),
              SizedBox(height: 20),
              Text(
                widget.doctor['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.doctor['specialty'],
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text('${widget.doctor['rating']} (${widget.doctor['reviews']} reviews)'),
                ],
              ),
              SizedBox(height: 20),
              Text(
                widget.doctor['description'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Chiếm toàn bộ chiều rộng
                child: ElevatedButton(
                  style: AppTheme.elevatedButtonStyle, // Sử dụng style từ AppTheme
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentBookingScreen(
                          doctor: widget.doctor, // Truyền toàn bộ đối tượng bác sĩ
                        ),
                      ),
                    );
                  },
                  child: Text('Đặt lịch hẹn'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
