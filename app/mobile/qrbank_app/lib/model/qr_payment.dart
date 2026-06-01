class QrPayment {
  final String id;
  final String amount;
  final String type;
  final String status;
  final String senderId;
  final String receiverId;
  final DateTime createdAt;

  QrPayment({
  required this.id, 
  required this.amount, 
  required this.type,
  required this.status, 
  required this.senderId, 
  required this.receiverId, 
  required this.createdAt, 
  });

  factory QrPayment.fromJson(Map<String, dynamic> json) {
    return QrPayment(
      id: json['id'],
      amount: json['amount'],
      type: json['type'],
      status: json['status'],
      senderId: json['senderAccountId'],
      receiverId: json['receiverAccountId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'status': status,
      'senderAccountId': senderId,
      'receiverAccountId': receiverId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}