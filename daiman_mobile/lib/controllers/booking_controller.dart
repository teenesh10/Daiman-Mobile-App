import 'package:daiman_mobile/models/court.dart';
import 'package:daiman_mobile/models/facility.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingController with ChangeNotifier {
  List<Facility> facilities = []; // List of facilities
  Facility? selectedFacility; // The currently selected facility
  List<Court> courts = [];
  List<Court> selectedCourts = [];

  BookingController() {
    _fetchFacilities(); // Fetch facilities when the controller is initialized
  }

  Future<void> _fetchFacilities() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('facility').get();
      facilities =
          snapshot.docs.map((doc) => Facility.fromFirestore(doc)).toList();
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print('Error fetching facilities: $e');
    }
  }

  void selectFacility(Facility facility) {
    selectedFacility = facility;
    notifyListeners(); // Notify listeners to update UI
  }

  Future<void> fetchCourts(String facilityId) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('facility')
          .doc(facilityId)
          .collection('courts')
          .get();
      courts = snapshot.docs.map((doc) => Court.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching courts: $e');
    }
  }

  // Fetch available courts based on date, start time, and duration
  Future<List<Court>> fetchAvailableCourts(String facilityID, DateTime date,
      DateTime startTime, int duration) async {
    try {
      print('Fetching courts for facility: $facilityID'); // Debugging line

      // Remove time part from date
      final onlyDate = DateTime(date.year, date.month, date.day);

      // Fetch all courts for the given facility (using 'court' collection)
      final snapshot = await FirebaseFirestore.instance
          .collection('facility')
          .doc(facilityID)
          .collection('court') // Change to 'court' (singular)
          .get();

      if (snapshot.docs.isEmpty) {
        print("No courts found in Firestore for this facility.");
      }

      final allCourts =
          snapshot.docs.map((doc) => Court.fromFirestore(doc)).toList();

      // Print all court names and check data integrity
      if (allCourts.isEmpty) {
        print("No courts found for this facility.");
      } else {
        print("All courts fetched for facility $facilityID:");
        for (var court in allCourts) {
          print(
              'Court Name: ${court.courtName}, Court ID: ${court.courtID}, Description: ${court.description}, Availability: ${court.availability}');
        }
      }

      // Query bookings for the selected date (only date without time)
      final bookingsSnapshot = await FirebaseFirestore.instance
          .collection('booking')
          .where('facilityID', isEqualTo: facilityID)
          .where('date', isEqualTo: Timestamp.fromDate(onlyDate))
          .get();

      if (bookingsSnapshot.docs.isEmpty) {
        // If no bookings exist, return all courts
        print("No bookings found. Returning all courts.");
        return allCourts;
      }

      // Check for overlap if there are bookings
      final bookedCourts = bookingsSnapshot.docs.map((doc) {
        DateTime bookedStartTime = (doc['startTime'] as Timestamp).toDate();
        int bookedDuration = doc['duration'];

        DateTime bookedEndTime =
            bookedStartTime.add(Duration(hours: bookedDuration));

        // Check if the new booking overlaps with an existing one
        bool isOverlap = (startTime.isBefore(bookedEndTime) &&
            startTime.add(Duration(hours: duration)).isAfter(bookedStartTime));

        return {
          'courtID': doc['courtID'] as String,
          'isOverlap': isOverlap,
        };
      }).toList();

      // Filter out courts that are already booked
      final availableCourts = allCourts.where((court) {
        return !bookedCourts.any((booking) {
          return booking['courtID'] == court.courtID &&
              booking['isOverlap'] == true;
        });
      }).toList();

      print(
          'Fetched available courts: ${availableCourts.map((c) => c.courtName).toList()}');

      return availableCourts;
    } catch (e) {
      print('Error fetching available courts: $e');
      return [];
    }
  }

  void addCourtToSelection(Court court) {
    if (!selectedCourts.contains(court)) {
      selectedCourts.add(court);
      notifyListeners();
    }
  }

  void removeCourtFromSelection(Court court) {
    selectedCourts.remove(court);
    notifyListeners();
  }
}
