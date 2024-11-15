import 'dart:convert';
import 'package:healthcare_management_app/dto/getAppointment.dart';
import 'package:healthcare_management_app/models/Medication.dart';
import 'package:http/http.dart' as http;
import '../models/Qa.dart';
import '../models/prescriptions.dart';
import '../screens/comons/TokenManager.dart';

const baseURL = "http://localhost:8080/api/medications";
const prescriptions = "http://localhost:8080/api/prescriptions";

class MedicationsApi {
  Future<List<Medication>> getAllMedicationsApi() async {
    final response = await http.get(Uri.parse(baseURL));

    if (response.statusCode == 200) {
      // Giải mã JSON từ phản hồi
      final decodedResponse = jsonDecode(response.body);

      // Kiểm tra nếu decodedResponse là một danh sách hoặc một đối tượng
      if (decodedResponse is List) {
        return decodedResponse.map((medication) => Medication.fromJson(medication)).toList();
      } else if (decodedResponse is Map && decodedResponse['content'] is List) {
        // Nếu JSON có một trường "data" chứa danh sách câu hỏi
        final List<dynamic> data = decodedResponse['content'];
        return data.map((medication) => Medication.fromJson(medication)).toList();
      } else {
        throw Exception("Dữ liệu JSON không đúng định dạng.");
      }
    } else {
      throw Exception("Failed to load data from API: ${response.statusCode}");
    }
  }

  // Phương thức để thêm đơn thuốc
  Future<void> addPrescription(PrescriptionRequest prescriptionRequest) async {
    final String? token = TokenManager().getToken();
    final response = await http.post(
      Uri.parse(prescriptions),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(prescriptionRequest.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Xử lý nếu thành công
      print('Prescription created successfully');
    } else {
      // Xử lý nếu thất bại
      throw Exception('Failed to create prescription');
    }
  }

  // Phương thức để lấy thông tin người dùng theo username
  Future<GetAppointment> getPrescriptionByAppointmentId(int appointmentId) async {
    final String? username = TokenManager().getUserSub();
    final String? token = TokenManager().getToken(); // Lấy token từ TokenManager

    print('Username: $username');
    print('Token: $token'); // In token ra để kiểm tra nếu cần

    final String url = 'http://localhost:8080/api/prescriptions/appointment/$appointmentId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
      },
    );

    if (response.statusCode == 200) {
      // Chuyển đổi phản hồi sang UTF-8
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print('PrescriptionRequest from API: $data'); // In ra dữ liệu từ API để kiểm tra

      return GetAppointment.fromJson(data);
    } else {
      print('Failed to load PrescriptionRequest data. Status code: ${response.statusCode}');
      throw Exception('Failed to load PrescriptionRequest data');
    }
  }
}

