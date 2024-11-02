import 'package:daiman_mobile/views/widgets/history_card.dart';
import 'package:flutter/material.dart';

class BookingHistoryTab extends StatelessWidget {
  final bool isUpcoming;

  const BookingHistoryTab({super.key, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    // Static data for demonstration
    final List<Map<String, String>> bookings = isUpcoming
        ? [
            {
              'facility': 'Tennis Court',
              'court': 'Court 1',
              'date': '2024-12-15',
              'startTime': '3:00 PM',
              'duration': '2 hours',
            },
            {
              'facility': 'Badminton Court',
              'court': 'Court 2',
              'date': '2024-12-18',
              'startTime': '5:00 PM',
              'duration': '1 hour',
            },
          ]
        : [
            {
              'facility': 'Soccer Field',
              'court': 'Field A',
              'date': '2024-10-10',
              'startTime': '7:00 PM',
              'duration': '2 hours',
            },
            {
              'facility': 'Basketball Court',
              'court': 'Court B',
              'date': '2024-10-12',
              'startTime': '8:00 PM',
              'duration': '1.5 hours',
            },
          ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return BookingCard(
            facility: booking['facility']!,
            court: booking['court']!,
            date: booking['date']!,
            startTime: booking['startTime']!,
            duration: booking['duration']!,
          );
        },
      ),
    );
  }
}
