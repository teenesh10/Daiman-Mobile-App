import 'package:flutter/material.dart';

class FacilityButton extends StatelessWidget {
  final String facilityName;
  final bool isSelected;
  final VoidCallback onPressed;

  const FacilityButton({
    required this.facilityName,
    required this.isSelected,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 150, // Set a fixed width for all buttons
        height: 60, // Set a fixed height for the buttons
        margin: const EdgeInsets.only(left: 10), // Add left margin for spacing
        decoration: BoxDecoration(
          gradient: isSelected 
              ? LinearGradient(colors: [Colors.blue.shade300, Colors.blue.shade700]) // Gradient for selected
              : const LinearGradient(colors: [Colors.white, Colors.white]), // White for unselected
          borderRadius: BorderRadius.circular(10), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? Colors.blue.withOpacity(0.5) 
                  : Colors.grey.withOpacity(0.3), // Shadow for unselected button
              blurRadius: isSelected ? 10 : 5, // Blur radius based on selection
              offset: const Offset(2, 4), // Offset for the shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Padding for the button content
        child: Center(
          child: Text(
            facilityName,
            style: TextStyle(
              fontSize: 16, // Adjusted font size
              color: isSelected ? Colors.white : Colors.black, // Text color
              fontWeight: FontWeight.bold, // Bold text
            ),
          ),
        ),
      ),
    );
  }
}
