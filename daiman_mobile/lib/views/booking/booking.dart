import 'package:daiman_mobile/models/facility.dart';
import 'package:daiman_mobile/controllers/booking_controller.dart';
import 'package:daiman_mobile/views/booking/court_list.dart';
import 'package:daiman_mobile/views/widgets/calendar.dart';
import 'package:daiman_mobile/views/widgets/curved_widget.dart';
import 'package:daiman_mobile/views/widgets/duration_picker.dart';
import 'package:daiman_mobile/views/widgets/facility_button.dart';
import 'package:daiman_mobile/views/widgets/heading.dart';
import 'package:daiman_mobile/views/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? selectedDuration;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BookingController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  height: 50,
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
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
                    Provider.of<BookingController>(context, listen: false)
                        .setSelectedDate(date);
                    print("Selected Date: $formattedDate"); // Debug log
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
                    onTimeSelected: (time) {
                      setState(() {
                        selectedTime = time;
                      });
                      final startTime = DateTime(
                        selectedDate?.year ?? DateTime.now().year,
                        selectedDate?.month ?? DateTime.now().month,
                        selectedDate?.day ?? DateTime.now().day,
                        time.hour,
                        time.minute,
                      );
                      Provider.of<BookingController>(context, listen: false)
                          .setStartTime(startTime);
                      print(
                          "Selected Time: ${time.format(context)}"); // Debug log
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
                DurationSelector(
                  onDurationSelected: (duration) {
                    setState(() {
                      selectedDuration = duration;
                    });
                    Provider.of<BookingController>(context, listen: false)
                        .setDuration(duration);
                  },
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.selectedFacility != null &&
                                selectedDate != null &&
                                selectedTime != null &&
                                selectedDuration != null) {
                              final startTime = DateTime(
                                selectedDate!.year,
                                selectedDate!.month,
                                selectedDate!.day,
                                selectedTime!.hour,
                                selectedTime!.minute,
                              );

                              // Set values in the BookingController
                              controller.setSelectedDate(selectedDate!);
                              controller.setStartTime(startTime);
                              controller.setDuration(selectedDuration!);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourtListPage(
                                    facilityID:
                                        controller.selectedFacility!.facilityID,
                                    date: selectedDate!,
                                    startTime: startTime,
                                    duration: selectedDuration!,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(_getValidationMessage()),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text(
                            "Check Availability",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
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
        ],
      ),
    );
  }

  String _getValidationMessage() {
    if (selectedDate == null) return "Please select a date.";
    if (selectedTime == null) {
      print("Selected Time is null: $selectedTime"); // Debugging log
      return "Please select a time.";
    }
    if (selectedDuration == null) return "Please select a duration.";
    if (Provider.of<BookingController>(context, listen: false)
            .selectedFacility ==
        null) {
      return "Please select a facility.";
    }
    return "Validation passed.";
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
