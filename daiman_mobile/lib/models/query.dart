import 'package:cloud_firestore/cloud_firestore.dart';

class Query {
  String queryID;
  String userID;
  DateTime date;
  String report;
  String status;

  Query({
    required this.queryID,
    required this.userID,
    required this.date,
    required this.report,
    required this.status,
  });

  // Convert Booking instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'queryID': queryID,
      'userID': userID,
      'date': date,
      'report': report,
      'status': status,
    };
  }

  // Create a Booking instance from Firestore data
  factory Query.fromMap(Map<String, dynamic> map) {
    return Query(
      queryID: map['queryID'] ?? '',
      userID: map['userID'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      report: map['report'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
