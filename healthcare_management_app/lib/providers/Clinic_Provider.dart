import 'package:flutter/material.dart';
import 'package:healthcare_management_app/apis/clinics_api.dart';
import 'package:healthcare_management_app/models/Clinic.dart';
import 'package:healthcare_management_app/models/Time_slot.dart';

class ClinicProvider with ChangeNotifier {
  final ClinicApi clinicApi;

  ClinicProvider({required this.clinicApi});

  final List<Clinic> _list = [];
  final List<Timeslots> _listTime = [];

  List<Clinic> get list => _list;
  List<Timeslots> get listtime => _listTime;

  Future getAllClinic() async {
    final clinics = await clinicApi.getAllClinic();
    _list.clear();
    _list.addAll(clinics);

    // In ra danh sách _list để kiểm tra
    print('Danh sách các phòng khám:');
    for (var clinic in _list) {
      print(clinic); // Sử dụng toString() của Clinic hoặc in ra các thuộc tính cụ thể
    }

    notifyListeners();
  }

  Future getAllTimeSlot() async {
    final timelots = await clinicApi.getAllTimeSlots();
    _listTime.clear();
    _listTime.addAll(timelots);
  }
}