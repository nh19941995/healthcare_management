import 'package:flutter/material.dart';
import 'package:healthcare_management_app/screens/comons/theme.dart';

import 'package:provider/provider.dart';
import 'package:healthcare_management_app/screens/comons/splash.dart'; // Import màn hình Splash
import 'package:healthcare_management_app/providers/user_provider.dart'; // Import UserProvider
import 'package:healthcare_management_app/apis/user_api.dart'; // Import UserApi

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Khởi tạo UserProvider với một instance của UserApi
        ChangeNotifierProvider(
          create: (_) => UserProvider(userApi: UserApi()),
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
      debugShowCheckedModeBanner: false, // Tắt banner debug
      home: SplashScreen(), // Gọi SplashScreen từ splash.dart


    );
  }
}