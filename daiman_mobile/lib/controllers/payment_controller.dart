import 'package:flutter/material.dart';
import 'package:daiman_mobile/models/court.dart';

class PaymentController with ChangeNotifier {
  double calculateTotalAmount({
    required List<Court> selectedCourts,
    required Map<String, double> facilityRates,
    required DateTime date,
    required DateTime startTime,
    required int duration,
  }) {
    // Determine if it's a weekday or weekend
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

    // Determine if the time is before or after 6 PM
    final isAfter6PM = startTime.hour >= 18;

    // Determine the rate type
    late double rate;
    if (isWeekend) {
      rate = isAfter6PM
          ? facilityRates['weekendRateAfter6'] ?? 0.0
          : facilityRates['weekendRateBefore6'] ?? 0.0;
    } else {
      rate = isAfter6PM
          ? facilityRates['weekdayRateAfter6'] ?? 0.0
          : facilityRates['weekdayRateBefore6'] ?? 0.0;
    }

    // Calculate total cost
    final total = selectedCourts.length * rate * duration;
    return total;
  }
}
