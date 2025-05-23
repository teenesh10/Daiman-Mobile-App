import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvoicePage extends StatefulWidget {
  final String bookingID;

  const InvoicePage({required this.bookingID, Key? key}) : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  DocumentSnapshot? bookingData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  Future<void> _loadBooking() async {
    final doc = await FirebaseFirestore.instance
        .collection('booking')
        .doc(widget.bookingID)
        .get();

    setState(() {
      bookingData = doc;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (bookingData == null || !bookingData!.exists) {
      return Scaffold(
        body: Center(child: Text('Booking not found')),
      );
    }

    final data = bookingData!.data() as Map<String, dynamic>;

    final courts = (data['courts'] as List<dynamic>).cast<Map<String, dynamic>>();
    final date = (data['date'] as Timestamp).toDate();
    final startTime = (data['startTime'] as Timestamp).toDate();
    final duration = data['duration'];
    final paymentMethod = data['paymentMethod'];
    final amountPaid = data['amountPaid'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        automaticallyImplyLeading: false, // no back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking ID: ${widget.bookingID}', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Text('Facility ID: ${data['facilityID']}'),
            const SizedBox(height: 8),

            Text('Date: ${date.toLocal().toString().split(' ')[0]}'),
            Text('Start Time: ${startTime.toLocal().hour}:${startTime.toLocal().minute.toString().padLeft(2, '0')}'),
            Text('Duration: $duration hours'),
            const SizedBox(height: 16),

            Text('Courts Booked:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...courts.map((court) => Text('- ${court['courtName'] ?? court['courtID']}')),
            const SizedBox(height: 16),

            Text('Payment Method: ${paymentMethod.toUpperCase()}'),
            Text('Amount Paid: RM ${amountPaid.toStringAsFixed(2)}'),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/history');
                },
                child: const Text('Confirm'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
