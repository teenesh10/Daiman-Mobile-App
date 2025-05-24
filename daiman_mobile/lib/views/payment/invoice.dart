import 'package:daiman_mobile/navbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class InvoicePage extends StatefulWidget {
  final String bookingID;

  const InvoicePage({required this.bookingID, Key? key}) : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  DocumentSnapshot? bookingData;
  String? facilityName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  Future<void> _loadBooking() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('booking')
          .doc(widget.bookingID)
          .get();

      if (!doc.exists) {
        setState(() {
          bookingData = null;
          isLoading = false;
        });
        return;
      }

      final data = doc.data() as Map<String, dynamic>;

      // Fetch facility name from facilityID
      final facilityDoc = await FirebaseFirestore.instance
          .collection('facility')
          .doc(data['facilityID'])
          .get();

      setState(() {
        bookingData = doc;
        facilityName = facilityDoc.exists
            ? facilityDoc['facilityName'] ?? 'Unknown Facility'
            : 'Unknown Facility';
        isLoading = false;
      });
    } catch (e) {
      // Handle error gracefully
      setState(() {
        bookingData = null;
        isLoading = false;
      });
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
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

    final courts =
        (data['courts'] as List<dynamic>).cast<Map<String, dynamic>>();
    final date = (data['date'] as Timestamp).toDate();
    final startTime = (data['startTime'] as Timestamp).toDate();
    final duration = data['duration'];
    final paymentMethod = data['paymentMethod'];
    final amountPaid = data['amountPaid'];

    return PopScope(
      canPop: false, // Disable back button
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Booking Invoice"),
          centerTitle: true,
          automaticallyImplyLeading: false, // no back button
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking ID',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(widget.bookingID,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          const Divider(height: 24, thickness: 1),
                          Text(
                            'Facility',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(facilityName ?? 'Loading...',
                              style: const TextStyle(fontSize: 14)),
                          const Divider(height: 24, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _labelValue('Date', formatDate(date)),
                              _labelValue('Start Time', formatTime(startTime)),
                              _labelValue('Duration', '$duration hours'),
                            ],
                          ),
                          const Divider(height: 24, thickness: 1),
                          Text(
                            'Courts Booked',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          ...courts.map(
                            (court) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '- ${court['courtName'] ?? court['courtID']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const Divider(height: 24, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _labelValue('Payment Method',
                                  paymentMethod.toString().toUpperCase()),
                              _labelValue('Amount Paid',
                                  'RM ${amountPaid.toStringAsFixed(2)}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Screenshot reminder text
              Text(
                'Please screenshot the invoice as proof to show if you have any problem with your booking.',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Confirm button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const NavBarWrapper(initialIndex: 2),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Confirm', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
