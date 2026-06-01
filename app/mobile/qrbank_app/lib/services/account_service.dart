import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:qrbank_app/model/account.dart';

class AccountService {
    final String _httpUrl = 'http://192.168.37.245:8080/api/accounts';
    final FlutterSecureStorage _storage = FlutterSecureStorage();

    Future<Account?> getAccountByEmail(String email) async {
    final response = await http.get(
      Uri.parse('$_httpUrl?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Account.fromJson(data);
    } else {
      return null;
    }
  }

   Future<void> setCurrentAccount(Account account) async {
    // Lógica para armazenar o usuário atual na aplicação, por exemplo, usando SharedPreferences ou um gerenciador de estado
    final JsonString = jsonEncode(account.toJson());
    _storage.write(key: 'currentAccount', value: JsonString);
    await _storage.write(key: 'account', value: JsonString);
  }

}