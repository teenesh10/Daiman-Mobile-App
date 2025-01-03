import 'package:daiman_mobile/models/court.dart';
import 'package:flutter/material.dart';

class HorizontalScroll extends StatelessWidget {
  final List<Court> courts;

  const HorizontalScroll({super.key, required this.courts});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: courts
            .map((court) => DataColumn(label: Text(court.courtName)))
            .toList(),
        rows: courts
            .map(
              (court) => DataRow(
                cells: courts
                    .map(
                      (c) => DataCell(
                        Container(
                          color: c.availability ? Colors.white : Colors.red,
                          width: 80,
                          height: 40,
                          child: Center(
                            child: Text(c.availability ? "Available" : "Booked"),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}