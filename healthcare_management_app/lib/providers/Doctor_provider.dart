import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:healthcare_management_app/apis/doctor_api.dart';
import 'package:healthcare_management_app/dto/Doctor_dto.dart';
import 'package:healthcare_management_app/dto/update_doctor_dto.dart';
import 'package:http/http.dart' as http;

import '../dto/Appointment_dto.dart';
import '../models/GetDoctorProfile.dart';
import '../screens/comons/TokenManager.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorApi doctorApi;

  DoctorProvider({required this.doctorApi}); // Updated constructor

  final List<DoctorDTO> _list = [];
  List<DoctorDTO> get list => _list;

  List<AppointmentDTO> _listAppointment = [];

  List<AppointmentDTO> get listAppointment => _listAppointment;

  GetDoctorProfile? _doctor_pro;
  GetDoctorProfile? get doctor_pro => _doctor_pro;

  GetDoctorProfile? _doctor_pro_appointment;
  GetDoctorProfile? get doctor_pro_appointment => _doctor_pro_appointment;

  Future<void> updateDoctor(UpdateDoctorDto updateDoctorDto) async {
    await DoctorApi().updateDoctor(updateDoctorDto);
    notifyListeners();
  }

  Future getAllDoctor() async {
    final doctors = await DoctorApi().getAllDoctors();
    _list.clear();
    _list.addAll(doctors);

    // // In ra danh sách _list để kiểm tra
    // print('Danh sách các doctors:');
    // for (var doctor in _list) {
    //   print(doctor); // Sử dụng toString() của Clinic hoặc in ra các thuộc tính cụ thể
    // }

    notifyListeners();
  }

  // Fetch current user information based on username
  Future<void> getDoctorByUserName() async {
    GetDoctorProfile fetcheddoctor = await DoctorApi().getDoctorByUserName();
    _doctor_pro = fetcheddoctor;
    //print("id: ${fetcheddoctor.username}");
    notifyListeners();
  }

  Future<void> getDoctorByUserNameForAppointment(String username) async {
    try {
      GetDoctorProfile fetcheddoctor =
          await DoctorApi().getDoctorByUserNameForAppoiment(username);
      _doctor_pro_appointment = fetcheddoctor;
      notifyListeners();
    } catch (e) {
      print("Error fetching doctor: $e");
    }
  }

  Future getAllAppointmentEachDoctor() async {
    final appointment = await DoctorApi().getAllAppointment();
    listAppointment.clear();
    listAppointment.addAll(appointment);

    // // In ra danh sách _list để kiểm tra
    // print('Danh sách các appointment:');
    // for (var user in listAppointment) {
    //   print(user); // Sử dụng toString() của Clinic hoặc in ra các thuộc tính cụ thể
    // }
    notifyListeners();
  }

  Future<void> changeStatus(int appointmentId, String status) async {
    final String? token = TokenManager().getToken();
    final url = Uri.parse('http://localhost:8080/api/doctors/appointments/$appointmentId/$status'); // Sử dụng status từ tham số

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
        await getAllAppointmentEachDoctor();  // Gọi lại phương thức để lấy danh sách cập nhật
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

  // Future<void> getMuntilStatusAppointmentEachDoctor(String status) async {
  //   await DoctorApi().getMuntilStatusAppointment(status);
  //   notifyListeners();
  // }

  // Future<List<AppointmentDTO>> getMuntilStatusAppointment(String status) async {
  //
  //   try {
  //     final String? username = TokenManager().getUserSub();
  //     final String? token = TokenManager().getToken(); // Lấy token từ TokenManager
  //
  //     final gerAppointEachDoctorUrl = 'http://localhost:8080/api/doctors/appointments/$username/$status';
  //
  //     print('Username: $username');
  //     print('Token: $token'); // In token ra để kiểm tra nếu cần
  //
  //     final response = await http.get(
  //       Uri.parse(gerAppointEachDoctorUrl),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // Kiểm tra mã hóa
  //       final contentType = response.headers['content-type'];
  //       if (contentType != null && contentType.contains('charset=utf-8')) {
  //         // Dữ liệu đã được mã hóa đúng
  //         final decodeResponse = jsonDecode(response.body) as List;
  //         return decodeResponse.map((appointmentJson) => AppointmentDTO.fromJson(appointmentJson)).toList();
  //       } else {
  //         // Chuyển đổi sang UTF-8 nếu không phải UTF-8
  //         final responseBody = utf8.decode(response.bodyBytes);
  //         final decodeResponse = jsonDecode(responseBody);
  //
  //         final appointmentData = decodeResponse['content'] as List;
  //         return appointmentData.map((appointmentJson) => AppointmentDTO.fromJson(appointmentJson)).toList();
  //       }
  //     } else {
  //       throw Exception('Failed to load appointment: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching appointment: $e');
  //   }
  // }

  List<AppointmentDTO> _listAppointmentMultilStatus = [];
  bool _isLoading = false;

  List<AppointmentDTO> get listAppointmentMultilStatus => _listAppointmentMultilStatus;
  bool get isLoading => _isLoading;

  Future<void> getMuntilStatusAppointmentEachDoctor(String status) async {
    _isLoading = true;
    notifyListeners(); // Cập nhật trạng thái loading

    try {
      final String? username = TokenManager().getUserSub();
      final String? token = TokenManager().getToken(); // Lấy token từ TokenManager

      final gerAppointEachDoctorUrl = 'http://localhost:8080/api/doctors/appointments/$username/$status';

      print('Username: $username');
      print('Token: $token'); // In token ra để kiểm tra nếu cần

      final response = await http.get(
        Uri.parse(gerAppointEachDoctorUrl),
        headers: {
          'Authorization': 'Bearer $token', // Thêm Authorization header nếu cần
        },
      );

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('charset=utf-8')) {
          final decodeResponse = jsonDecode(response.body) as List;
          _listAppointmentMultilStatus = decodeResponse.map((appointmentJson) => AppointmentDTO.fromJson(appointmentJson)).toList();
        } else {
          final responseBody = utf8.decode(response.bodyBytes);
          final decodeResponse = jsonDecode(responseBody);
          final appointmentData = decodeResponse['content'] as List;
          _listAppointmentMultilStatus = appointmentData.map((appointmentJson) => AppointmentDTO.fromJson(appointmentJson)).toList();
        }
      } else {
        throw Exception('Failed to load appointment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching appointment: $e');
      throw Exception('Error fetching appointment: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Cập nhật trạng thái hoàn tất
    }
  }

}


