import 'dart:ffi';

class Register {
  final String firtName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final DateTime dateOfBirth;
  
  Register({
    required this.email,
    required this.password,
    required this.firtName,
    required this.lastName,
    required this.phone,
    required this.dateOfBirth,
  });

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      email: json['email'],
      password: json['password'],
      firtName: json['firtName'],
      lastName: json['lastName'],
      phone: json['phone'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
    );
  }

  Object? toJson() {
    return {
      'email': email,
      'password': password,
      'firtName': firtName,
      'lastName': lastName,
      'phone': phone,
      'date_of_birth': dateOfBirth.toIso8601String(),
      };
  }
}
