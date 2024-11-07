import 'package:flutter/material.dart';
import 'package:healthcare_management_app/providers/Clinic_Provider.dart';

import 'package:healthcare_management_app/screens/comons/theme.dart';
import 'package:healthcare_management_app/screens/customers/Appointment_Booking.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_management_app/screens/comons/splash.dart';
import 'package:healthcare_management_app/providers/user_provider.dart';
import 'package:healthcare_management_app/apis/user_api.dart';
import 'apis/auth.dart';
import 'apis/clinics_api.dart';

void main() {
  // Khởi tạo danh sách các API
  final List apis = [
    UserApi(),
    ClinicApi(),
    Auth(), // Thêm Auth API vào danh sách
    // Các API khác nếu có
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
      home: SplashScreen(),
      //home: MedicalExaminationScreen(),
    );
  }
}