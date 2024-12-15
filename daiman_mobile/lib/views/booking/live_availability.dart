import 'package:flutter/material.dart';

class LiveAvailabilityPage extends StatelessWidget {
  // Sample list of timeslots
  final List<String> timeslots = [
    "08:00 AM",
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
    "07:00 PM"
  ];

  // Sample list indicating whether a timeslot is booked
  final List<bool> isBooked = [
    true,
    false,
    true,
    false,
    true,
    true,
    false,
    true,
    false,
    false,
    true,
    false
  ];

  LiveAvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Court Availability")),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columns
                childAspectRatio: 2,
              ),
              itemCount: timeslots.length,
              itemBuilder: (context, index) {
                String timeslot = timeslots[index];
                bool available = !isBooked[index];

                return GestureDetector(
                  onTap: () {
                    if (available) {
                      // Here you could handle booking action
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: available ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        timeslot,
                        style: const TextStyle(color: Colors.white),
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
