import 'package:cloud_firestore/cloud_firestore.dart';

class Query {
  String queryID;
  String userID;
  DateTime date;
  String report;

  Query({
    required this.queryID,
    required this.userID,
    required this.date,
    required this.report,
  });

  // Convert Booking instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'queryID': queryID,
      'userID': userID,
      'date': date,
      'report': report,
    };
  }

  // Create a Booking instance from Firestore data
  factory Query.fromMap(Map<String, dynamic> map) {
    return Query(
      queryID: map['queryID'] ?? '',
      userID: map['userID'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      report: map['report'] ?? '',
    );
  }
}
