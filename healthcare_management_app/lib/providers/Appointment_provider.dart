import '../dto/Api_appointment_dto.dart';
import '../apis/appointment_api.dart';
import 'package:flutter/material.dart';

import '../dto/Appointment_dto.dart';

class AppointmentProvider with ChangeNotifier {
  final AppointmentApi appointmentApi;
  List<ApiAppointmentDTO> _list = [];
  List<AppointmentDTO> _listAppointment = [];

  List<AppointmentDTO> get listAppointment => _listAppointment;

  AppointmentProvider({required this.appointmentApi});

  Future<void> createAppointmentProvider(ApiAppointmentDTO appointmentDto) async {
    try {
      // Tạo cuộc hẹn qua API với thông tin từ AppointmentDTO
      await appointmentApi.createAppointment(appointmentDto);

      // Nếu tạo thành công, thêm cuộc hẹn vào danh sách
      _list.add(appointmentDto);  // Vì API không trả về kết quả, nên ta sử dụng appointmentDto đã truyền vào

      // Thông báo cho các widget có sự thay đổi trong dữ liệu
      notifyListeners();

      // Hiển thị thông báo thành công
      print("Appointment created successfully!");
    } catch (error) {
      // Xử lý lỗi nếu có (kết nối, lỗi API...)
      print("An error occurred while creating appointment: $error");
    }
  }

  Future getAllAppointmentByUserName() async {
    final appointment = await AppointmentApi().getAllAppointmentByUserName();
    listAppointment.clear();
    listAppointment.addAll(appointment);

    // In ra danh sách _list để kiểm tra
    print('Danh sách các appointment:');
    for (var user in listAppointment) {
      print(user); // Sử dụng toString() của Clinic hoặc in ra các thuộc tính cụ thể
    }

    notifyListeners();
  }

}
