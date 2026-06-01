import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:qrbank_app/model/guadian.dart';

class GuardianService {
  final String _httpUrl = 'http://192.168.122.1:8080/api/guardians/by-email';
  final String _registUrl = 'http://192.168.122.1:8080/api/guardians';
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  Future<Guardian?> getGuardianByEmail(String email) async {
    final response = await http.get(
      Uri.parse('$_httpUrl?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Guardian.fromJson(data);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> registeGuardian(String name, String email, String phone, String relationShip) async {
    final newName = name.split('');
    Guardian guardian = new Guardian(firstName: newName[0], lastName: newName[newName.length], email: email, phone: phone, relationShip: relationShip);
    final response = await http.post(
      Uri.parse('$_registUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(guardian),
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
