import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String bookingID;
  String userID;
  String facilityID;
  String courtID;
  DateTime date;
  DateTime startTime;
  int duration;
  DateTime bookingMade; 

  Booking({
    required this.bookingID,
    required this.userID,
    required this.facilityID,
    required this.courtID,
    required this.date,
    required this.startTime,
    required this.duration,
    required this.bookingMade,
  });

  // Convert Booking instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'bookingID': bookingID,
      'userID': userID,
      'facilityID': facilityID,
      'courtID': courtID,
      'date': date,
      'startTime': startTime,
      'duration': duration,
      'bookingMade': bookingMade,
    };
  }

  // Create a Booking instance from Firestore data
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      bookingID: map['bookingID'] ?? '',
      userID: map['userID'] ?? '',
      facilityID: map['facilityID'] ?? '',
      courtID: map['courtID'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      startTime: (map['startTime'] as Timestamp).toDate(),
      duration: map['duration'] ?? 0,
      bookingMade: (map['bookingMade'] as Timestamp).toDate(),
    );
  }
}
