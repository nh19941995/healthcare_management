import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:healthcare_management_app/apis/Specializations_api.dart';
import 'package:http/http.dart' as http;

import '../models/Specialization.dart';



class SpecializationsProvider with ChangeNotifier {
  final SpecializationApi specializationApi;
  SpecializationsProvider({required this.specializationApi}) {
    getAllSpecializations();
  }

  final List<Specialization> _list = [];
  List<Specialization> get list => _list;

  Future<void> getAllSpecializations() async {
    final qa = await specializationApi.getAllSpecializations();
    _list.clear();
    _list.addAll(qa);

    // // In ra danh sách _list để kiểm tra
    // print('Danh sách các Specializations:');
    // for (var spe in _list) {
    //   print(spe); // Sử dụng toString() của Qa hoặc in ra các thuộc tính cụ thể
    // }

    notifyListeners();
  }


}


