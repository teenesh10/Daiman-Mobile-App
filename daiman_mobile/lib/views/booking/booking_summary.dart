import 'package:daiman_mobile/views/payment/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daiman_mobile/controllers/booking_controller.dart';
import 'package:daiman_mobile/controllers/payment_controller.dart';

class BookingSummaryPage extends StatelessWidget {
  const BookingSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentController = Provider.of<PaymentController>(context);
    final bookingController = Provider.of<BookingController>(context);
    final selectedFacility = bookingController.selectedFacility;
    final selectedDate = bookingController.selectedDate;
    final startTime = bookingController.startTime;
    final duration = bookingController.duration;
    final selectedCourts = bookingController.selectedCourts;

    if (selectedDate == null || startTime == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Booking Summary"),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: Text(
            "Error: Missing date or time. Please go back and select the required details.",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final totalAmount = paymentController.calculateTotalAmount(
      selectedCourts: selectedCourts,
      facilityRates: bookingController.rates,
      date: selectedDate,
      startTime: startTime,
      duration: duration,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking Summary",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Facility: ${selectedFacility?.facilityName ?? 'N/A'}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
                "Date: ${selectedDate.toLocal().toIso8601String().split('T')[0]}"),
            Text(
                "Time: ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}"),
            Text("Duration: ${duration} hours"),
            const SizedBox(height: 8),
            const Text(
              "Selected Courts:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...selectedCourts
                .map((court) => Text("- ${court.courtName}"))
                .toList(),
            const Spacer(),
            Text(
              "Total Amount: RM${totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentMethodPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text("Book Now"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
