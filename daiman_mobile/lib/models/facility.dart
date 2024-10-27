import 'package:cloud_firestore/cloud_firestore.dart';

class Facility {
  final String facilityID;
  final String facilityName;
  final int capacity;
  final String description;

  Facility({
    required this.facilityID,
    required this.facilityName,
    required this.capacity,
    required this.description,
  });

  factory Facility.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Facility(
      facilityID: doc.id, // Get the document ID
      facilityName: data['facilityName'] ?? '',
      capacity: data['capacity'] ?? 0,
      description: data['description'] ?? '',
    );
  }
}

