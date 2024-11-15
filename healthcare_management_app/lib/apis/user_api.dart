import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:healthcare_management_app/models/user.dart';
import '../dto/user_dto.dart';
import '../screens/comons/TokenManager.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:html' as html;


const baseURL = "http://localhost:8080/users";
const baseUpdateUser = "http://localhost:8080/api/users";
const getUserByAdmiUrl = "http://localhost:8080/admin/users?page=0&size=1000";

class UserApi {
  late String username;


  // Phương thức để thêm người dùng
  Future<User> addUser(User user) async {
    final response = await http.post(
      Uri.parse(baseURL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add user');
    }
  }

  // Phương thức để cập nhật thông tin người dùng
  Future<User> updateUser(UserDTO user) async {
    final String? token = TokenManager().getToken();

    final response = await http.put(
      Uri.parse(baseUpdateUser), // Địa chỉ API để cập nhật người dùng
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
        'Content-Type': 'application/json', // Định dạng nội dung
      },
      body: jsonEncode(user.toJson()), // Chuyển đổi UserDTO thành JSON
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to update user. Status code: ${response.statusCode}');
      throw Exception('Failed to update user');
    }
  }


  // Phương thức để lấy thông tin người dùng theo username
  Future<UserDTO> getUserByUserName() async {
    final String? username = TokenManager().getUserSub();
    final String? token = TokenManager().getToken(); // Lấy token từ TokenManager

    print('Username: $username');
    print('Token: $token'); // In token ra để kiểm tra nếu cần

    final String urlGetUser = 'http://localhost:8080/api/users/$username';

    final response = await http.get(
      Uri.parse(urlGetUser),
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
      },
    );

    if (response.statusCode == 200) {
      // Chuyển đổi phản hồi sang UTF-8
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print('Data from API: $data'); // In ra dữ liệu từ API để kiểm tra

      return UserDTO.fromJson(data);
    } else {
      print('Failed to load user data. Status code: ${response.statusCode}');
      throw Exception('Failed to load user data');
    }
  }


  //admin

  Future<List<UserDTO>> getUsersByAdmin() async {
    final String? username = TokenManager().getUserSub();
    final String? token = TokenManager().getToken(); // Lấy token từ TokenManager

    print('Username: $username');
    print('Token: $token'); // In token ra để kiểm tra nếu cần

    final response = await http.get(
      Uri.parse(getUserByAdmiUrl),
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
      },
    );

    if (response.statusCode == 200) {
      // Kiểm tra mã hóa
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('charset=utf-8')) {
        // Dữ liệu đã được mã hóa đúng
        final decodeResponse = jsonDecode(response.body) as List;
        return decodeResponse.map((userJson) => UserDTO.fromJson(userJson)).toList();
      } else {
        // Chuyển đổi sang UTF-8 nếu không phải UTF-8
        final responseBody = utf8.decode(response.bodyBytes);
        final decodeResponse = jsonDecode(responseBody);

        final userData = decodeResponse['content'] as List;
        return userData.map((userJson) => UserDTO.fromJson(userJson)).toList();
      }
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }


  Future<void> updateUserRole(String username, String role) async {
    final String? token = TokenManager().getToken();
    final url = Uri.parse('http://localhost:8080/admin/updateRole/$username/$role');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Thêm token vào header
        },
      );

      if (response.statusCode == 200) {
        // Thành công, bạn có thể xử lý logic sau khi cập nhật vai trò tại đây
        print("User role updated successfully");
      } else {
        // Xử lý lỗi nếu có vấn đề với yêu cầu
        print("Failed to update user role: ${response.body}");
      }
    } catch (error) {
      // Xử lý lỗi kết nối hoặc ngoại lệ khác
      print("An error occurred: $error");
    }
  }


  Future<void> deleteUser(String username) async {
    final String? token = TokenManager().getToken();
    final url = Uri.parse('http://localhost:8080/admin/blockOrUnblock/$username/shit');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Thêm token vào header
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("User deleted successfully.");
      } else {
        print("Failed to delete user: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }


  Future<String> uploadImageAsFormData(dynamic imageFile) async {
    final String? username = TokenManager().getUserSub();
    final String? token = TokenManager().getToken(); // Lấy token từ TokenManager

    // Kiểm tra nếu thiếu token hoặc username
    if (username == null || token == null) {
      throw Exception("Lỗi xác thực: Thiếu username hoặc token");
    }
    var url = Uri.parse("http://localhost:8080/api/images/uploadAvatar");

    try {
      // Kiểm tra nếu nền tảng là Web
      if (kIsWeb) {
        if (imageFile is html.File) {
          // Đọc file dưới dạng bytes
          final reader = html.FileReader();
          reader.readAsArrayBuffer(imageFile);
          await reader.onLoadEnd.first;

          // Chuyển đổi ArrayBuffer thành bytes
          final bytes = reader.result as List<int>;

          // Xác định contentType dựa trên loại file
          final mediaType = MediaType('image', 'jpg'); // Cập nhật nếu ảnh có định dạng khác (ví dụ 'png')

          // Tạo yêu cầu Multipart
          var request = http.MultipartRequest('POST', url)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['username'] = username
            ..files.add(http.MultipartFile.fromBytes(
              'file',  // Tên trường file trong form data
              bytes,
              filename: imageFile.name,
              contentType: mediaType,
            ));

          // Gửi yêu cầu và nhận phản hồi
          var response = await request.send();

          if (response.statusCode == 200) {
            final responseBody = await response.stream.bytesToString();
            return responseBody;  // Trả về phản hồi từ server
          } else {
            throw Exception("Upload thất bại: ${response.statusCode}");
          }
        } else {
          throw Exception("Yêu cầu chỉ sử dụng html.File trên Web");
        }
      } else {
        // Đối với Mobile, sử dụng File (dart:io)
        if (imageFile is File) {
          // Đọc ảnh dưới dạng bytes
          final bytes = await imageFile.readAsBytes();

          // Xác định contentType dựa trên loại file
          final mediaType = MediaType('image', 'jpg');  // Cập nhật nếu ảnh có định dạng khác (ví dụ 'png')

          // Tạo yêu cầu Multipart
          var request = http.MultipartRequest('POST', url)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['username'] = username
            ..files.add(http.MultipartFile.fromBytes(
              'file',  // Tên trường file trong form data
              bytes,
              filename: imageFile.uri.pathSegments.last,
              contentType: mediaType,
            ));

          // Gửi yêu cầu và nhận phản hồi
          var response = await request.send();

          if (response.statusCode == 200) {
            final responseBody = await response.stream.bytesToString();
            return responseBody;  // Trả về phản hồi từ server
          } else {
            throw Exception("Upload thất bại: ${response.statusCode}");
          }
        } else {
          throw Exception("Yêu cầu chỉ sử dụng dart:io.File trên Mobile");
        }
      }
    } catch (e) {
      throw Exception("Có lỗi xảy ra khi upload ảnh: $e");
    }
  }








}





