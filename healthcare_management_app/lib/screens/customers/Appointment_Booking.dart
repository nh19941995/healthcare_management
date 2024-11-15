import 'package:flutter/material.dart';
import 'package:healthcare_management_app/screens/customers/Home_customer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../dto/Api_appointment_dto.dart';
import '../../dto/Doctor_dto.dart';
import '../../dto/user_dto.dart';
import '../../models/Time_slot.dart';
import '../../providers/Appointment_provider.dart';
import '../../providers/Clinic_Provider.dart';
import '../../providers/user_provider.dart';
import '../comons/TokenManager.dart';
import '../comons/customBottomNavBar.dart';
import '../comons/show_vertical_menu.dart';
import '../comons/theme.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final DoctorDTO doctor;

  AppointmentBookingScreen({required this.doctor});

  @override
  _AppointmentBookingScreenState createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  late UserProvider userProvider;
  UserDTO? user;
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  int? selectedTimeId; // Lưu ID của timeslot đã chọn
  TextEditingController _descriptionController = TextEditingController();
  List<DateTime> daysInMonth = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);

    // Fetch user khi initState
    userProvider.fetchUser().then((_) {
      setState(() {
        user = userProvider.user;
      });
    });

    daysInMonth = _generateDaysInMonth(selectedDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClinicProvider>().getAllTimeSlot();

      // Cuộn đến ngày hôm nay khi giao diện hiển thị lần đầu
      int todayIndex = daysInMonth.indexWhere((day) => _isSameDay(day, DateTime.now()));
      if (todayIndex != -1) {
        _scrollController.jumpTo(todayIndex * 60.0); // Điều chỉnh khoảng cách này theo khoảng cách giữa các ngày
      }
    });
  }

  // Tạo danh sách ngày trong tháng
  List<DateTime> _generateDaysInMonth(DateTime date) {
    int daysCount = DateTime(date.year, date.month + 1, 0).day;
    return List.generate(daysCount, (index) => DateTime(date.year, date.month, index + 1));
  }

  // Kiểm tra hai ngày có giống nhau không
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  // Hiển thị dialog xác nhận
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xác nhận phiếu đặt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bác sĩ: ${widget.doctor.fullName}'),
            Text('Medical Training: ${widget.doctor.medicalTraining}'),
            SizedBox(height: 8),
            Text('Thông tin khách hàng'),
            Text('Name: ${user?.fullName}'),
            Text('Phone: ${user?.phone}'),
            SizedBox(height: 8),
            Text('Ngày hẹn: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
            Text('Giờ hẹn: $selectedTime'),
            SizedBox(height: 8),
            Text('Mô tả: ${_descriptionController.text}'),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              _createAppointment();
            },
          ),
        ],
      ),
    );
  }

  // Tạo cuộc hẹn
  void _createAppointment() {
    final apiAppointmentDTO = ApiAppointmentDTO(
      patientUsername: user?.username ?? '',
      doctorUsername: widget.doctor.username!,
      timeSlotId: selectedTimeId!,
      appointmentDate: DateFormat('yyyy-MM-dd').format(selectedDate),
    );

    context.read<AppointmentProvider>().createAppointmentProvider(apiAppointmentDTO);
    _showSuccessSnackBar(context);
  }

  // Hiển thị thông báo thành công
  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đặt lịch thành công!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Hiển thị lỗi nếu ngày đã chọn trước ngày hôm nay
  void _showDateErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Không thể chọn ngày trước hôm nay'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeslots = context.watch<ClinicProvider>().listtime;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(),
            SizedBox(height: AppTheme.defaultMargin),
            _buildTimeSlots(timeslots),
            SizedBox(height: AppTheme.defaultMargin),
            _buildDoctorInfo(),
            _buildPatientInfo(),
            //_buildDescriptionField(),
            SizedBox(height: AppTheme.largeSpacing),
            _buildBookingButton(),
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

  // Component: Chọn ngày
  Widget _buildDateSelector() => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              setState(() {
                selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, selectedDate.day);
                daysInMonth = _generateDaysInMonth(selectedDate);
              });
            },
          ),
          Text(
            DateFormat('MMMM, yyyy').format(selectedDate),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              setState(() {
                selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);
                daysInMonth = _generateDaysInMonth(selectedDate);
              });
            },
          ),
        ],
      ),
      SizedBox(height: 8),
      SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: daysInMonth.map((day) {
            bool isToday = _isSameDay(day, DateTime.now());
            bool isSelected = selectedDate == day;
            return GestureDetector(
              onTap: () {
                if (day.isBefore(DateTime.now())) {
                  _showDateErrorSnackBar(context);
                } else {
                  setState(() {
                    selectedDate = day;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : (isToday ? Colors.green : Colors.grey[300]),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  DateFormat('dd').format(day),
                  style: TextStyle(
                    color: isSelected || isToday ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );

  // Component: Hiển thị các khung giờ
  Widget _buildTimeSlots(List<Timeslots> timeslots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn khung giờ:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: timeslots.map((slot) {
            bool isSelected = selectedTimeId == slot.id;
            return ChoiceChip(
              label: Text(slot.startAt),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedTime = slot.startAt;
                  selectedTimeId = slot.id;
                });
              },
              selectedColor: Colors.blue,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
            );
          }).toList(),
        ),
      ],
    );
  }

// Component: Thông tin bác sĩ
  Widget _buildDoctorInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin bác sĩ:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Bác sĩ: ${widget.doctor.fullName}'),
        Text('Medical Training: ${widget.doctor.medicalTraining}'),
      ],
    );
  }

// Component: Thông tin bệnh nhân
  Widget _buildPatientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin khách hàng:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Name: ${user?.fullName ?? ''}'),
        Text('Phone: ${user?.phone ?? ''}'),
      ],
    );
  }

// // Component: Trường nhập mô tả cuộc hẹn
//   Widget _buildDescriptionField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Mô tả (Tùy chọn):',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8),
//         TextField(
//           controller: _descriptionController,
//           maxLines: 4,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             hintText: 'Nhập mô tả chi tiết nếu có',
//           ),
//         ),
//       ],
//     );
//   }

// Component: Nút đặt lịch
  Widget _buildBookingButton() {
    return Container(
      width: double.infinity, // Đảm bảo chiều rộng của button chiếm toàn bộ
      child: ElevatedButton(
        onPressed: selectedTimeId == null
            ? null
            : () {
          _showConfirmationDialog(context);
        },
        child: Text('Đặt lịch'),
        style: AppTheme.elevatedButtonStyle,
      ),
    );
  }


}
