import 'package:daiman_mobile/controllers/auth_controller.dart';
import 'package:daiman_mobile/views/widgets/appbar.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
   HomeAppBar({
    super.key,
  });

final AuthController _authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6), // Padding inside the circle
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black, // White border color
                width: 1, // Border thickness
              ),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.black,
              size: 20, // Adjust icon size
            ),
          ),
          const SizedBox(width: 8), // Space between the icon and text
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back! ', // Replace with your actual title text
                style: TextStyle(
                  color: Colors.grey, // Set the color of the title text
                  fontSize: 14,
                ),
              ),
              Text(
                'Teenesh', // Replace with your actual subtitle text
                style: TextStyle(
                  color: Colors.black, // Set the color of the subtitle text
                  fontSize: 16, // Set the font size for the subtitle
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () async {
              await _authController.logout(); // Call the logout function
              Navigator.of(context).pushReplacementNamed('/login'); // Redirect to login page
            },
          icon: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
        ),
      ],
      backgroundColor: Colors.white,
    );
  }
}
