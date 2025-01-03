import 'package:daiman_mobile/controllers/booking_controller.dart';
import 'package:daiman_mobile/models/court.dart';
import 'package:daiman_mobile/views/widgets/court_checkbox.dart';
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
          // Placeholder image under the AppBar
          Stack(
            children: [
              Image.network(
                'https://via.placeholder.com/400x200', // Placeholder image URL
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/live_availability');
                  },
                  child: const Text(
                    "View Live Availability",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
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
                  facilityID, date, startTime, duration),
              builder: (context, snapshot) {
                // Show loading indicator while fetching data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Show error if no data is available
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Show message if no courts are available
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No courts available for the selected time."),
                  );
                }

                // Extract available courts data from the snapshot
                final courts = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: courts.length,
                  itemBuilder: (context, index) {
                    final court = courts[index];
                    return CourtTile(
                      courtName: court.courtName,
                      isSelected: controller.selectedCourts.contains(court),
                      onChanged: (isSelected) {
                        if (isSelected == true) {
                          controller.addCourtToSelection(court);
                          print('Selected Court: ${court.courtName}');
                        } else {
                          controller.removeCourtFromSelection(court);
                          print('Removed Court: ${court.courtName}');
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
