import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Qa.dart';

const baseURL = "http://localhost:8080/api/consultations";

class QaApi {
  Future<List<Qa>> getAllQa() async {
    final response = await http.get(Uri.parse(baseURL));

    if (response.statusCode == 200) {
      // Giải mã JSON từ phản hồi
      final decodedResponse = jsonDecode(response.body);

      // Kiểm tra nếu decodedResponse là một danh sách hoặc một đối tượng
      if (decodedResponse is List) {
        return decodedResponse.map((qa) => Qa.fromJson(qa)).toList();
      } else if (decodedResponse is Map && decodedResponse['content'] is List) {
        // Nếu JSON có một trường "data" chứa danh sách câu hỏi
        final List<dynamic> data = decodedResponse['content'];
        return data.map((qa) => Qa.fromJson(qa)).toList();
      } else {
        throw Exception("Dữ liệu JSON không đúng định dạng.");
      }
    } else {
      throw Exception("Failed to load data from API: ${response.statusCode}");
    }
  }
}
