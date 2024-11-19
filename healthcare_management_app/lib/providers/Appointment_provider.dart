import 'dart:convert';

import '../dto/Api_appointment_dto.dart';
import '../apis/appointment_api.dart';
import 'package:flutter/material.dart';

import '../dto/Appointment_dto.dart';

class AppointmentProvider with ChangeNotifier {
  final AppointmentApi appointmentApi;
  List<ApiAppointmentDTO> _list = [];
  List<AppointmentDTO> _listAppointment = [];
  List<AppointmentDTO> _listAppointmentAll = [];

  List<AppointmentDTO> get listAppointment => _listAppointment;
  List<AppointmentDTO> get listAppointmentAll => _listAppointmentAll;

  AppointmentProvider({required this.appointmentApi});

  // Future<void> createAppointmentProvider(ApiAppointmentDTO appointmentDto) async {
  //   try {
  //     // Tạo cuộc hẹn qua API với thông tin từ AppointmentDTO
  //     await appointmentApi.createAppointment(appointmentDto);
  //
  //     // Nếu tạo thành công, thêm cuộc hẹn vào danh sách
  //     _list.add(appointmentDto);  // Vì API không trả về kết quả, nên ta sử dụng appointmentDto đã truyền vào
  //
  //     // Thông báo cho các widget có sự thay đổi trong dữ liệu
  //     notifyListeners();
  //
  //     // Hiển thị thông báo thành công
  //     print("Appointment created successfully!");
  //   } catch (error) {
  //     // Xử lý lỗi nếu có (kết nối, lỗi API...)
  //     print("An error occurred while creating appointment: $error");
  //   }
  // }
  Future<String> createAppointmentProvider(ApiAppointmentDTO dto) async {
    try {
      final response = await appointmentApi.createAppointment(dto); // Gọi API function
      if (response.statusCode == 200) {
        return "success"; // Trả về success nếu statusCode là 200
      } else {
        return _extractErrorMessage(response.body) ?? "Unknown error occurred."; // Xử lý lỗi từ server
      }
    } catch (error) {
      throw Exception("Provider error: $error"); // Ném lỗi để UI xử lý
    }
  }

// Hàm trích xuất thông báo lỗi từ JSON response body
  String? _extractErrorMessage(String responseBody) {
    try {
      final Map<String, dynamic> errorData = json.decode(responseBody);
      return errorData['message']; // Lấy trường 'message' từ JSON
    } catch (e) {
      return null; // Nếu không trích xuất được, trả về null
    }
  }


  Future getAllAppointmentByUserName() async {
    final appointment = await AppointmentApi().getAllAppointmentByUserName();
    listAppointment.clear();
    listAppointment.addAll(appointment);

    // // In ra danh sách _list để kiểm tra
    // print('Danh sách các appointment:');
    // for (var user in listAppointment) {
    //   print(user); // Sử dụng toString() của Clinic hoặc in ra các thuộc tính cụ thể
    // }

    notifyListeners();
  }

  Future getAllAppointment() async {
    final appointment = await AppointmentApi().getAllAppointment();
    listAppointmentAll.clear();
    listAppointmentAll.addAll(appointment);

    // // In ra danh sách _list để kiểm tra
    // print('Danh sách các appointment:');
    // for (var user in listAppointment) {
    //   print(user); // Sử dụng toString() của Clinic hoặc in ra các thuộc tính cụ thể
    // }

    notifyListeners();
  }
}
