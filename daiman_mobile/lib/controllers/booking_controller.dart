import 'package:daiman_mobile/models/court.dart';
import 'package:daiman_mobile/models/facility.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingController with ChangeNotifier {
  List<Facility> facilities = []; // List of facilities
  Facility? selectedFacility; // The currently selected facility
  List<Court> courts = []; // All courts in the selected facility
  List<Court> selectedCourts = [];
  Map<String, double> rates = {}; // Facility rates
  List<Court> _cachedAvailableCourts = [];

  DateTime? selectedDate; // Selected date
  DateTime? startTime; // Selected start time
  int duration = 1; // Selected duration, default is 1 hour

  BookingController() {
    _fetchFacilities(); // Fetch facilities when the controller is initialized
  }

  // Fetch facilities from Firestore
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

  // Select a facility and fetch its rates
  void selectFacility(Facility facility) {
    selectedFacility = facility;
    // Clear previous rates before fetching new ones
    rates = {
      'weekdayRateBefore6': 0.0,
      'weekdayRateAfter6': 0.0,
      'weekendRateBefore6': 0.0,
      'weekendRateAfter6': 0.0,
    };
    _fetchFacilityRates(facility.facilityID);
    notifyListeners(); // Notify listeners to update UI
  }

  // Fetch all courts for the selected facility
  Future<void> fetchCourts(String facilityId) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('facility')
          .doc(facilityId)
          .collection('court')
          .get();
      courts = snapshot.docs.map((doc) => Court.fromFirestore(doc)).toList();
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print('Error fetching courts: $e');
    }
  }

  // Fetch available courts based on date, start time, and duration
  Future<List<Court>> fetchAvailableCourts(String facilityID, DateTime date,
      DateTime startTime, int duration) async {
    if (_cachedAvailableCourts.isNotEmpty) {
      return _cachedAvailableCourts; // Return cached courts if already fetched
    }
    try {
      print('Fetching courts for facility: $facilityID');
      final onlyDate = DateTime(date.year, date.month, date.day);
      final snapshot = await FirebaseFirestore.instance
          .collection('facility')
          .doc(facilityID)
          .collection('court')
          .get();

      final allCourts =
          snapshot.docs.map((doc) => Court.fromFirestore(doc)).toList();

      final bookingsSnapshot = await FirebaseFirestore.instance
          .collection('booking')
          .where('facilityID', isEqualTo: facilityID)
          .where('date', isEqualTo: Timestamp.fromDate(onlyDate))
          .get();

      if (bookingsSnapshot.docs.isEmpty) {
        _cachedAvailableCourts = allCourts;
        return _cachedAvailableCourts;
      }

      final bookedCourts = bookingsSnapshot.docs.map((doc) {
        DateTime bookedStartTime = (doc['startTime'] as Timestamp).toDate();
        int bookedDuration = doc['duration'];
        DateTime bookedEndTime =
            bookedStartTime.add(Duration(hours: bookedDuration));

        bool isOverlap = (startTime.isBefore(bookedEndTime) &&
            startTime.add(Duration(hours: duration)).isAfter(bookedStartTime));

        return {
          'courtID': doc['courtID'] as String,
          'isOverlap': isOverlap,
        };
      }).toList();

      final availableCourts = allCourts.where((court) {
        return !bookedCourts.any((booking) {
          return booking['courtID'] == court.courtID &&
              booking['isOverlap'] == true;
        });
      }).toList();

      _cachedAvailableCourts = availableCourts;
      return _cachedAvailableCourts;
    } catch (e) {
      print('Error fetching available courts: $e');
      return [];
    }
  }

  void addCourtToSelection(Court court) {
    if (!selectedCourts.contains(court)) {
      selectedCourts.add(court);
      print("Court added to selection: ${court.courtName}");
      print(
          "Currently selected courts: ${selectedCourts.map((c) => c.courtName).join(', ')}");
      notifyListeners();
    }
  }

  void removeCourtFromSelection(Court court) {
    if (selectedCourts.contains(court)) {
      selectedCourts.remove(court);
      print("Court removed from selection: ${court.courtName}");
      print(
          "Currently selected courts: ${selectedCourts.map((c) => c.courtName).join(', ')}");
      notifyListeners();
    }
  }

  // Fetch the rates from the Fee subcollection for the selected facility
  Future<void> _fetchFacilityRates(String facilityId) async {
    try {
      final feeSnapshot = await FirebaseFirestore.instance
          .collection('facility')
          .doc(facilityId)
          .collection('fee')
          .get();

      if (feeSnapshot.docs.isEmpty) {
        print('No fee data found for this facility.');
        return;
      }

      final ratesData = feeSnapshot.docs.first.data(); // Assuming one document
      rates = {
        'weekdayRateBefore6':
            ratesData['weekdayRateBefore6']?.toDouble() ?? 0.0,
        'weekdayRateAfter6': ratesData['weekdayRateAfter6']?.toDouble() ?? 0.0,
        'weekendRateBefore6':
            ratesData['weekendRateBefore6']?.toDouble() ?? 0.0,
        'weekendRateAfter6': ratesData['weekendRateAfter6']?.toDouble() ?? 0.0,
      };

      print(
          'Fetched rates: $rates'); // Log the rates to check if they are correct
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print('Error fetching facility rates: $e');
    }
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    print("Selected Date set in Controller: $selectedDate");
    notifyListeners();
  }

  void setStartTime(DateTime time) {
    startTime = time;
    print("Selected Start Time set in Controller: $startTime");
    notifyListeners();
  }

  void setDuration(int hours) {
    duration = hours;
    print("Selected Duration set in Controller: $duration hours");
    notifyListeners();
  }
}
