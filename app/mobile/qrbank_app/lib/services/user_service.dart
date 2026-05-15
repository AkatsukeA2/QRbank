import 'package:qrbank_app/model/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  final String _httpUrl = 'http://localhost:8080/api/users';
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  Future<User?> getUserByEmail(String email) async {
    final response = await http.get(
      Uri.parse('$_httpUrl?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      return null;
    }
  }

  Future<void> setCurrentUser(User user) async {
    // Lógica para armazenar o usuário atual na aplicação, por exemplo, usando SharedPreferences ou um gerenciador de estado
  final JsonString = jsonEncode(user.toJson());
   _storage.write(key: 'currentUser', value: JsonString);
   await _storage.write(key: 'user', value: JsonString);
  }
}
