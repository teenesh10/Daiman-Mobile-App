import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daiman_mobile/custom_snackbar.dart';
import 'package:daiman_mobile/views/payment/invoice.dart';
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
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

    final isAfter6PM = startTime.hour >= 18;

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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final totalAmountRM = calculateTotalAmount(
        selectedCourts: selectedCourts,
        facilityRates: facilityRates,
        date: date,
        startTime: startTime,
        duration: duration,
      );
      final totalAmountSen = (totalAmountRM * 100).round();

      final paymentIntentData = await createPaymentIntent(
        totalAmountSen.toString(),
        'MYR',
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['clientSecret'],
          merchantDisplayName: 'Daiman Sri Skudai Sport Centre',
          style: ThemeMode.light,
        ),
      );

      try {
        await Stripe.instance.presentPaymentSheet();

        final bookingID = await storeBookingToFirestore(
          selectedCourts: selectedCourts,
          date: date,
          startTime: startTime,
          duration: duration,
          facilityID: facilityID,
          paymentMethod: 'card',
          amountPaid: totalAmountRM,
        );

        Navigator.pop(context);

        CustomSnackBar.showSuccess(
          context,
          'Payment Successful!',
          'Your booking has been confirmed.',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => InvoicePage(bookingID: bookingID),
          ),
        );
      } on StripeException catch (e) {
        Navigator.pop(context);

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
        Navigator.pop(context);
        CustomSnackBar.showFailure(
          context,
          'Payment Error',
          e.toString(),
        );
      }
    } catch (e) {
      Navigator.pop(context);
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
        'amount': int.parse(amount),
        'currency': currency,
        'email': FirebaseAuth.instance.currentUser?.email,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
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

    final bookingID = bookingCollection.doc().id;
    final bookingRef = bookingCollection.doc(bookingID);

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

    batch.set(bookingRef, booking);

    for (final court in selectedCourts) {
      final courtRef = FirebaseFirestore.instance
          .collection('facility')
          .doc(facilityID)
          .collection('court')
          .doc(court.courtID);

      batch.update(courtRef, {
        'availability': false,
      });
    }

    await batch.commit();

    return bookingID;
  }
}
