import 'package:flutter/material.dart';

class PricingInfoBox extends StatelessWidget {
  final String facilityName;
  final double weekdayRateBefore6;
  final double weekdayRateAfter6;
  final double weekendRateBefore6;
  final double weekendRateAfter6;

  const PricingInfoBox({
    required this.facilityName,
    required this.weekdayRateBefore6,
    required this.weekdayRateAfter6,
    required this.weekendRateBefore6,
    required this.weekendRateAfter6,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Daiman Sri Skudai Sport Center $facilityName Court",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Weekday Rates:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("Monday - Friday"),
          const Text("08:00am - 06:00pm"),
          Text("Price: RM $weekdayRateBefore6 / hr"),
          const SizedBox(height: 8),
          const Text("06:00pm - 01:00am"),
          Text("Price: RM $weekdayRateAfter6 / hr"),
          const SizedBox(height: 16),
          const Text(
            "Weekend Rates:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("Saturday & Sunday"),
          const Text("08:00am - 06:00pm"),
          Text("Price: RM $weekendRateBefore6 / hr"),
          const SizedBox(height: 8),
          const Text("06:00pm - 01:00am"),
          Text("Price: RM $weekendRateAfter6 / hr"),
        ],
      ),
    );
  }
}
