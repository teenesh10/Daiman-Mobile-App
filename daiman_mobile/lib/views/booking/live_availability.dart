import 'package:daiman_mobile/controllers/booking_controller.dart';
import 'package:daiman_mobile/models/timeslot.dart';
import 'package:daiman_mobile/views/widgets/horizontal_scroll.dart';
import 'package:daiman_mobile/views/widgets/vertical_scroll.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LiveAvailabilityPage extends StatelessWidget {
  final String facilityId;

  const LiveAvailabilityPage({super.key, required this.facilityId});

  @override
  Widget build(BuildContext context) {
    final bookingController = Provider.of<BookingController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Live Availability")),
      body: FutureBuilder(
        future: bookingController.fetchCourts(facilityId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final timeslots = Timeslot.getTimeslots();
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: VerticalScroll(timeslots: timeslots),
                ),
                Expanded(
                  flex: 3,
                  child: HorizontalScroll(courts: bookingController.courts),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
