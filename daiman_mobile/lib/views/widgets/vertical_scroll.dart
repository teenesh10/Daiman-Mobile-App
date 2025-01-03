import 'package:daiman_mobile/models/timeslot.dart';
import 'package:flutter/material.dart';

class VerticalScroll extends StatelessWidget {
  final List<Timeslot> timeslots;

  const VerticalScroll({super.key, required this.timeslots});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: timeslots.length,
      itemBuilder: (context, index) {
        final timeslot = timeslots[index];
        return Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text("${timeslot.start} - ${timeslot.end}",
              style: const TextStyle(fontSize: 16)),
        );
      },
    );
  }
}