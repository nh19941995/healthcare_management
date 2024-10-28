import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/Doctor_dto.dart';
import 'package:intl/intl.dart';

import '../comons/TokenManager.dart';
import '../comons/theme.dart'; // Import intl để sử dụng DateFormat

class AppointmentBookingScreen extends StatefulWidget {
  final DoctorDTO doctor;

  AppointmentBookingScreen({required this.doctor});

  @override
  _AppointmentBookingScreenState createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  TextEditingController _descriptionController = TextEditingController();
  List<DateTime> daysInMonth = [];
  late String username;

  @override
  void initState() {
    super.initState();
    daysInMonth = _generateDaysInMonth(selectedDate);
    username = TokenManager().getUserSub() ?? "Người dùng"; // Lấy giá trị sub
  }

  // Hàm tạo danh sách các ngày trong tháng
  List<DateTime> _generateDaysInMonth(DateTime date) {
    int daysCount = DateTime(date.year, date.month + 1, 0).day;
    return List.generate(daysCount, (index) => DateTime(date.year, date.month, index + 1));
  }

  // Hiển thị dialog xác nhận
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
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị tháng hiện tại và cho phép cuộn qua các tháng và năm
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
            // Chọn ngày từ các ngày trong tháng bằng thanh cuộn ngang
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
            // Thời gian có sẵn
            Text(
              'Thời gian có sẵn',
              style: AppTheme.theme.textTheme.displayMedium
            ),
            SizedBox(height: AppTheme.mediumSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTimeButton('09:00 AM'),
                buildTimeButton('10:30 AM'),
              ],
            ),
            SizedBox(height: AppTheme.smallSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTimeButton('01:30 PM'),
                buildTimeButton('03:30 PM'),
              ],
            ),
            SizedBox(height: 16),
            // Hiển thị thông tin bác sĩ
            Text(
              'Thông tin bác sĩ:',
                style: AppTheme.theme.textTheme.displayMedium
            ),
            SizedBox(height: AppTheme.mediumSpacing),
            Text('Tên bác sĩ: ${widget.doctor.username}', style: TextStyle(fontSize: 16)),
            Text('Achievements: ${widget.doctor.achievements}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            // Thông tin bệnh nhân
            Text(
              'Thông tin bệnh nhân:',
                style: AppTheme.theme.textTheme.displayMedium
            ),
            SizedBox(height: AppTheme.mediumSpacing),
            Text(
              'Họ tên: ${username}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            // Mô tả bệnh với TextArea
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

            // Nút đặt lịch khám
            SizedBox(height: AppTheme.largeSpacing),
            SizedBox(
              width: double.infinity, // Chiếm toàn bộ chiều rộng
              child: ElevatedButton(
                style: AppTheme.elevatedButtonStyle, // Sử dụng style từ AppTheme
                onPressed: () {
                  // Hiện popup thông tin hóa đơn
                  _showConfirmationDialog(context);
                },
                child: Text('Đặt lịch khám'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDateButton(String day, String weekDay, DateTime date,
      {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedDate = date;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(weekDay),
          ],
        ),
      ),
    );
  }

  Widget buildTimeButton(String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Thêm padding ngang
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedTime = time;
          });
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          backgroundColor: selectedTime == time ? Colors.blue : Colors.white,
          foregroundColor: selectedTime == time ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(time),
      ),
    );
  }
}
