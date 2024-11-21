import 'package:flutter/material.dart';
import 'package:healthcare_management_app/screens/customers/Home_customer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../dto/Api_appointment_dto.dart';
import '../../dto/Doctor_dto.dart';
import '../../dto/user_dto.dart';
import '../../models/GetDoctorProfile.dart';
import '../../models/Time_slot.dart';
import '../../providers/Appointment_provider.dart';
import '../../providers/Clinic_Provider.dart';
import '../../providers/user_provider.dart';
import '../comons/TokenManager.dart';
import '../comons/customBottomNavBar.dart';
import '../comons/show_vertical_menu.dart';
import '../comons/theme.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final GetDoctorProfile doctor;

  AppointmentBookingScreen({required this.doctor});

  @override
  _AppointmentBookingScreenState createState() =>
      _AppointmentBookingScreenState();
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
      int todayIndex =
          daysInMonth.indexWhere((day) => _isSameDay(day, DateTime.now()));
      if (todayIndex != -1) {
        _scrollController.jumpTo(todayIndex *
            60.0); // Điều chỉnh khoảng cách này theo khoảng cách giữa các ngày
      }
    });
  }

  // Tạo danh sách ngày trong tháng
  List<DateTime> _generateDaysInMonth(DateTime date) {
    int daysCount = DateTime(date.year, date.month + 1, 0).day;
    return List.generate(
        daysCount, (index) => DateTime(date.year, date.month, index + 1));
  }

  // Kiểm tra hai ngày có giống nhau không
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Hiển thị dialog xác nhận
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(
                'Booking Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                // Đảm bảo nội dung cuộn được nếu quá dài
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person_outline, color: Colors.green),
                      title: Text('Doctor'),
                      subtitle: Text(widget.doctor.fullName ?? "N/A"),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_city, color: Colors.grey),
                      title: Text('Clinic'),
                      subtitle: Text(widget.doctor.clinic?.name ?? "N/A"),
                    ),
                    Text('Customer information'),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.blue),
                      title: Text('Patient'),
                      subtitle: Text(user?.fullName ?? "N/A"),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.red),
                      title: Text('Phone'),
                      subtitle:
                          Text(user?.phone ?? "N/A"), // Hiển thị số điện thoại
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.orange),
                      title: Text('Date'),
                      subtitle: Text(selectedDate.toString() ??
                          "N/A"), // Hiển thị ngày tạo
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time, color: Colors.purple),
                      title: Text('Timeslot'),
                      subtitle:
                          Text(selectedTime ?? "N/A"), // Hiển thị timeslot
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
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
            ));
  }

  // Tạo cuộc hẹn
  // Tạo cuộc hẹn
  Future<void> _createAppointment() async {
    final apiAppointmentDTO = ApiAppointmentDTO(
      patientUsername: user?.username ?? '',
      doctorUsername: widget.doctor.username!,
      timeSlotId: selectedTimeId!,
      appointmentDate: DateFormat('yyyy-MM-dd').format(selectedDate),
    );

    try {
      final result = await context.read<AppointmentProvider>().createAppointmentProvider(apiAppointmentDTO);

      if (result == "success") {
        _showSuccessSnackBar(context, "Appointment created successfully!");
      } else {
        _showErrorSnackBar(context, result); // Hiển thị lỗi từ server
      }
    } catch (error) {
      _showErrorSnackBar(context, "An error occurred: $error");
    }
  }

// Hiển thị thông báo thành công
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

// Hiển thị thông báo lỗi
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Create failed appointment booking already exists"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }


// // Hiển thị thông báo lỗi
//   void _showErrorSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }


  // Hiển thị lỗi nếu ngày đã chọn trước ngày hôm nay
  void _showDateErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cannot select dates before today'),
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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle other navigation
        },
        onSetupPressed: () {
          MenuUtils.showVerticalMenu(context); // Hiển thị menu khi nhấn Setup
        },
        onHomePressed: () {
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
                    selectedDate = DateTime(selectedDate.year,
                        selectedDate.month - 1, selectedDate.day);
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
                    selectedDate = DateTime(selectedDate.year,
                        selectedDate.month + 1, selectedDate.day);
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
                      color: isSelected
                          ? Colors.blue
                          : (isToday ? Colors.green : Colors.grey[300]),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      DateFormat('dd').format(day),
                      style: TextStyle(
                        color:
                            isSelected || isToday ? Colors.white : Colors.black,
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
          'Choose a time frame:',
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
              labelStyle:
                  TextStyle(color: isSelected ? Colors.white : Colors.black),
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
          'Doctor information:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Doctor: ${widget.doctor.fullName}'),
        Text('Clinic: ${widget.doctor.medicalTraining}'),
      ],
    );
  }

// Component: Thông tin bệnh nhân
  Widget _buildPatientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer information:',
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
        child: Text('Make an appointment'),
        style: AppTheme.elevatedButtonStyle,
      ),
    );
  }
}
