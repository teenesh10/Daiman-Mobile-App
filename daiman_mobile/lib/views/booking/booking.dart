import 'package:daiman_mobile/models/facility.dart';
import 'package:daiman_mobile/controllers/booking_controller.dart';
import 'package:daiman_mobile/views/widgets/curved_widget.dart';
import 'package:daiman_mobile/views/widgets/facility_button.dart';
import 'package:daiman_mobile/views/widgets/heading.dart';
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
              height: 60, // Adjust height as needed
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
