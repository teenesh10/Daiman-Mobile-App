import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daiman_mobile/models/court.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentController with ChangeNotifier {
  double calculateTotalAmount({
    required List<Court> selectedCourts,
    required Map<String, double> facilityRates,
    required DateTime date,
    required DateTime startTime,
    required int duration,
  }) {
    // Determine if it's a weekday or weekend
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

    // Determine if the time is before or after 6 PM
    final isAfter6PM = startTime.hour >= 18;

    // Determine the rate type
    late double rate;
    if (isWeekend) {
      rate = isAfter6PM
          ? facilityRates['weekendRateAfter6'] ?? 0.0
          : facilityRates['weekendRateBefore6'] ?? 0.0;
    } else {
      rate = isAfter6PM
          ? facilityRates['weekdayRateAfter6'] ?? 0.0
          : facilityRates['weekdayRateBefore6'] ?? 0.0;
    }

    // Calculate total cost
    final total = selectedCourts.length * rate * duration;
    return total;
  }

  Future<void> makePayment(
      List<Court> selectedCourts,
      Map<String, double> facilityRates,
      DateTime date,
      DateTime startTime,
      int duration,
      BuildContext context) async {
    try {
      // Calculate the total amount
      final totalAmountRM = calculateTotalAmount(
        selectedCourts: selectedCourts,
        facilityRates: facilityRates,
        date: date,
        startTime: startTime,
        duration: duration,
      );

      // Convert to cents (sen in Malaysia)
      final totalAmountSen = (totalAmountRM * 100).round();

      // Create PaymentIntent
      final paymentIntentData =
          await createPaymentIntent(totalAmountSen.toString(), 'MYR');

      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['clientSecret'],
          merchantDisplayName: 'Daiman Sri Skudai Sport Centre',
          style: ThemeMode.light,
        ),
      );

      // Show the payment sheet
      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Successful!')),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Failed: $e')),
      );
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    final response = await http.post(
      Uri.parse('https://createpaymentintent-d7u4qgi7fa-uc.a.run.app'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        // <-- dynamic instead of String
        'amount': int.parse(amount), // Convert amount string to integer
        'currency': currency,
        'email': FirebaseAuth.instance.currentUser?.email,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to create payment intent: ${response.body}');
      throw Exception('Failed to create payment intent');
    }
  }
}
