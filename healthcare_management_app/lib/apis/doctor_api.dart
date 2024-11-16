import 'package:healthcare_management_app/dto/Doctor_dto.dart';
import 'package:healthcare_management_app/dto/update_doctor_dto.dart';
import '../dto/Appointment_dto.dart';
import '../models/Doctor_detail.dart';
import '../models/GetDoctorProfile.dart';
import '../screens/comons/TokenManager.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const baseURL = "http://localhost:8080/api/doctors";

class DoctorApi {

  Future<List<DoctorDTO>> getAllDoctors() async {
    final String? username = TokenManager().getUserSub();
    final String? token = TokenManager().getToken(); // Lấy token từ TokenManager


    final response = await http.get(
      Uri.parse(baseURL),
      // headers: {
      //   'Authorization': 'Bearer $token', // Thêm token vào header
      // },
    );

    if (response.statusCode == 200) {
      // Kiểm tra mã hóa
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('charset=utf-8')) {
        // Dữ liệu đã được mã hóa đúng
        final decodeResponse = jsonDecode(response.body) as List;
        return decodeResponse.map((doctorJson) => DoctorDTO.fromJson(doctorJson)).toList();
      } else {
        // Chuyển đổi sang UTF-8 nếu không phải UTF-8
        final responseBody = utf8.decode(response.bodyBytes);
        final decodeResponse = jsonDecode(responseBody);

        final doctorData = decodeResponse['content'] as List;
        return doctorData.map((doctorJson) => DoctorDTO.fromJson(doctorJson)).toList();
      }
    } else {
      throw Exception('Failed to load doctors: ${response.statusCode}');
    }

  }

  Future<GetDoctorProfile> getDoctorByUserName() async {
    final String? username = TokenManager().getUserSub();
    final String? token = TokenManager().getToken(); // Lấy token từ TokenManager

    print('Username: $username');
    print('Token: $token'); // In token ra để kiểm tra nếu cần

    final String urlGetUser = 'http://localhost:8080/api/doctors/$username';

    final response = await http.get(
      Uri.parse(urlGetUser),
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
      },
    );

    if (response.statusCode == 200) {
      // Chuyển đổi phản hồi sang UTF-8
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print('Data from API: $data'); // In ra dữ liệu từ API để kiểm tra

      return GetDoctorProfile.fromJson(data);
    } else {
      print('Failed to load doctor data. Status code: ${response.statusCode}');
      throw Exception('Failed to load doctor data');
    }
  }

  Future<GetDoctorProfile> getDoctorByUserNameForAppoiment(String username) async {
    //print('Username: $username');

    final String urlGetUser = 'http://localhost:8080/api/doctors/$username';

    final response = await http.get(
      Uri.parse(urlGetUser)
    );

    if (response.statusCode == 200) {
      // Chuyển đổi phản hồi sang UTF-8
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return GetDoctorProfile.fromJson(data);
    } else {
      print('Failed to load doctor data. Status code: ${response.statusCode}');
      throw Exception('Failed to load doctor data');
    }
  }

  // Phương thức để cập nhật thông tin người dùng
  Future<UpdateDoctorDto> updateDoctor(UpdateDoctorDto updateDoctorDto) async {
    final String? username = TokenManager().getUserSub();
    final String? token = TokenManager().getToken(); // Lấy token từ TokenManager

    final response = await http.put(
      Uri.parse("http://localhost:8080/api/doctors/${username}"), // Địa chỉ API để cập nhật người dùng
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
        'Content-Type': 'application/json', // Định dạng nội dung
      },
      body: jsonEncode(updateDoctorDto.toJson()), // Chuyển đổi UserDTO thành JSON
    );

    if (response.statusCode == 200) {
      return UpdateDoctorDto.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to update user. Status code: ${response.statusCode}');
      throw Exception('Failed to update user');
    }
  }

  Future<List<AppointmentDTO>> getAllAppointment() async {

    try {
      final String? username = TokenManager().getUserSub();
      final String? token = TokenManager().getToken(); // Lấy token từ TokenManager

      final gerAppointEachDoctorUrl = 'http://localhost:8080/api/doctors/appointments/$username/CONFIRMED';

      print('Username: $username');
      print('Token: $token'); // In token ra để kiểm tra nếu cần

      final response = await http.get(
        Uri.parse(gerAppointEachDoctorUrl),
      );

      if (response.statusCode == 200) {
        // Kiểm tra mã hóa
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('charset=utf-8')) {
          // Dữ liệu đã được mã hóa đúng
          final decodeResponse = jsonDecode(response.body) as List;
          return decodeResponse.map((appointmentJson) => AppointmentDTO.fromJson(appointmentJson)).toList();
        } else {
          // Chuyển đổi sang UTF-8 nếu không phải UTF-8
          final responseBody = utf8.decode(response.bodyBytes);
          final decodeResponse = jsonDecode(responseBody);

          final appointmentData = decodeResponse['content'] as List;
          return appointmentData.map((appointmentJson) => AppointmentDTO.fromJson(appointmentJson)).toList();
        }
      } else {
        throw Exception('Failed to load appointment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching appointment: $e');
    }
  }
}