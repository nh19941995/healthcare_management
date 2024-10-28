import 'dart:convert';
import 'package:healthcare_management_app/models/Clinic.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const clinicsUrl = "http://localhost:8080/api/clinics";

class ClinicApi {
  // Phương thức để lấy username từ SharedPreferences
  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // Phương thức để lấy URL clinics của bác sĩ
  Future<String> getClinicsUrlForDoctor() async {
    final username = await getUsername();
    if (username != null) {
      print(username);
      return "http://localhost:8080/api/clinics/$username";
    } else {
      throw Exception('Username not found');
    }
  }

  Future<List<Clinic>> getAllClinic() async {
    try {
      final response = await http.get(Uri.parse(clinicsUrl));

      if (response.statusCode == 200) {
        // Kiểm tra mã hóa
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('charset=utf-8')) {
          // Dữ liệu đã được mã hóa đúng
          final decodeResponse = jsonDecode(response.body) as List;
          return decodeResponse.map((clinicJson) => Clinic.fromJson(clinicJson)).toList();
        } else {
          // Chuyển đổi sang UTF-8 nếu không phải UTF-8
          final responseBody = utf8.decode(response.bodyBytes);
          final decodeResponse = jsonDecode(responseBody) as List;
          return decodeResponse.map((clinicJson) => Clinic.fromJson(clinicJson)).toList();
        }
      } else {
        throw Exception('Failed to load clinics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching clinics: $e');
    }
  }

  // Phương thức để lấy clinics của bác sĩ
  Future<List<Clinic>> getClinicsForDoctor() async {
    final doctorUrl = await getClinicsUrlForDoctor();
    try {
      final response = await http.get(Uri.parse(doctorUrl));

      if (response.statusCode == 200) {
        final decodeResponse = jsonDecode(response.body) as List;
        return decodeResponse.map((clinicJson) => Clinic.fromJson(clinicJson)).toList();
      } else {
        throw Exception('Failed to load clinics for doctor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching clinics for doctor: $e');
    }
  }
}
