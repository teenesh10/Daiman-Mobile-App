import 'package:daiman_mobile/controllers/booking_controller.dart';
import 'package:daiman_mobile/controllers/payment_controller.dart';
import 'package:daiman_mobile/models/court.dart';
import 'package:daiman_mobile/views/booking/booking_summary.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Courts"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price Information and Live Availability Link
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
                    Navigator.pushNamed(
                      context,
                      '/live',
                      arguments: {
                        'facilityID': facilityID,
                        'date': date,
                      },
                    );
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
          const SizedBox(height: 16),

          // Court Selection List
          Expanded(
            child: Consumer<BookingController>(
              builder: (context, controller, child) {
                return FutureBuilder<List<Court>>(
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
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                controller.fetchAvailableCourts(
                                  facilityID,
                                  date,
                                  startTime,
                                  duration,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "No courts available for the selected time. Please try a different time or date.",
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    final courts = snapshot.data!;
                    courts.sort((a, b) => a.courtName.compareTo(b.courtName));

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
                );
              },
            ),
          ),

          // Confirm Button
          Consumer<BookingController>(
            builder: (context, controller, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: controller.selectedCourts.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (_) => PaymentController(),
                                child: const BookingSummaryPage(),
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: controller.selectedCourts.isEmpty
                        ? Colors.grey
                        : Colors.blueAccent,
                  ),
                  child: Center(
                    child: Text(
                      controller.selectedCourts.isEmpty
                          ? "Select Courts to Continue"
                          : "Confirm Selection (${controller.selectedCourts.length})",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
