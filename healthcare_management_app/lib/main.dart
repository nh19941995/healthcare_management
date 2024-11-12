import 'package:flutter/material.dart';
import 'package:healthcare_management_app/apis/Qa_api.dart';
import 'package:healthcare_management_app/apis/appointment_api.dart';
import 'package:healthcare_management_app/apis/doctor_api.dart';
import 'package:healthcare_management_app/providers/Appointment_provider.dart';
import 'package:healthcare_management_app/providers/Clinic_Provider.dart';
import 'package:healthcare_management_app/providers/Doctor_provider.dart';
import 'package:healthcare_management_app/providers/Qa_provider.dart';
import 'package:healthcare_management_app/providers/auth_provider.dart';
import 'package:healthcare_management_app/providers/user_provider.dart';
import 'package:healthcare_management_app/apis/user_api.dart';
import 'package:healthcare_management_app/apis/auth.dart';
import 'package:healthcare_management_app/apis/clinics_api.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';
import 'package:healthcare_management_app/screens/customers/Appointment_Booking.dart';
import 'package:healthcare_management_app/screens/comons/splash.dart';

void main() {
  // Khởi tạo danh sách các API
  final List apis = [
    UserApi(),
    ClinicApi(),
    Auth(), // Thêm Auth API vào danh sách
    DoctorApi(),
    AppointmentApi(),
    QaApi()
  ];

  runApp(
    MultiProvider(
      providers: [
        // Khởi tạo UserProvider với danh sách API
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            userApi: apis.firstWhere((api) => api is UserApi) as UserApi,
            authApi: apis.firstWhere((api) => api is Auth) as Auth, // Cung cấp Auth API
          ),
        ),
        // Khởi tạo ClinicProvider với API cụ thể
        ChangeNotifierProvider(
          create: (_) => ClinicProvider(
            clinicApi: apis.firstWhere((api) => api is ClinicApi) as ClinicApi,
          ),
        ),
        // Thêm AuthProvider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authApi: apis.firstWhere((api) => api is Auth) as Auth,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DoctorProvider(
            doctorApi: apis.firstWhere((api) => api is DoctorApi) as DoctorApi,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AppointmentProvider(
            appointmentApi: apis.firstWhere((api) => api is AppointmentApi) as AppointmentApi,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => QaProvider(
            qaApi: apis.firstWhere((api) => api is QaApi) as QaApi,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare Management',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),  // Màn hình SplashScreen khi khởi động
    );
  }
}


