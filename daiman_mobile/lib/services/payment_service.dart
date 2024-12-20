import 'package:cloud_functions/cloud_functions.dart';

Future<void> createPaymentIntent(double amount, String currency) async {
  final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createPaymentIntent');
  
  final response = await callable({
    'amount': (amount * 100).toInt(), // Convert to cents
    'currency': currency,
  });

  final clientSecret = response.data['clientSecret'];
  print('Client Secret: $clientSecret');
}
