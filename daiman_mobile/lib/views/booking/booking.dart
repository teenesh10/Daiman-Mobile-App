import 'package:daiman_mobile/models/facility.dart';
import 'package:daiman_mobile/controllers/booking_controller.dart';
import 'package:daiman_mobile/views/widgets/calendar.dart';
import 'package:daiman_mobile/views/widgets/curved_widget.dart';
import 'package:daiman_mobile/views/widgets/duration_picker.dart';
import 'package:daiman_mobile/views/widgets/facility_button.dart';
import 'package:daiman_mobile/views/widgets/heading.dart';
import 'package:daiman_mobile/views/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<BookingController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomShapeWidget(
              child: Container(
                color: Colors.blueAccent,
                height: 200,
                child: const Center(
                  child: Text(
                    'Image Here',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SectionHeading(
                title: "Type of Sport",
                showActionButton: true,
                onPressed: () {
                  Navigator.pushNamed(context, '/facilitylist');
                },
                headingStyle: 'small',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50, // Adjust height as needed
              child: Consumer<BookingController>(
                builder: (context, controller, child) {
                  if (controller.facilities.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.facilities.length > 3
                          ? 3
                          : controller.facilities.length,
                      itemBuilder: (context, index) {
                        final facility = controller.facilities[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: _buildFacilityButton(
                            context: context,
                            facility: facility,
                            isSelected:
                                controller.selectedFacility?.facilityID ==
                                    facility.facilityID,
                            onPressed: () {
                              controller.selectFacility(facility);
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: SectionHeading(
                title: "Date",
                showActionButton: false,
                headingStyle: 'small',
              ),
            ),
            BookingCalendar(
              onDateSelected: (selectedDate) {
                // Handle the selected date here
                // print("Selected date: $selectedDate");
              },
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: SectionHeading(
                title: "Time",
                showActionButton: false,
                headingStyle: 'small',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TimePickerSpinner(
                onTimeSelected: (selectedTime) {
                  // print("Selected time: $selectedTime");
                },
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: SectionHeading(
                title: "Duration",
                showActionButton: false,
                headingStyle: 'small',
              ),
            ),
            const SizedBox(height: 20),
            const DurationSelector(), // Use the DurationSelector widget
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle search courts action here
                        // print("Search courts button pressed");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Background color
                        padding: const EdgeInsets.symmetric(
                            vertical: 15), // Button height
                        textStyle: const TextStyle(fontSize: 16), // Text style
                      ),
                      child: const Text(
                        "Check Availability",
                        textAlign: TextAlign.center, // Center the text
                        style: TextStyle(
                            color: Colors.white), // Set text color to white
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityButton({
    required BuildContext context,
    required Facility facility,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return FacilityButton(
      facilityName: facility.facilityName,
      isSelected: isSelected,
      onPressed: onPressed,
    );
  }
}
