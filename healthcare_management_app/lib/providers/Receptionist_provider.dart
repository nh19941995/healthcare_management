import 'package:healthcare_management_app/apis/receptionists_api.dart';

import '../dto/Api_appointment_dto.dart';
import '../apis/appointment_api.dart';
import 'package:flutter/material.dart';

import '../dto/Appointment_dto.dart';
import '../screens/comons/TokenManager.dart';
import 'package:http/http.dart' as http;

class ReceptionistProvider with ChangeNotifier {
  final ReceptionistsApi receptionistsApi;
  List<AppointmentDTO> _listAppointment = [];

  List<AppointmentDTO> get listAppointment => _listAppointment;

  ReceptionistProvider({required this.receptionistsApi});


  Future getAllAppointment() async {
    final appointment = await ReceptionistsApi().getAllAppointment();
    listAppointment.clear();
    listAppointment.addAll(appointment);

    // In ra danh sách _list để kiểm tra
    print('Danh sách các appointment:');
    for (var user in listAppointment) {
      print(user); // Sử dụng toString() của Clinic hoặc in ra các thuộc tính cụ thể
    }
    notifyListeners();
  }
  Future<void> changeStatus(int appointmentId, String status) async {
    final String? token = TokenManager().getToken();
    final url = Uri.parse('http://localhost:8080/api/receptionists/$appointmentId/$status'); // Sử dụng status từ tham số

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Thêm token vào header
        },
      );

      if (response.statusCode == 200) {
        // Thành công, bạn có thể xử lý logic sau khi cập nhật trạng thái tại đây
        print("Updated status successfully to $status");

        // Sau khi cập nhật trạng thái thành công, gọi lại getAllAppointment() nếu cần
        await getAllAppointment();  // Gọi lại phương thức để lấy danh sách cập nhật
        notifyListeners();  // Cập nhật giao diện
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
