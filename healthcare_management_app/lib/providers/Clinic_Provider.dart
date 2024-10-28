import 'package:flutter/material.dart';
import 'package:healthcare_management_app/apis/clinics_api.dart';
import 'package:healthcare_management_app/models/Clinic.dart';

class ClinicProvider with ChangeNotifier {
  final ClinicApi clinicApi;

  ClinicProvider({required this.clinicApi});

  final List<Clinic> _list = [];

  List<Clinic> get list => _list;
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


}