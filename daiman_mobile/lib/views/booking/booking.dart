import 'package:daiman_mobile/constants.dart';
import 'package:daiman_mobile/custom_snackbar.dart';
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
    Provider.of<BookingController>(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShapeWidget(
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/img1.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SectionHeading(
                    title: "Type of Sport",
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
                          itemCount: controller.facilities.length,
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
                    Provider.of<BookingController>(context, listen: false)
                        .setSelectedDate(date);
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

                      final isLateNightBooking = time.hour < 2;
                      final adjustedStartDate = isLateNightBooking
                          ? selectedDate?.add(const Duration(days: 1))
                          : selectedDate;

                      final selectedDateTime = DateTime(
                        adjustedStartDate?.year ?? DateTime.now().year,
                        adjustedStartDate?.month ?? DateTime.now().month,
                        adjustedStartDate?.day ?? DateTime.now().day,
                        time.hour,
                        time.minute,
                      );

                      Provider.of<BookingController>(context, listen: false)
                          .setStartTime(selectedDateTime);
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
                            final errorMessage = _validateInputs();
                            if (errorMessage != null) {
                              CustomSnackBar.showFailure(
                                  context, "Error", errorMessage);
                              return;
                            }

                            final controller = Provider.of<BookingController>(
                                context,
                                listen: false);
                            final selectedFacility =
                                controller.selectedFacility!;
                            final selectedDate = controller.selectedDate;
                            final selectedTime = controller.startTime;
                            final selectedDuration = controller.duration;

                            if (controller.rates.isEmpty ||
                                controller.rates.values
                                    .every((rate) => rate == 0.0)) {
                              CustomSnackBar.showFailure(context, "Unavailable",
                                  "Selected facility is not available.");
                              return;
                            }

                            final isLateNightBooking = selectedTime.hour < 2;
                            final adjustedStartDate = isLateNightBooking
                                ? selectedDate.add(const Duration(days: 1))
                                : selectedDate;

                            final startTime = DateTime(
                              adjustedStartDate.year,
                              adjustedStartDate.month,
                              adjustedStartDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );

                            // These setters might not be necessary unless you're using them later
                            controller.setSelectedDate(selectedDate);
                            controller.setStartTime(startTime);
                            controller.setDuration(selectedDuration);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourtListPage(
                                  facilityID: selectedFacility.facilityID,
                                  date: selectedDate,
                                  startTime: startTime,
                                  duration: selectedDuration,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text(
                            "Check Availability",
                            textAlign: TextAlign.center,
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

  String? _validateInputs() {
    final bookingController =
        Provider.of<BookingController>(context, listen: false);

    final now = DateTime.now();
    const facilityOpenHour = 8;
    const facilityCloseHour = 2;

    final selectedFacility = bookingController.selectedFacility;
    final selectedDate = bookingController.selectedDate;
    final selectedTime = bookingController.startTime;
    final selectedDuration = bookingController.duration;

    if (selectedFacility == null) {
      return "Please select a facility.";
    }

    final isLateNightBooking = selectedTime.hour < facilityCloseHour;
    final adjustedStartDate = isLateNightBooking
        ? selectedDate.add(const Duration(days: 1))
        : selectedDate;

    final selectedDateTime = DateTime(
      adjustedStartDate.year,
      adjustedStartDate.month,
      adjustedStartDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final endDateTime = selectedDateTime.add(Duration(hours: selectedDuration));

    final openTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      facilityOpenHour,
      0,
    );

    final closeTime = DateTime(
      selectedDate.add(const Duration(days: 1)).year,
      selectedDate.add(const Duration(days: 1)).month,
      selectedDate.add(const Duration(days: 1)).day,
      facilityCloseHour,
      0,
    );

    if (selectedDateTime.isBefore(now)) {
      return "Start time cannot be in the past.";
    }

    if (selectedDateTime.isBefore(openTime)) {
      return "Facility opens at 8:00 AM.";
    }

    if (endDateTime.isAfter(closeTime)) {
      return "Facility's closing time is 2:00 AM.";
    }

    return null;
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
