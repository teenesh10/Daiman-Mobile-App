import 'package:daiman_mobile/models/facility.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingController with ChangeNotifier {
  List<Facility> facilities = []; // List of facilities
  Facility? selectedFacility; // The currently selected facility

  BookingController() {
    _fetchFacilities(); // Fetch facilities when the controller is initialized
  }

  Future<void> _fetchFacilities() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('facility').get();
      facilities =
          snapshot.docs.map((doc) => Facility.fromFirestore(doc)).toList();

      print(
          'Facilities fetched: ${facilities.length}'); // Print the number of facilities
      for (var facility in facilities) {
        print(
            'Facility: ${facility.facilityName}, Capacity: ${facility.capacity}, Description: ${facility.description}'); // Print each facility's details
      }
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print('Error fetching facilities: $e');
    }
  }

  void selectFacility(Facility facility) {
    selectedFacility = facility;
    notifyListeners(); // Notify listeners to update UI
  }
}
