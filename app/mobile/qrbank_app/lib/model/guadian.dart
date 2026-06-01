import 'dart:ffi';

class Guardian {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String relationShip;

  Guardian({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.relationShip
    });

    factory Guardian.fromJson(Map<String, dynamic> json) {
    return Guardian(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      relationShip: json['relationship'],
    );
  }

  

  Object? toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'relationShip': relationShip
    };
  }
}