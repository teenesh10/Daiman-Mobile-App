// ignore_for_file: library_private_types_in_public_api

import 'package:daiman_mobile/services/payment_service.dart';
import 'package:flutter/material.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = false;

  Future<void> handlePayment() async {
    setState(() {
      isLoading = true;
    });

    try {
      await createPaymentIntent(50.0, 'usd'); // Example: 50 USD
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment initiated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Screen')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: handlePayment,
                child: const Text('Pay Now'),
              ),
      ),
    );
  }
}
