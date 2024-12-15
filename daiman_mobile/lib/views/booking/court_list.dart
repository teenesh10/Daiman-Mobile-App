import 'package:daiman_mobile/views/widgets/court_checkbox.dart';
import 'package:flutter/material.dart';

class CourtListPage extends StatelessWidget {
  // Sample data for courts
  final List<String> courts = [
    "Court 1",
    "Court 2",
    "Court 3",
    "Court 4",
    "Court 5",
  ];

  final List<bool> selectedCourts = List<bool>.filled(5, false);

  CourtListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Courts"),
      ),
      body: Column(
        children: [
          // Image at the top
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/court_placeholder.jpg"), // Replace with your asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: courts.length,
              itemBuilder: (context, index) {
                return CourtTile(
                  courtName: courts[index],
                  isSelected: selectedCourts[index],
                  onChanged: (value) {
                    // Handle nullable value safely
                    selectedCourts[index] = value ?? false;
                  },
                );
              },
            ),
          ),

          // Confirm button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle confirm logic
              },
              child: const Text("Confirm Selection"),
            ),
          ),
        ],
      ),
    );
  }
}
