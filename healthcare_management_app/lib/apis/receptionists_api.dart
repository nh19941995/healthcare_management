import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Config.dart';
import '../dto/Appointment_dto.dart';
import '../screens/comons/TokenManager.dart';

final String apiUrl = Config.apiUrl;
final getReceptionistsUrl = "$apiUrl/api/receptionists";
final changeStatusUrl = "$apiUrl/api/receptionists/1/CONFIRMED";
class ReceptionistsApi {
  Future<List<AppointmentDTO>> getAllAppointment() async {

    try {
      final String? username = TokenManager().getUserSub();
      final String? token = TokenManager().getToken(); // Lấy token từ TokenManager

      print('Username: $username');
      print('Token: $token'); // In token ra để kiểm tra nếu cần

      final response = await http.get(
        Uri.parse(getReceptionistsUrl),
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

  Future<void> changeStatus(int appointmentId, String status) async {
    final String? token = TokenManager().getToken();
    final url = Uri.parse('$apiUrl/api/receptionists/$appointmentId/$status'); // Sử dụng status từ tham số

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Thêm token vào header
        },
      );

      if (response.statusCode == 200) {
        // Thành công, bạn có thể xử lý logic sau khi cập nhật vai trò tại đây
        print("Updated status successfully to $status");
        await getAllAppointment();
      } else {
        // Xử lý lỗi nếu có vấn đề với yêu cầu
        print("Failed to update status: ${response.body}");
      }
    } catch (error) {
      // Xử lý lỗi kết nối hoặc ngoại lệ khác
      print("An error occurred: $error");
    }
  }

}