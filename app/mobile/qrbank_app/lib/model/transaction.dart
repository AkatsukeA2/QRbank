import 'dart:ui';

import 'package:flutter/material.dart';

class Transaction {
  String id;
  int? index;
  String? title;
  String? subtitle;
  bool? isCredit;
  final String amount;
  final DateTime createdAt;
  final String type;
  Color? iconColor;
  Color? iconFgColor;
  IconData? icon;
  final String status;
  final String senderId;
  final String receiverId;

  Transaction({
    required this.id,
    this.index,
    this.title,
    this.subtitle,
    this.isCredit,
    required this.amount,
    required this.createdAt,
    required this.type,
    required this.status,
    required this.senderId,
    required this.receiverId,
    this.iconColor,
    this.iconFgColor,
    this.icon, 
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      createdAt: DateTime.parse(json['createdAt']),
      type: (json['TransactionType'] ?? json['TransactionType '] ?? '')
          .toString()
          .trim(),
      status: json['TransactionStatus'],
      senderId: json['senderAccountId'],
      receiverId: json['receiverAccountId'],
    );
  }

  Object? toJson() {
    return {
      'id': id,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'TransactionType ': type,
      'TransactionStatus': status,
      'senderAccountId': senderId,
      'receiverAccountId': receiverId,
    };
  }
}


