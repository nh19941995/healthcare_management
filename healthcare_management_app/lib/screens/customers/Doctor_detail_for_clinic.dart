import 'package:flutter/material.dart';
import 'package:healthcare_management_app/dto/Doctor_dto.dart';
import 'package:healthcare_management_app/models/Doctor_detail.dart';
import 'package:healthcare_management_app/providers/Doctor_provider.dart';
import 'package:healthcare_management_app/screens/customers/Appointment_Booking.dart';
import 'package:provider/provider.dart';
import '../../models/GetDoctorProfile.dart';
import '../comons/customBottomNavBar.dart';
import '../comons/show_vertical_menu.dart';
import '../comons/theme.dart';
import 'Appointment_Booking_clinic.dart';
import 'Home_customer.dart';

class DoctorDetailForClinicScreen extends StatefulWidget {
  final GetDoctorProfile doctor;
  final clinicName;

  DoctorDetailForClinicScreen({required this.doctor, required this.clinicName});

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailForClinicScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProvider>().getDoctorByUserNameForAppointment(widget.doctor.username!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = context.watch<DoctorProvider>();
    final GetDoctorProfile? doctorDetail = doctorProvider.doctor_pro_appointment;

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
                'Specialties ${doctorDetail.specialization?.name ?? 'N/A'}',
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
                      'Doctor information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.doctor.medicalTraining ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Clinic: ${widget.clinicName ?? ''}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.doctor.achievements ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      doctorDetail.specialization?.description ?? '',
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
                        builder: (context) => AppointmentBookingForClinicScreen(
                          doctor: widget.doctor, clinicName :widget.clinicName
                        ),
                      ),
                    );
                  },
                  child: Text('Choose time'),
                ),
              ),
            ],
          ),
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
}