import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/Appointment_dto.dart';
import 'package:healthcare_management_app/dto/Doctor_dto.dart';
import 'package:healthcare_management_app/models/Doctor_detail.dart';
import 'package:healthcare_management_app/providers/Appointment_provider.dart';
import 'package:healthcare_management_app/providers/Doctor_provider.dart';
import 'package:healthcare_management_app/providers/Medications_provider.dart';
import 'package:healthcare_management_app/screens/comons/customBottomNavBar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/GetDoctorProfile.dart';
import '../comons/show_vertical_menu.dart';
import 'Home_customer.dart';

class AppointmentHistoryApp extends StatefulWidget {
  const AppointmentHistoryApp({super.key});

  @override
  _AppointmentHistoryAppState createState() => _AppointmentHistoryAppState();
}

class _AppointmentHistoryAppState extends State<AppointmentHistoryApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().getAllAppointmentByUserName();
    });
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

  @override
  Widget build(BuildContext context) {
    final listAppointment =
        context.watch<AppointmentProvider>().listAppointment;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
      ),
      body: ListView.builder(
        itemCount: listAppointment.length,
        itemBuilder: (context, index) {
          final appointment = listAppointment[index];

          return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  // Điều hướng sang trang chi tiết
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AppointmentDetail(appointmentDTO: appointment),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(
                            "lib/assets/doctor_icon.png"), // Đường dẫn tới ảnh
                        backgroundColor:
                            Colors.transparent, // Không cần màu nền
                      ),
                      const SizedBox(width: 16),

                      // Thông tin chính
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tên bác sĩ và ngày khám
                            Text(
                              "${appointment.doctor.fullName ?? ''}",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.blue),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  "${appointment.appointmentDate != null ? DateFormat('yyyy-MM-dd').format(appointment.appointmentDate!) : 'Không xác định'} - ${appointment.timeSlot.startAt ?? 'Không xác định'}",
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  softWrap: true, // Văn bản tự động xuống dòng
                                  overflow: TextOverflow.visible, // Hiển thị toàn bộ nội dung
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),
                            // Địa điểm khám bệnh
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  appointment.doctor.medicalTraining ??
                                      'Không xác định',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          // Thêm logic xử lý sự kiện ở đây
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          backgroundColor: getStatusColor(appointment.status),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          appointment.status,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}

class AppointmentDetail extends StatefulWidget {
  final AppointmentDTO appointmentDTO;

  const AppointmentDetail({super.key, required this.appointmentDTO});

  @override
  _AppointmentDetailState createState() => _AppointmentDetailState();
}

class _AppointmentDetailState extends State<AppointmentDetail> {
  late Future<GetDoctorProfile?> _doctorFuture;

  @override
  void initState() {
    super.initState();
    _doctorFuture = _loadDoctor();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<MedicationsProvider>()
          .getPrescriptionByAppointmentIdProvider(widget.appointmentDTO.id);
    });
  }

  Future<GetDoctorProfile?> _loadDoctor() async {
    return context.read<DoctorProvider>().doctor_pro_appointment;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail appointment"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại danh sách lịch sử khám bệnh
          },
        ),
      ),
      body: FutureBuilder<GetDoctorProfile?>(
        future: _doctorFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return Consumer<MedicationsProvider>(
            builder: (context, medicationsProvider, _) {
              final prescription = medicationsProvider.prescriptionRequest;

              return SingleChildScrollView(
                // Thêm SingleChildScrollView ở đây
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: // Bọc toàn bộ `Column` trong một `SingleChildScrollView` để tránh lỗi kích thước không xác định
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0), // Thêm khoảng cách xung quanh
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thông tin bác sĩ
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều dọc
                          children: [
                            // Ảnh bác sĩ nằm bên trái
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage("lib/assets/doctor_icon.png"),
                              backgroundColor: Colors.transparent,
                            ),
                            const SizedBox(width: 16), // Khoảng cách giữa ảnh và văn bản

                            // Văn bản hiển thị thông tin bác sĩ
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho văn bản
                                children: [
                                  Text(
                                    "${widget.appointmentDTO.doctor.fullName ?? ''}",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.blue),
                                  ),
                                  const SizedBox(height: 4),
                                  // Thời gian khám
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${widget.appointmentDTO.appointmentDate != null ? DateFormat('yyyy-MM-dd').format(widget.appointmentDTO.appointmentDate!) : 'Không xác định'} - ${widget.appointmentDTO.timeSlot.startAt ?? 'Không xác định'}",
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                        softWrap: true, // Văn bản tự động xuống dòng
                                        overflow: TextOverflow.visible, // Hiển thị toàn bộ nội dung
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(height: 4),
                                  // // Thời gian khám
                                  // Row(
                                  //   children: [
                                  //     Icon(Icons.access_time, size: 16, color: Colors.grey),
                                  //     const SizedBox(width: 4),
                                  //     Text(
                                  //       "${widget.appointmentDTO.timeSlot.startAt ?? 'Không xác định'}",
                                  //       style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 4),
                                  // Địa điểm khám bệnh
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.appointmentDTO.doctor.medicalTraining ?? 'Không xác định',
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Thêm logic xử lý sự kiện ở đây
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                backgroundColor: getStatusColor(widget.appointmentDTO.status),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                widget.appointmentDTO.status,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Prescription
                        if (prescription != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage("lib/assets/checklist.png"),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${prescription.medicalDiagnosis}",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.blue),
                                  ),
                                ],
                              ),

                              // const Text(
                              //   "Prescription:",
                              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              // ),
                              // const SizedBox(height: 10),
                              // Text(
                              //   "Diagnosis: ${prescription.medicalDiagnosis}",
                              //   style: const TextStyle(fontSize: 16),
                              // ),
                              const SizedBox(height: 20),
                              const Text(
                                "List of medications:",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: prescription.medications.length,
                                itemBuilder: (context, index) {
                                  final med = prescription.medications[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${med.medication?.name ?? ''}(${med.totalDosage}) - ${med.dosageInstructions}",
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.blue),
                                            softWrap: true, // Văn bản tự động xuống dòng
                                            overflow: TextOverflow.visible, // Hiển thị toàn bộ nội dung
                                          ),
                                          // const SizedBox(height: 5),
                                          // Text(
                                          //   "Total quantity: ${med.totalDosage}",
                                          //   style: const TextStyle(fontSize: 14),
                                          // ),
                                          const SizedBox(height: 5),
                                          // Text(
                                          //   "Dosage: ${med.dosageInstructions}",
                                          //   style: const TextStyle(fontSize: 14),
                                          // ),
                                          // const SizedBox(height: 5),
                                          Text(
                                            "Note: ${med.note}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            softWrap: true, // Văn bản tự động xuống dòng
                                            overflow: TextOverflow.visible, // Hiển thị toàn bộ nội dung
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        else
                          const Text(
                            "No prescription",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                      ],
                    ),
                  )


                ),
              );
            },
          );
        },
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
}
