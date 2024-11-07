import 'package:flutter/material.dart';
import 'package:healthcare_management_app/apis/user_api.dart';
import 'package:healthcare_management_app/dto/Doctor_dto.dart';
import 'package:healthcare_management_app/dto/user_dto.dart';
import 'package:healthcare_management_app/models/Time_slot.dart';
import 'package:healthcare_management_app/providers/Clinic_Provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../comons/TokenManager.dart';
import '../comons/theme.dart';
import 'Appointment_Booking.dart'; // Import intl để sử dụng DateFormat

class AppointmentBookingScreen extends StatefulWidget {
  final DoctorDTO doctor;

  AppointmentBookingScreen({required this.doctor});

  @override
  _AppointmentBookingScreenState createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  late UserApi userApi;
  late UserProvider userProvider;
  UserDTO? user;
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  TextEditingController _descriptionController = TextEditingController();
  List<DateTime> daysInMonth = [];



  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);

    // Bắt đầu fetch user và cập nhật trạng thái
    userProvider.fetchUser().then((_) {
      setState(() {
        user = userProvider.user; // Cập nhật user sau khi fetch
      });
    });
    daysInMonth = _generateDaysInMonth(selectedDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClinicProvider>().getAllTimeSlot();
    });
  }


  // Hàm tạo danh sách các ngày trong tháng
  List<DateTime> _generateDaysInMonth(DateTime date) {
    int daysCount = DateTime(date.year, date.month + 1, 0).day;
    return List.generate(daysCount, (index) => DateTime(date.year, date.month, index + 1));
  }

  // Hiển thị dialog xác nhận
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận phiếu đặt'),
          content: Container(
            width: 400, // Thiết lập chiều rộng
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bác sĩ: ${widget.doctor.username}'),
                Text('Medical Training: ${widget.doctor.medicalTraining}'),
                SizedBox(height: 8),
                Text('Thong tin khach hang'),
                Text('Name: ${user?.fullName}'),
                Text('Phone: ${user?.phone}'),
                SizedBox(height: 8),
                Text('Ngày hẹn: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
                Text('Giờ hẹn: $selectedTime'),
                SizedBox(height: 8),
                Text('Mô tả: ${_descriptionController.text}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng popup khi nhấn hủy
              },
            ),
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng popup sau khi nhấn OK
                _showSuccessSnackBar(context); // Hiển thị thông báo thành công
              },
            ),
          ],
        );
      },
    );
  }

  // Hiển thị thông báo "Đặt lịch thành công"
  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đặt lịch thành công!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final timeslots = context.watch<ClinicProvider>().listtime;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_left),
                      onPressed: () {
                        setState(() {
                          if (selectedDate.month == 1) {
                            selectedDate = DateTime(
                              selectedDate.year - 1,
                              12,
                              selectedDate.day,
                            );
                          } else {
                            selectedDate = DateTime(
                              selectedDate.year,
                              selectedDate.month - 1,
                              selectedDate.day,
                            );
                          }
                          daysInMonth = _generateDaysInMonth(selectedDate);
                        });
                      },
                    ),
                    Text(
                      DateFormat('MMMM, yyyy').format(selectedDate),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_right),
                      onPressed: () {
                        setState(() {
                          if (selectedDate.month == 12) {
                            selectedDate = DateTime(
                              selectedDate.year + 1,
                              1,
                              selectedDate.day,
                            );
                          } else {
                            selectedDate = DateTime(
                              selectedDate.year,
                              selectedDate.month + 1,
                              selectedDate.day,
                            );
                          }
                          daysInMonth = _generateDaysInMonth(selectedDate);
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppTheme.defaultMargin),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: daysInMonth.map((date) {
                    return buildDateButton(
                      DateFormat('d').format(date),
                      DateFormat('E').format(date).toUpperCase(),
                      date,
                      isSelected: selectedDate.day == date.day,
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: AppTheme.defaultMargin),
              Text(
                'Thời gian có sẵn',
                style: AppTheme.theme.textTheme.displayMedium,
              ),
              SizedBox(height: AppTheme.mediumSpacing),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: timeslots.map((timeslot) {
                  final startAt = DateFormat('hh:mm a').format(DateFormat("HH:mm:ss").parse(timeslot.startAt));
                  return buildTimeButton(startAt);
                }).toList(),
              ),
              SizedBox(height: 16),
              Text(
                'Thông tin bác sĩ:',
                style: AppTheme.theme.textTheme.displayMedium,
              ),
              SizedBox(height: AppTheme.mediumSpacing),
              Text('Tên bác sĩ: ${widget.doctor.username}', style: TextStyle(fontSize: 16)),
              Text('Achievements: ${widget.doctor.achievements}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text(
                'Thông tin bệnh nhân:',
                style: AppTheme.theme.textTheme.displayMedium,
              ),
              SizedBox(height: AppTheme.mediumSpacing),
              user == null
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Họ tên: ${user!.fullName}', style: TextStyle(fontSize: 16)),
                  Text('Số điện thoại: ${user!.phone}', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Mô tả triệu chứng:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập mô tả triệu chứng...',
                ),
              ),
              SizedBox(height: AppTheme.largeSpacing),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: AppTheme.elevatedButtonStyle,
                  onPressed: () {
                    _showConfirmationDialog(context);
                  },
                  child: Text('Đặt lịch khám'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildDateButton(String day, String weekDay, DateTime date,
      {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = date; // Cập nhật ngày được chọn
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade400,
          ),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              weekDay,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTimeButton(String time) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = time; // Cập nhật giờ được chọn
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selectedTime == time ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedTime == time ? AppTheme.primaryColor : Colors.grey.shade400,
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            fontSize: 16,
            color: selectedTime == time ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
