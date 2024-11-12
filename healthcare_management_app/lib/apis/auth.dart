import 'dart:convert';
import 'dart:io';
import 'package:healthcare_management_app/dto/login_dto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../dto/register.dart';
import '../models/user.dart';


const registerUrl = "http://localhost:8080/auth/simpleRegister";
const loginUrl = "http://localhost:8080/auth/login";
const fixUserUrl = "http://localhost:8080/users";

class Auth {


  Future<Register> register(Register register) async  {
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(register.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Register.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add user');
    }
  }



  // Phương thức lấy thông tin người dùng
  Future<User> getUserInfo(String token) async {
    final response = await http.get(
      Uri.parse(fixUserUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Token cần truyền vào tiêu đề Authorization
      },
    );

    // Kiểm tra nếu yêu cầu thành công
    if (response.statusCode == 200) {
      // Giải mã JSON và tạo đối tượng User từ dữ liệu nhận được
      final Map<String, dynamic> userData = jsonDecode(response.body);
      return User.fromJson(userData); // Giả sử bạn có một model User để chuyển đổi dữ liệu
    } else {
      throw Exception('Không thể lấy thông tin người dùng');
    }
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

}

