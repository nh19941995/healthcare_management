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
        return Colors.green;
      case 'COMPLETED':
        return Colors.blue;
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
    final listAppointment = context.watch<AppointmentProvider>().listAppointment;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử khám bệnh'),
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
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                "Doctor : ${appointment.doctor.fullName ?? ''}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: getStatusColor(appointment.status),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Status : ${appointment.status}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Text("Ngày khám: ${appointment.createdAt ?? ''}"),
                  Text("Địa điểm: ${appointment.doctor.medicalTraining ?? ''}"),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentDetail(appointmentDTO: appointment),
                  ),
                );
              },
            ),
          );
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
  late Future<DoctorDetail?> _doctorFuture;

  @override
  void initState() {
    super.initState();
    _doctorFuture = _loadDoctor();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicationsProvider>().getPrescriptionByAppointmentIdProvider(widget.appointmentDTO.id);
    });
  }

  Future<DoctorDetail?> _loadDoctor() async {
    return context.read<DoctorProvider>().doctor_pro_appointment;
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      case 'CONFIRMED':
        return Colors.green;
      case 'COMPLETED':
        return Colors.blue;
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
        title: const Text("Chi tiết lịch sử khám bệnh"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại danh sách lịch sử khám bệnh
          },
        ),
      ),
      body: FutureBuilder<DoctorDetail?>(
        future: _doctorFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }

          final doctor = snapshot.data;

          return Consumer<MedicationsProvider>(
            builder: (context, medicationsProvider, _) {
              final prescription = medicationsProvider.prescriptionRequest;

              return SingleChildScrollView(  // Thêm SingleChildScrollView ở đây
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bác sĩ: ${widget.appointmentDTO.doctor.fullName ?? 'Không xác định'}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Chuyên khoa: ${doctor?.specialization?.name ?? 'Không xác định'}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: getStatusColor(widget.appointmentDTO.status),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Status : ${widget.appointmentDTO.status}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Ngày khám: ${widget.appointmentDTO.createdAt ?? 'Không xác định'}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Địa điểm: ${widget.appointmentDTO.doctor.medicalTraining ?? 'Không xác định'}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      prescription != null
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Đơn thuốc:",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Chuẩn đoán: ${prescription.medicalDiagnosis}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Danh sách thuốc:",
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
                                        "Tên thuốc: ${med.medication?.name ?? 'Không xác định'}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Tổng số lượng: ${med.totalDosage}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Liều dùng: ${med.dosageInstructions}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Ghi chú: ${med.note}",
                                        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                          : const Text(
                        "Không có đơn thuốc",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
}




