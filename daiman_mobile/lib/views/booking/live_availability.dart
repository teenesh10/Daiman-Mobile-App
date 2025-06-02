import 'package:daiman_mobile/controllers/booking_controller.dart';
import 'package:daiman_mobile/models/court.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveAvailabilityPage extends StatefulWidget {
  final String facilityID;
  final DateTime date;

  const LiveAvailabilityPage({
    super.key,
    required this.facilityID,
    required this.date,
  });

  @override
  State<LiveAvailabilityPage> createState() => _LiveAvailabilityPageState();
}

class _LiveAvailabilityPageState extends State<LiveAvailabilityPage> {
  static const int timeslotIntervalMinutes = 30;
  late DateTime selectedDate;
  List<TimeOfDay> timeslots = [];
  List<Court> courts = [];
  bool isLoadingCourts = true;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.date;
    timeslots = _generateTimeslots();
    _loadCourts();
  }

  Future<void> _loadCourts() async {
    setState(() => isLoadingCourts = true);
    final bookingController =
        Provider.of<BookingController>(context, listen: false);
    courts = await bookingController.fetchCourts(widget.facilityID);
    courts.sort((a, b) => a.courtName.compareTo(b.courtName));
    setState(() => isLoadingCourts = false);
  }

  DateTime _getNextHalfHourSlot(DateTime time) {
    final minute = time.minute;
    final nextHalfHour = minute < 30
        ? DateTime(time.year, time.month, time.day, time.hour, 30)
        : DateTime(time.year, time.month, time.day, time.hour + 1, 0);
    return nextHalfHour;
  }

  List<TimeOfDay> _generateTimeslots() {
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    final List<TimeOfDay> slots = [];

    TimeOfDay current = const TimeOfDay(hour: 8, minute: 0);
    const int interval = timeslotIntervalMinutes;

    if (isToday) {
      final nextSlot = _getNextHalfHourSlot(now);
      current = TimeOfDay(hour: nextSlot.hour, minute: nextSlot.minute);
    }

    while (true) {
      slots.add(current);

      if (current.hour == 2 && current.minute == 0) {
        break;
      }

      current = _addMinutesToTimeOfDay(current, interval);

      if (slots.length > 100) break;
    }

    print('Final slots count: ${slots.length}');
    return slots;
  }

  TimeOfDay _addMinutesToTimeOfDay(TimeOfDay time, int minutesToAdd) {
    final totalMinutes = time.hour * 60 + time.minute + minutesToAdd;
    final newHour = (totalMinutes ~/ 60) % 24;
    final newMinute = totalMinutes % 60;
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  bool _isCourtAvailable(
    Court court,
    TimeOfDay time,
    List<QueryDocumentSnapshot> bookings,
  ) {
    final selectedTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      time.hour,
      time.minute,
    );

    final slotEnd = selectedTime.add(const Duration(minutes: 30));

    for (var booking in bookings) {
      final data = booking.data() as Map<String, dynamic>;
      final courtsBooked =
          List<Map<String, dynamic>>.from(data['courts'] ?? []);

      if (courtsBooked.any((c) => c['courtID'] == court.courtID)) {
        final start = (data['startTime'] as Timestamp).toDate();
        final duration = data['duration'] ?? 1;
        final end = start.add(Duration(hours: duration));

        if (start.isBefore(slotEnd) && end.isAfter(selectedTime)) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTimeslots = timeslots;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Live Availability",
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildLegendBox(Colors.green, 'Available'),
                const SizedBox(width: 16),
                _buildLegendBox(Colors.red, 'Booked'),
              ],
            ),
          ),
          Expanded(
            child: isLoadingCourts
                ? const Center(child: CircularProgressIndicator())
                : courts.isEmpty
                    ? const Center(child: Text("No courts found"))
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('booking')
                            .where('facilityID', isEqualTo: widget.facilityID)
                            .where('date',
                                isEqualTo: Timestamp.fromDate(selectedDate))
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final bookings = snapshot.data?.docs ?? [];

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                columnSpacing: 0,
                                headingRowHeight: 40,
                                dataRowMinHeight: 40,
                                columns: [
                                  const DataColumn(label: Text("Time")),
                                  ...courts.map(
                                    (court) => DataColumn(
                                      label: SizedBox(
                                        width: 80,
                                        child: Text(
                                          court.courtName,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List.generate(
                                  (filteredTimeslots.length / 2).ceil(),
                                  (index) {
                                    final time1 = filteredTimeslots[index * 2];
                                    final time2 = (index * 2 + 1 <
                                            filteredTimeslots.length)
                                        ? filteredTimeslots[index * 2 + 1]
                                        : null;

                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          SizedBox(
                                            width: 80,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(_formatTimeOfDay(time1)),
                                                if (time2 != null)
                                                  Text(_formatTimeOfDay(time2)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ...courts.map((court) {
                                          final available1 = _isCourtAvailable(
                                              court, time1, bookings);
                                          final available2 = time2 != null
                                              ? _isCourtAvailable(
                                                  court, time2, bookings)
                                              : true;

                                          return DataCell(
                                            Container(
                                              width: 80,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey.shade300,
                                                    width: 0.5),
                                              ),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      color: available1
                                                          ? Colors.green
                                                          : Colors.red,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                  if (time2 != null)
                                                    Expanded(
                                                      child: Container(
                                                        color: available2
                                                            ? Colors.green
                                                            : Colors.red,
                                                        width: double.infinity,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// Legend builder
Widget _buildLegendBox(Color color, String label) {
  return Row(
    children: [
      Container(width: 16, height: 16, color: color),
      const SizedBox(width: 4),
      Text(label),
    ],
  );
}
