import 'package:flutter/material.dart';

class AppTheme {
  // Màu sắc
  static const Color primaryColor = Color(0xFF6F35A5); // Màu chính
  static const Color secondaryColor = Color(0xFFF1E6FF); // Màu phụ
  static const Color errorColor = Color(0xFFD32F2F); // Màu lỗi
  static const Color backgroundColor = Color(0xFFFFFFFF); // Màu nền
  static const Color textColor = Color(0xFF000000); // Màu chữ chính
  static const Color additionalColor = Color(0xFF7B6BA8); // mau chu input
  static const Color backgroundTextfieldColor = Color(0xFFE5E5E5); // Màu xám nhạt


  // Padding và Margin
  static const double defaultPadding = 20.0;
  static const double Padding8 = 8.0;
  static const double defaultMargin = 16.0;

  static const double smallSpacing = 5.0;
  static const double mediumSpacing = 10.0;
  static const double largeSpacing = 20.0;
  static const double xLargeSpacing = 40.0;

  // Thêm kiểu header TextStyle
  static const TextStyle headerStyle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  // Button Styles
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor, // Nền nút
    padding: EdgeInsets.symmetric(vertical: 20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    foregroundColor: secondaryColor, // Màu chữ trên nút
    textStyle: TextStyle(
      fontSize: 18.0,
    ),
  );

  static final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    side: BorderSide(color: primaryColor, width: 2), // Viền của nút
    padding: EdgeInsets.symmetric(vertical: 20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    foregroundColor: primaryColor, // Màu chữ của nút
    textStyle: TextStyle(
      fontSize: 18.0,
    ),
  );

  // Theme chính
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: backgroundColor,
        onPrimary: Colors.white, // Màu chữ trên màu chính
        onSecondary: Colors.black, // Màu chữ trên màu phụ
        onError: Colors.white, // Màu chữ trên màu lỗi
        onBackground: textColor, // Màu chữ trên nền
      ),
      textTheme: TextTheme(
        headlineLarge: headerStyle,
        displayLarge: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        displayMedium: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          color: textColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        // Đường viền khi không được tập trung
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: backgroundTextfieldColor, // Màu nhạt hơn cho border
            width: 2.0, // Độ dày của đường viền
          ),
        ),
        // Đường viền khi trường có thể nhập
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: backgroundTextfieldColor, // Màu nhạt cho border khi trường có thể nhập
            width: 2.0, // Độ dày của đường viền
          ),
        ),
        // Đường viền khi trường đang được chọn
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor, // Giữ màu chính cho border khi tập trung
            width: 2.0, // Độ dày của đường viền khi được tập trung
          ),
        ),
        labelStyle: TextStyle(
          color: additionalColor, // Màu chữ nhãn
          fontSize: 16,
        ),
        errorStyle: TextStyle(
          color: Colors.red, // Màu chữ cho thông báo lỗi
          fontSize: 14,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: elevatedButtonStyle,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: outlinedButtonStyle,
      ),
      // Thêm vào ThemeData trong AppTheme
      cardTheme: CardTheme(
        color: AppTheme.secondaryColor, // Màu nền của Card
        elevation: 4, // Độ cao của bóng đổ
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Bo góc cho Card
          side: BorderSide(color: backgroundTextfieldColor, width: 1), // Viền cho Card
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Thêm nhiều thiết lập khác nếu cần
    );
  }
}
