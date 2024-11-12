import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/Doctor_dto.dart';
import 'package:healthcare_management_app/models/Doctor_detail.dart';
import 'package:healthcare_management_app/providers/Doctor_provider.dart';
import 'package:healthcare_management_app/screens/customers/Appointment_Booking.dart';
import 'package:provider/provider.dart';
import '../comons/theme.dart';

class DoctorDetailScreen extends StatefulWidget {
  final DoctorDTO doctor;

  DoctorDetailScreen({required this.doctor});

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProvider>().getDoctorByUserNameForAppointment(widget.doctor.username);
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = context.watch<DoctorProvider>();
    final DoctorDetail? doctorDetail = doctorProvider.doctor_pro_appointment;

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin chi tiết'),
        centerTitle: true,
      ),
      body: doctorDetail == null
          ? Center(child: CircularProgressIndicator()) // Hiển thị spinner khi dữ liệu chưa load
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: widget.doctor.avatar != null
                    ? NetworkImage(widget.doctor.avatar!)
                    : AssetImage('lib/assets/Avatar.png') as ImageProvider,
                radius: 40, // Kích thước của avatar
              ),
              SizedBox(height: 16),
              Text(
                widget.doctor.fullName ?? '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Chuyên khoa ${doctorDetail.specialization?.name ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin bác sĩ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.doctor.medicalTraining ?? 'Không có thông tin',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.doctor.achievements ?? 'Không có thành tựu',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      doctorDetail.specialization?.description ?? 'Không có mô tả',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: AppTheme.elevatedButtonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentBookingScreen(
                          doctor: widget.doctor,
                        ),
                      ),
                    );
                  },
                  child: Text('Chọn thời gian'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
