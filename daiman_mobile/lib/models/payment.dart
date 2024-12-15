import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  String paymentID;
  double amount;
  String paymentMethod; // e.g., "credit card", "FPX", "e-wallet"
  String status; // e.g., "completed", "failed"
  DateTime timestamp;

  Payment({
    required this.paymentID,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.timestamp,
  });

  // Convert Payment instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'paymentID': paymentID,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
      'timestamp': timestamp,
    };
  }

  // Create a Payment instance from Firestore data
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      paymentID: map['paymentID'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      status: map['status'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
