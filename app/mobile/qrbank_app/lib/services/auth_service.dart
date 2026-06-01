import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as _storage;
import 'package:qrbank_app/model/register.dart';
import 'package:qrbank_app/model/user.dart';

class AuthService {
   final FlutterSecureStorage _storage = FlutterSecureStorage();
  final String _loginUrl = 'http://192.168.122.1:8080/api/auth/login';
  final String _registerUrl = 'http://192.168.122.1:8080/api/auth/register';

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_loginUrl'),
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

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'currentUser');
  }

  Future<Map<String, dynamic>?> register(String email, String password, String name, DateTime age, String phone) async {
    final newName = name.split('');
    Register register = new Register(email: email, password: password, firtName: newName[0], lastName: newName[newName.length], phone: phone, dateOfBirth: age);
    final response = await http.post(
      Uri.parse('$_loginUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(register),
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
