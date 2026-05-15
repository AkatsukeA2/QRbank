class Account {
  final String id;
  final String accountNumber;
  final String iban;
  final double balance;
  final String currency;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Account({
    required this.id,
    required this.accountNumber,
    required this.iban,
    required this.balance,
    required this.currency,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      accountNumber: json['accountNumber'],
      iban: json['iban'],
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}