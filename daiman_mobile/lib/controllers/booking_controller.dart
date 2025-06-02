import 'package:daiman_mobile/models/court.dart';
import 'package:daiman_mobile/models/facility.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingController with ChangeNotifier {
  List<Facility> facilities = [];
  Facility? selectedFacility;
  List<Court> selectedCourts = [];
  Map<String, double> rates = {};

  DateTime? selectedDate;
  DateTime? startTime;
  int duration = 1;

  BookingController() {
    _fetchFacilities();
  }

  /// Fetch all facilities from Firestore
  Future<void> _fetchFacilities() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('facility').get();
      facilities = snapshot.docs.map(Facility.fromFirestore).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching facilities: $e');
    }
  }

  /// Handle facility selection and initialize rates
  void selectFacility(Facility facility) {
    selectedFacility = facility;
    selectedCourts.clear();
    rates.clear();
    _fetchFacilityRates(facility.facilityID);
    notifyListeners();
  }

  /// Fetch courts under a specific facility
  Future<List<Court>> fetchCourts(String facilityId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('facility')
        .doc(facilityId)
        .collection('court')
        .get();

    return snapshot.docs.map(Court.fromFirestore).toList();
  }

  Future<List<Court>> fetchAvailableCourts(
    String facilityID,
    DateTime date,
    DateTime startTime,
    int duration,
  ) async {
    try {
      final allCourts = await fetchCourts(facilityID);

      // Get bookings matching facility and date
      final bookingSnapshot = await FirebaseFirestore.instance
          .collection('booking')
          .where('facilityID', isEqualTo: facilityID)
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .get();

      bool overlaps(
          DateTime aStart, DateTime aEnd, DateTime bStart, DateTime bEnd) {
        return aStart.isBefore(bEnd) && aEnd.isAfter(bStart);
      }

      final selectedStart = DateTime(
        date.year,
        date.month,
        date.day,
        startTime.hour,
        startTime.minute,
      );
      final selectedEnd = selectedStart.add(Duration(hours: duration));

      final bookedCourtIDs = bookingSnapshot.docs
          .where((doc) {
            final data = doc.data();
            final bookedStart = (data['startTime'] as Timestamp).toDate();
            final bookedDuration = data['duration'] ?? 1;
            final bookedEnd = bookedStart.add(Duration(hours: bookedDuration));

            return overlaps(selectedStart, selectedEnd, bookedStart, bookedEnd);
          })
          .expand((doc) => List<Map<String, dynamic>>.from(doc['courts'] ?? [])
              .map((c) => c['courtID'] as String))
          .toSet();

      return allCourts
          .where((court) => !bookedCourtIDs.contains(court.courtID))
          .toList();
    } catch (e) {
      print('Error fetching available courts: $e');
      return [];
    }
  }

  Future<bool> isCourtAvailable(String facilityID, String courtID) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('facility')
        .doc(facilityID)
        .collection('court')
        .doc(courtID)
        .get();

    return snapshot.data()?['availability'] ?? true;
  }

  // Add/remove selected courts
  void addCourtToSelection(Court court) {
    if (!selectedCourts.contains(court)) {
      selectedCourts.add(court);
      print("Court added: ${court.courtName}");
      notifyListeners();
    }
  }

  void removeCourtFromSelection(Court court) {
    if (selectedCourts.remove(court)) {
      print("Court removed: ${court.courtName}");
      notifyListeners();
    }
  }

  /// Fetch rates for selected facility
  Future<void> _fetchFacilityRates(String facilityId) async {
    try {
      final feeSnapshot = await FirebaseFirestore.instance
          .collection('facility')
          .doc(facilityId)
          .collection('fee')
          .get();

      if (feeSnapshot.docs.isEmpty) {
        print('No fee data found.');
        return;
      }

      final data = feeSnapshot.docs.first.data();

      rates = {
        'weekdayRateBefore6': (data['weekdayRateBefore6'] ?? 0.0).toDouble(),
        'weekdayRateAfter6': (data['weekdayRateAfter6'] ?? 0.0).toDouble(),
        'weekendRateBefore6': (data['weekendRateBefore6'] ?? 0.0).toDouble(),
        'weekendRateAfter6': (data['weekendRateAfter6'] ?? 0.0).toDouble(),
      };

      print('Rates updated: $rates');
      notifyListeners();
    } catch (e) {
      print('Error fetching rates: $e');
    }
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    print("Selected date: $selectedDate");
    notifyListeners();
  }

  void setStartTime(DateTime time) {
    startTime = time;
    print("Start time: $startTime");
    notifyListeners();
  }

  void setDuration(int hours) {
    duration = hours;
    print("Duration: $duration hour(s)");
    notifyListeners();
  }
}
