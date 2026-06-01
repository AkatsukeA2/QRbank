import 'dart:ffi';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final Long roleId;
  final Long? guardianId;
  final Long accountId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime dateOfBirth;
  final String? tokenValidated;
  final bool? isTokenValidated;
  final String? profilePictureUrl;
  final String? qrCodeData;
  final bool? isMinor;

  

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.roleId,
    required this.accountId,
    this.guardianId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.dateOfBirth,
    this.tokenValidated,
    this.isTokenValidated,
    this.profilePictureUrl,
    this.qrCodeData,
    this.isMinor,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      roleId: json['role_id'],
      guardianId: json['guardian_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      accountId: json['account_id'],
      tokenValidated: json['token_validated'],
      isTokenValidated: json['is_token_validated'],
      profilePictureUrl: json['profile_picture_url'],
      qrCodeData: json['qr_code_data'],
      isMinor: json['is_minor'],
    );
  }

  Object? toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lasstName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'role_id': roleId,
      'guardian_id': guardianId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'date_of_birth': dateOfBirth.toIso8601String(),
      'account_id': accountId,
      'token_validated': tokenValidated,
      'is_token_validated': isTokenValidated,
      'profile_picture_url': profilePictureUrl,
      'qr_code_data': qrCodeData,
      'is_minor': isMinor,
    };
  }
}