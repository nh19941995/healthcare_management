import 'package:flutter/cupertino.dart';
import 'package:healthcare_management_app/apis/doctor_api.dart';
import 'package:healthcare_management_app/dto/Doctor_dto.dart';
import 'package:healthcare_management_app/dto/update_doctor_dto.dart';
import 'package:healthcare_management_app/models/Doctor_detail.dart';

import '../dto/Appointment_dto.dart';
import '../models/GetDoctorProfile.dart';

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
      GetDoctorProfile fetcheddoctor = await DoctorApi().getDoctorByUserNameForAppoiment(username);
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
  }

