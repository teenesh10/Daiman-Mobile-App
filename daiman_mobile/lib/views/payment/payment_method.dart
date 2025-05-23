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

  void _handlePayNow() {
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
    }

    // FPX / GrabPay WebView will be added later
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
      appBar: AppBar(title: const Text("Select Payment Method")),
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
