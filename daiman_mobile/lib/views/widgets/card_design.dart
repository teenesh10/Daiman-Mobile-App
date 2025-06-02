import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onReadMore;

  const CustomCard({
    required this.imageUrl,
    required this.title,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Truncate long text with ellipsis
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                  maxLines: 3, // you can change to 2 or 1 if needed
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // ✅ Align the Read More button to the left
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: onReadMore,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                      padding:
                          EdgeInsets.zero, // removes default button padding
                      minimumSize: const Size(0, 0), // removes default min size
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // tighter hit area
                    ),
                    child: const Text("Read More"),
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
