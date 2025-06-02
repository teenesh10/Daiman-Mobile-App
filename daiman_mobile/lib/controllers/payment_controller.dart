import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daiman_mobile/custom_snackbar.dart';
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
    String facilityID,
    BuildContext context,
  ) async {
    try {
      // 1. Calculate total amount in sen (RM x 100)
      final totalAmountRM = calculateTotalAmount(
        selectedCourts: selectedCourts,
        facilityRates: facilityRates,
        date: date,
        startTime: startTime,
        duration: duration,
      );
      final totalAmountSen = (totalAmountRM * 100).round();

      // 2. Create payment intent
      final paymentIntentData = await createPaymentIntent(
        totalAmountSen.toString(),
        'MYR',
      );

      // 3. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['clientSecret'],
          merchantDisplayName: 'Daiman Sri Skudai Sport Centre',
          style: ThemeMode.light,
        ),
      );

      // 4. Present payment sheet
      try {
        await Stripe.instance.presentPaymentSheet();

        // 5. Store bookings in Firestore after success
        await storeBookingToFirestore(
          selectedCourts: selectedCourts,
          date: date,
          startTime: startTime,
          duration: duration,
          facilityID: facilityID,
          paymentMethod: 'card',
          amountPaid: totalAmountRM,
        );

        // 6. Show success snackbar
        CustomSnackBar.showSuccess(
          context,
          'Payment Successful!',
          'Your booking has been confirmed.',
        );

        // 7. Redirect to booking history page
        Navigator.pushReplacementNamed(context, '/history');
      } on StripeException catch (e) {
        if (e.error.code == FailureCode.Canceled) {
          CustomSnackBar.showFailure(
            context,
            'Payment Cancelled',
            'You cancelled the payment.',
          );
        } else {
          CustomSnackBar.showFailure(
            context,
            'Payment Failed',
            e.error.localizedMessage ?? 'Something went wrong.',
          );
        }
      } catch (e) {
        CustomSnackBar.showFailure(
          context,
          'Payment Error',
          e.toString(),
        );
      }
    } catch (e) {
      CustomSnackBar.showFailure(
        context,
        'Error',
        e.toString(),
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

  Future<String?> createCheckoutSession({
    required int amountSen,
    required String currency,
    required String paymentMethod,
  }) async {
    final response = await http.post(
      Uri.parse('https://createcheckoutsession-d7u4qgi7fa-uc.a.run.app'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'amount': amountSen,
        'currency': currency,
        'email': FirebaseAuth.instance.currentUser?.email,
        'paymentMethod': paymentMethod,
      }),
    );

    if (response.statusCode == 200) {
      final url = jsonDecode(response.body)['sessionUrl'];
      return url;
    } else {
      return null;
    }
  }

  Future<String> storeBookingToFirestore({
    required String facilityID,
    required List<Court> selectedCourts,
    required DateTime date,
    required DateTime startTime,
    required int duration,
    required String paymentMethod,
    required double amountPaid,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final bookingCollection = FirebaseFirestore.instance.collection('booking');
    final batch = FirebaseFirestore.instance.batch();

    // 1. Generate booking ID
    final bookingID = bookingCollection.doc().id;
    final bookingRef = bookingCollection.doc(bookingID);

    // 2. Prepare booking data
    final booking = {
      'bookingID': bookingID,
      'userID': user!.uid,
      'facilityID': facilityID,
      'courts': selectedCourts
          .map((court) => {
                'courtID': court.courtID,
                'courtName': court.courtName,
              })
          .toList(),
      'date': Timestamp.fromDate(date),
      'startTime': Timestamp.fromDate(startTime),
      'duration': duration,
      'bookingMade': Timestamp.now(),
      'paymentMethod': paymentMethod,
      'amountPaid': amountPaid,
    };

    // 3. Add booking to Firestore
    batch.set(bookingRef, booking);

    // 4. Update court availability status
    for (final court in selectedCourts) {
      final courtRef = FirebaseFirestore.instance
          .collection('facility')
          .doc(facilityID)
          .collection('court')
          .doc(court.courtID);

      batch.update(courtRef, {
        'availability': false, // Mark court as unavailable
      });
    }

    // 5. Commit all changes as a batch
    await batch.commit();

    return bookingID;
  }
}
