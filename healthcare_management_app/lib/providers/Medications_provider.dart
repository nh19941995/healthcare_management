import 'dart:convert';
import 'package:healthcare_management_app/dto/getAppointment.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:healthcare_management_app/apis/Qa_api.dart';
import 'package:healthcare_management_app/apis/medications_api.dart';
import 'package:healthcare_management_app/models/Medication.dart';
import 'package:healthcare_management_app/models/Qa.dart';
import 'package:healthcare_management_app/models/prescriptions.dart';

class MedicationsProvider with ChangeNotifier {
  final MedicationsApi medicationsApi;
  MedicationsProvider({required this.medicationsApi}) {
    getAllMedications(); // Tải dữ liệu khi khởi tạo
  }

  final List<Medication> _list = [];
  List<Medication> get list => _list;

  GetAppointment? _prescriptionRequest;
  GetAppointment? get prescriptionRequest => _prescriptionRequest;


  Future<void> getAllMedications() async {
    final qa = await medicationsApi.getAllMedicationsApi();
    _list.clear();
    _list.addAll(qa);

    // // In ra danh sách _list để kiểm tra
    // print('Danh sách các qa:');
    // for (var medication in _list) {
    //   print(medication); // Sử dụng toString() của Qa hoặc in ra các thuộc tính cụ thể
    // }
    notifyListeners();
  }
  // Phương thức đăng ký
  Future<void> register(PrescriptionRequest prescriptionRequest) async {
    await medicationsApi.addPrescription(prescriptionRequest);
    notifyListeners();
  }

  // Fetch current user information based on username
  Future<void> getPrescriptionByAppointmentIdProvider(int appointmentId) async {
    _prescriptionRequest = null;
    GetAppointment fetchedUser = await medicationsApi.getPrescriptionByAppointmentId(appointmentId);
    _prescriptionRequest = fetchedUser;
    print("id: ${fetchedUser.appointmentId}");
    notifyListeners();
  }

  Medication? _MedicationDetail;

  Medication? get MedicationDetail => _MedicationDetail;

  Future<void> getMedicationDetailById(int appointmentId) async {
    final url = Uri.parse('http://localhost:8080/api/medications/$appointmentId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        _MedicationDetail = Medication.fromJson(json.decode(response.body));
        notifyListeners();
      } else {
        throw Exception('Failed to fetch prescription');
      }
    } catch (e) {
      print('Error fetching prescription: $e');
    }
  }

}
