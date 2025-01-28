import 'package:daiman_mobile/controllers/booking_controller.dart';
import 'package:daiman_mobile/models/court.dart';
import 'package:daiman_mobile/views/widgets/court_checkbox.dart';
import 'package:daiman_mobile/views/widgets/price_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourtListPage extends StatelessWidget {
  final String facilityID;
  final DateTime date;
  final DateTime startTime;
  final int duration;

  const CourtListPage({
    super.key,
    required this.facilityID,
    required this.date,
    required this.startTime,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BookingController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Courts"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Consumer<BookingController>(
                  builder: (context, controller, child) {
                    if (controller.rates.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return PricingInfoBox(
                      facilityName:
                          controller.selectedFacility?.facilityName ?? '',
                      weekdayRateBefore6:
                          controller.rates['weekdayRateBefore6'] ?? 0.0,
                      weekdayRateAfter6:
                          controller.rates['weekdayRateAfter6'] ?? 0.0,
                      weekendRateBefore6:
                          controller.rates['weekendRateBefore6'] ?? 0.0,
                      weekendRateAfter6:
                          controller.rates['weekendRateAfter6'] ?? 0.0,
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                right: 25,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/live_availability');
                  },
                  child: const Text(
                    "View Live Availability",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Padding between image and court list
          Expanded(
            child: FutureBuilder<List<Court>>(
              future: controller.fetchAvailableCourts(
                facilityID,
                date,
                startTime,
                duration,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No courts available for the selected time."),
                  );
                }

                final courts = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: courts.length,
                  itemBuilder: (context, index) {
                    final court = courts[index];
                    final isSelected =
                        controller.selectedCourts.contains(court);

                    return CourtTile(
                      courtName: court.courtName,
                      isSelected: isSelected,
                      onChanged: (isSelected) {
                        if (isSelected) {
                          controller.addCourtToSelection(court);
                        } else {
                          controller.removeCourtFromSelection(court);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Confirm Selection button at the bottom
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: ElevatedButton(
              onPressed: controller.selectedCourts.isEmpty
                  ? null
                  : () {
                      // Handle confirm action
                      Navigator.pop(context, controller.selectedCourts);
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blueAccent,
              ),
              child: const Center(
                child: Text(
                  "Confirm Selection",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
