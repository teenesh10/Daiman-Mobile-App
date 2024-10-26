import 'package:flutter/material.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          350.0, // Set a fixed width for a shorter search bar
      height:
          50.0, // Increase height for a taller search bar
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Adjust padding as needed
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 16.0),
          Text(
            'Search...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
