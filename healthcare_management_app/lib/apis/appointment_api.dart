import 'dart:convert';

import '../dto/Api_appointment_dto.dart';
import '../dto/Appointment_dto.dart';
import '../screens/comons/TokenManager.dart';
import 'package:http/http.dart' as http;

const getAllUrl = "http://localhost:8080/admin/appointments/ALL?page=0&size=1000000";
class AppointmentApi {

  Future<void> createAppointment(
      ApiAppointmentDTO apiAppointmentDTO,
      ) async {
    final String? token = TokenManager().getToken();
    // Tạo URL endpoint
    final url = Uri.parse(
        'http://localhost:8080/api/appointments/${apiAppointmentDTO.patientUsername}/'
            '${apiAppointmentDTO.doctorUsername}/${apiAppointmentDTO.timeSlotId}/${apiAppointmentDTO.appointmentDate}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Thêm token vào header
        },
      );
      if (response.statusCode == 200) {
        // Thành công, bạn có thể xử lý logic sau khi cập nhật vai trò tại đây
        print("Appointment created successfully");
      } else {
        // Xử lý lỗi nếu có vấn đề với yêu cầu
        print("Failed to appointment created: ${response.body}");
      }
    } catch (error) {
      // Xử lý lỗi kết nối hoặc ngoại lệ khác
      print("An error occurred: $error");
    }
  }

  Future<List<AppointmentDTO>> getAllAppointmentByUserName() async {

    try {
      final String? username = TokenManager().getUserSub();
      final String? token = TokenManager().getToken(); // Lấy token từ TokenManager

      final historyUrl = 'http://localhost:8080/api/patients/appointments/$username';
      print('Username: $username');
      print('Token: $token'); // In token ra để kiểm tra nếu cần

      final response = await http.get(
        Uri.parse(historyUrl),
        headers: {
          'Authorization': 'Bearer $token', // Thêm token vào header
        },
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

  Future<List<AppointmentDTO>> getAllAppointment() async {

    try {
      final String? username = TokenManager().getUserSub();
      final String? token = TokenManager().getToken(); // Lấy token từ TokenManager

      print('Username: $username');
      print('Token: $token'); // In token ra để kiểm tra nếu cần

      final response = await http.get(
        Uri.parse(getAllUrl),
        headers: {
          'Authorization': 'Bearer $token', // Thêm token vào header
        },
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