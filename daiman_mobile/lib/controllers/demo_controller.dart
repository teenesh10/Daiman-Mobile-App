import 'package:daiman_mobile/demo_mode.dart';
import 'package:flutter/material.dart';

class DemoController {
  // Mock data for demo mode
  static const List<Map<String, dynamic>> mockFacilities = [
    {
      'facilityID': 'demo_facility_1',
      'facilityName': 'Demo Sports Center',
      'location': 'Demo Location',
      'imageUrl': 'assets/images/img1.jpg',
      'weekdayRateBefore6': 25.0,
      'weekdayRateAfter6': 35.0,
      'weekendRateBefore6': 30.0,
      'weekendRateAfter6': 40.0,
    },
    {
      'facilityID': 'demo_facility_2',
      'facilityName': 'Demo Court Complex',
      'location': 'Demo Area',
      'imageUrl': 'assets/images/img2.jpg',
      'weekdayRateBefore6': 20.0,
      'weekdayRateAfter6': 30.0,
      'weekendRateBefore6': 25.0,
      'weekendRateAfter6': 35.0,
    },
  ];

  static const List<Map<String, dynamic>> mockCourts = [
    {
      'courtID': 'demo_court_1',
      'courtName': 'Court A',
      'availability': true,
    },
    {
      'courtID': 'demo_court_2',
      'courtName': 'Court B',
      'availability': true,
    },
    {
      'courtID': 'demo_court_3',
      'courtName': 'Court C',
      'availability': false,
    },
  ];

  static const List<Map<String, dynamic>> mockBookings = [
    {
      'bookingID': 'demo_booking_1',
      'facilityName': 'Demo Sports Center',
      'courts': ['Court A'],
      'date': '2024-01-15',
      'startTime': '10:00',
      'duration': 2,
      'amountPaid': 50.0,
      'status': 'confirmed',
    },
    {
      'bookingID': 'demo_booking_2',
      'facilityName': 'Demo Court Complex',
      'courts': ['Court B'],
      'date': '2024-01-20',
      'startTime': '14:00',
      'duration': 1,
      'amountPaid': 30.0,
      'status': 'confirmed',
    },
  ];

  // Check if we should use demo data
  static Future<bool> shouldUseDemoData() async {
    return await DemoMode.isDemoMode();
  }

  // Get demo facilities
  static Future<List<Map<String, dynamic>>> getDemoFacilities() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return List.from(mockFacilities);
  }

  // Get demo courts for a facility
  static Future<List<Map<String, dynamic>>> getDemoCourts(String facilityID) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(mockCourts);
  }

  // Get demo bookings
  static Future<List<Map<String, dynamic>>> getDemoBookings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(mockBookings);
  }

  // Mock payment success
  static Future<Map<String, dynamic>> mockPaymentSuccess({
    required double amount,
    required String currency,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate payment processing
    
    return {
      'success': true,
      'paymentIntentId': 'demo_pi_${DateTime.now().millisecondsSinceEpoch}',
      'clientSecret': 'demo_client_secret_${DateTime.now().millisecondsSinceEpoch}',
      'amount': amount,
      'currency': currency,
    };
  }

  // Mock checkout session
  static Future<Map<String, dynamic>> mockCheckoutSession({
    required int amountSen,
    required String currency,
    required String paymentMethod,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      'success': true,
      'sessionUrl': 'https://demo-checkout.daiman.com/session_${DateTime.now().millisecondsSinceEpoch}',
    };
  }

  // Mock chatbot response
  static Future<String> mockChatbotResponse(String message) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Simple keyword-based responses for demo
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('booking') || lowerMessage.contains('reserve')) {
      return "In demo mode, you can explore the booking system! Navigate to the booking section to see how users can reserve courts and facilities.";
    } else if (lowerMessage.contains('payment') || lowerMessage.contains('pay')) {
      return "The demo includes a mock payment system. You can test the payment flow without using real payment methods.";
    } else if (lowerMessage.contains('facility') || lowerMessage.contains('court')) {
      return "We have multiple facilities available in the demo. Check out the different courts and their availability!";
    } else if (lowerMessage.contains('help') || lowerMessage.contains('support')) {
      return "This is a demo version of the Daiman Sports booking app. Feel free to explore all features including booking, payments, and user management!";
    } else {
      return "Thanks for your message! This is a demo version of our sports booking app. You can explore features like court booking, payment processing, and user management. How can I help you today?";
    }
  }

  // Show demo mode notification
  static void showDemoNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Demo Mode: This is a demonstration version'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
