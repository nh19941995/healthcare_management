import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/Appointment_dto.dart';
import 'package:healthcare_management_app/dto/Doctor_dto.dart';
import 'package:healthcare_management_app/models/Doctor_detail.dart';
import 'package:healthcare_management_app/providers/Appointment_provider.dart';
import 'package:healthcare_management_app/providers/Doctor_provider.dart';
import 'package:provider/provider.dart';

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
                "Doctor : ${appointment.doctor.fullName ?? 'Không xác định'}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Trạng thái: ${appointment.status ?? 'Không xác định'}"),
                  Text("Ngày khám: ${appointment.createdAt ?? 'Không xác định'}"),
                  Text("Địa điểm: ${appointment.doctor.medicalTraining ?? 'Không xác định'}"),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
                // Chuyển đổi hàm onTap trong AppointmentHistoryApp
                onTap: () async {
                  // Gọi provider để lấy thông tin bác sĩ dựa trên `doctor.username`
                  await context.read<DoctorProvider>().getDoctorByUserNameForAppointment(appointment.doctor.username!);

                  // Chuyển sang màn hình chi tiết
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentDetail(appointmentDTO: appointment),
                    ),
                  );
                }

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
  }

  Future<DoctorDetail?> _loadDoctor() async {
    return context.read<DoctorProvider>().doctor_pro_appointment;
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
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Không tìm thấy thông tin bác sĩ"));
          }

          final doctor = snapshot.data;

          return Padding(
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
                Text(
                  "Trạng thái: ${widget.appointmentDTO.status ?? 'Không xác định'}",
                  style: const TextStyle(fontSize: 16),
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
              ],
            ),
          );
        },
      ),
    );
  }
}

