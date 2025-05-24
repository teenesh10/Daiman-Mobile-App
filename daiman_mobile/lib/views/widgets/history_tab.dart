import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'history_card.dart';

class BookingHistoryTab extends StatelessWidget {
  final bool isUpcoming;

  const BookingHistoryTab({super.key, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('booking')
          .where('userID', isEqualTo: userId)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No bookings found.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        final now = DateTime.now();
        final bookings = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final startTime = (data['startTime'] as Timestamp).toDate();
          final duration = data['duration'] as int;
          final endTime = startTime.add(Duration(hours: duration));
          return isUpcoming ? endTime.isAfter(now) : endTime.isBefore(now);
        }).toList();

        if (bookings.isEmpty) {
          return Center(
            child: Text(
              isUpcoming ? 'No upcoming bookings.' : 'No past bookings.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final data = bookings[index].data() as Map<String, dynamic>;

            final courts = data['courts'] as List<dynamic>? ?? [];
            final court = courts.isNotEmpty
                ? courts.map((c) => c['courtName'] ?? 'Court').join(', ')
                : 'Court';
            final date = (data['date'] as Timestamp).toDate();
            final startTime = (data['startTime'] as Timestamp).toDate();
            final duration = '${data['duration']} hour(s)';
            final facilityID = data['facilityID'] as String? ?? '';

            final formattedStartTime = DateFormat.jm().format(startTime);

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('facility')
                  .doc(facilityID)
                  .get(),
              builder: (context, facilitySnapshot) {
                String facilityName = 'Facility';
                if (facilitySnapshot.connectionState == ConnectionState.done &&
                    facilitySnapshot.hasData &&
                    facilitySnapshot.data!.exists) {
                  final facilityData =
                      facilitySnapshot.data!.data() as Map<String, dynamic>?;
                  facilityName = facilityData?['facilityName'] ?? 'Facility';
                }

                return BookingCard(
                  facility: facilityName,
                  court: court,
                  date: date.toIso8601String().split('T')[0],
                  startTime: formattedStartTime,
                  duration: duration,
                );
              },
            );
          },
        );
      },
    );
  }
}
