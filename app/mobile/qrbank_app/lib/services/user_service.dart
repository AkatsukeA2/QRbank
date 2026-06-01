import 'package:qrbank_app/model/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  final String _httpUrl = 'http://192.168.122.1:8080/api/users';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  User? _currentUser;
  User? get currentUser => _currentUser;
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
  
   _currentUser = user;

  
  }

   Future<User?> loadCurrentUser() async {
    final jsonString = await _storage.read(key: 'currentUser');
    if (jsonString != null) {
      _currentUser = User.fromJson(jsonDecode(jsonString));
      return _currentUser;
    }
    return null;
  }

  Future<void> clearCurrentUser() async {
    _currentUser = null;
    await _storage.delete(key: 'currentUser');
    await _storage.delete(key: 'user');
    await _storage.delete(key: 'token');
  }
}
