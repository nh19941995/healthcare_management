// lib/token_manager.dart

import 'package:jwt_decoder/jwt_decoder.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  String? _token;

  factory TokenManager() {
    return _instance;
  }

  TokenManager._internal();

  void setToken(String token) {
    _token = token;
  }

  String? getToken() {
    return _token;
  }

  String? getUserSub() {
    if (_token == null) return null;

    final decodedToken = JwtDecoder.decode(_token!);
    return decodedToken['sub'];
  }
}
