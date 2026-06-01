import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:qrbank_app/model/transaction.dart';

class TransactionService {
    final String _httpUrl = 'http://192.168.122.1:8080/api/transactions';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Transaction>> getTransactionsByUserId(String userId) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('$_httpUrl/id/$userId'), // <-- PathVariable correto
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Transaction.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  Future<bool> transfer({
    required String senderId,
    required String receiverId,
    required String amount,
  }) async {
    try {
      final token = await _storage.read(key: 'token');

      // 1. Busca a conta do receptor pelo userId
      final accountResponse = await http.get(
        Uri.parse('http://192.168.37.245:8080/api/accounts/user/$receiverId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (accountResponse.statusCode != 200) return false;

      final accountData = jsonDecode(accountResponse.body);
      final receiverAccountId = accountData['id']; // Long da conta

      // 2. Faz a transferência
      final response = await http.post(
        Uri.parse('$_httpUrl/$senderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': double.parse(amount.replaceAll(',', '.')),
          'type': 'DEBIT',
          'receiverAccountID': receiverAccountId,
          'reference': null,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }

  }
   Future<void> setCurrentAccount(Transaction transaction) async {
    // Lógica para armazenar o usuário atual na aplicação, por exemplo, usando SharedPreferences ou um gerenciador de estado
    final JsonString = jsonEncode(transaction.toJson());
    _storage.write(key: 'currentAccount', value: JsonString);
    }
    
}
