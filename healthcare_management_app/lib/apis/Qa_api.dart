import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Config.dart';
import '../models/Qa.dart';

final String apiUrl = Config.apiUrl;
final baseURL = "$apiUrl/api/consultations";

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
        throw Exception("JSON data is malformed.");
      }
    } else {
      throw Exception("Failed to load data from API: ${response.statusCode}");
    }
  }
}
