import 'package:daiman_mobile/controllers/booking_controller.dart';
import 'package:daiman_mobile/navbar.dart';
import 'package:flutter/material.dart';
import 'package:daiman_mobile/controllers/auth_controller.dart';
import 'package:daiman_mobile/views/widgets/appbar.dart';

class HomeAppBar extends StatelessWidget {
  HomeAppBar({super.key});

  final AuthController _authController = AuthController();
  final BookingController _bookingController = BookingController();

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
                color: Colors.black, // Black border color
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
          FutureBuilder<Map<String, dynamic>?>(
            future: _authController.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                );
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!['username'] == null) {
                return const Text(
                  'User',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Colors.grey, // Set the color of the title text
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      snapshot.data!['username'] ?? 'User',
                      style: const TextStyle(
                        color:
                            Colors.black, // Set the color of the subtitle text
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
      actions: [
        FutureBuilder<int>(
          future: _bookingController.getUpcomingBookingCount(),
          builder: (context, snapshot) {
            int count = snapshot.data ?? 0;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const NavBarWrapper(initialIndex: 2),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                ),
                if (count > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
