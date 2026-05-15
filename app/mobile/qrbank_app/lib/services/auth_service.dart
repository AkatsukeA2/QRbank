import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qrbank_app/model/user.dart';

class AuthService {
  final String _httpUrl = 'http://localhost:8080/api/auth/login';

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_httpUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'token': data['token'],
        'tokenType': data['tokenType'],
        'refreshToken': data['refreshToken'],
        };
    } else {
      return null;
    }
  }
}
