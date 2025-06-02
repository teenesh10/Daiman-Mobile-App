import 'package:daiman_mobile/custom_snackbar.dart';
import 'package:daiman_mobile/views/payment/checkout_page.dart';
import 'package:daiman_mobile/views/payment/invoice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daiman_mobile/controllers/payment_controller.dart';
import 'package:daiman_mobile/controllers/booking_controller.dart';

enum PaymentMethod { card, fpx, grabpay }

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  PaymentMethod? _selectedMethod;

  void _selectMethod(PaymentMethod method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  void _handlePayNow() async {
    final paymentController =
        Provider.of<PaymentController>(context, listen: false);
    final bookingController =
        Provider.of<BookingController>(context, listen: false);

    final selectedCourts = bookingController.selectedCourts;
    final rates = bookingController.rates;
    final date = bookingController.selectedDate;
    final startTime = bookingController.startTime;
    final duration = bookingController.duration;
    final selectedFacility = bookingController.selectedFacility;

    if (_selectedMethod == PaymentMethod.card) {
      paymentController.makePayment(
        selectedCourts,
        rates,
        date!,
        startTime!,
        duration,
        selectedFacility?.facilityID ?? '',
        context,
      );
    } else if (_selectedMethod == PaymentMethod.fpx ||
        _selectedMethod == PaymentMethod.grabpay) {
      final paymentMethodStr =
          _selectedMethod == PaymentMethod.fpx ? 'fpx' : 'grabpay';

      final totalSen = (paymentController.calculateTotalAmount(
                selectedCourts: selectedCourts,
                facilityRates: rates,
                date: date!,
                startTime: startTime!,
                duration: duration,
              ) *
              100)
          .round();

      final sessionUrl = await paymentController.createCheckoutSession(
        amountSen: totalSen,
        currency: 'MYR',
        paymentMethod: paymentMethodStr,
      );

      if (sessionUrl != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CheckoutWebViewPage(checkoutUrl: sessionUrl),
          ),
        );

        if (result == true) {
          final bookingID = await paymentController.storeBookingToFirestore(
            selectedCourts: selectedCourts,
            date: date,
            startTime: startTime,
            duration: duration,
            facilityID: selectedFacility?.facilityID ?? '',
            paymentMethod: paymentMethodStr,
            amountPaid: totalSen / 100, // convert back to RM
          );

          CustomSnackBar.showSuccess(
            context,
            'Payment Successful',
            'Your booking is confirmed.',
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => InvoicePage(bookingID: bookingID),
            ),
          );
        } else {
          CustomSnackBar.showFailure(
            context,
            'Payment Cancelled',
            'You cancelled the payment.',
          );
        }
      } else {
        CustomSnackBar.showFailure(
          context,
          'Session Error',
          'Could not start checkout session.',
        );
      }
    }
  }

  Widget _buildPaymentOption(
      PaymentMethod method, String imagePath, String label) {
    final isSelected = _selectedMethod == method;

    return GestureDetector(
      onTap: () => _selectMethod(method),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.blueAccent : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Payment Method",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: [
                  _buildPaymentOption(PaymentMethod.card,
                      'assets/images/cards.png', 'Pay with Card'),
                  _buildPaymentOption(PaymentMethod.fpx,
                      'assets/images/fpx.png', 'Pay with FPX'),
                  _buildPaymentOption(PaymentMethod.grabpay,
                      'assets/images/grab.png', 'Pay with GrabPay'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedMethod == null ? null : _handlePayNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Pay Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
