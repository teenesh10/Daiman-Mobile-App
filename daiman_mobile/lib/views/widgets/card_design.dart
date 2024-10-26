import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const CustomCard({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Set a fixed width for the card
      margin: const EdgeInsets.symmetric(
          horizontal: 8.0, vertical: 8.0), // Added vertical margin
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(15), // Rounded corners for the entire card
        color: Colors.white, // Background color for the card
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            blurRadius: 8, // Shadow blur radius
            offset: const Offset(0, 4), // Offset for shadow
          ),
          BoxShadow(
            color: Colors.black
                .withOpacity(0.1), // Additional shadow for the bottom
            blurRadius: 8, // Blur radius for bottom shadow
            offset: const Offset(
                0, 2), // Adjust this to create a softer bottom shadow
          ),
        ],
      ),
      child: Column(
        children: [
          // Image section with gray background
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15)), // Rounded corners only at the top
            child: Container(
              width: double.infinity, // Make it full width
              height: 160, // Increased height for the image section
              color: Colors.grey[300], // Gray background for the image section
              child: const Center(
                child: Text(
                  'Placeholder', // Placeholder text or an image can go here
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
          // Title and button section
          Padding(
            padding: const EdgeInsets.all(
                10.0), // Padding around the title and button
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the left
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                    height: 4), // Spacing between title and "Read More"
                GestureDetector(
                  onTap: () {
                    // Handle "Read More" action here
                  },
                  child: const Text(
                    'Read More',
                    style: TextStyle(
                      color: Colors
                          .blue, // Change color to indicate it's clickable
                      fontSize: 16,
                      decoration: TextDecoration
                          .none, // No underline for the link effect
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
