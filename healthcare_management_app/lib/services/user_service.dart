import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/user.dart';

class UserService {
  static const String _baseUrl = 'http://172.27.48.1:8080';
  static const String _path = '/public';
  static const int _timeout = 10000; // 10 seconds in milliseconds

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: Duration(milliseconds: _timeout),
    receiveTimeout: Duration(milliseconds: _timeout),
  ));

  static Future<User?> fetchUser() async {
    try {
      // Check for internet connectivity
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection');
      }

      final response = await _dio.get(
        _path,
        options: Options(
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Successful response: ${response.data}');
        return User.fromJson(response.data);
      } else {
        print('Failed to load user. Status code: ${response.statusCode}');
        print('Response data: ${response.data}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to load user: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        print('Timeout error: $e');
        throw TimeoutException('The connection has timed out. Please try again!');
      } else if (e.error is SocketException) {
        print('Socket error: ${e.error}');
        throw Exception('Network error: Please check your connection');
      } else {
        print('Dio error: $e');
        throw Exception('An unexpected error occurred: $e');
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}