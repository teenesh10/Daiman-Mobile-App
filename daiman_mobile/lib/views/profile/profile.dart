import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20), // Add some top padding
            // Heading "Profile" at the center
            const Text(
              "Profile",
              style: TextStyle(
                fontSize: 24, // Heading font size
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30), // Space between heading and avatar
            // Circle Avatar with Person Icon
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent.withOpacity(0.2),
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 40),
            // Form Fields for Profile Information
            _buildProfileTextField(
              label: "Full Name",
              icon: Icons.person,
            ),
            const SizedBox(height: 15),
            _buildProfileTextField(
              label: "Email Address",
              icon: Icons.email,
            ),
            const SizedBox(height: 15),
            _buildProfileTextField(
              label: "Phone Number",
              icon: Icons.phone,
            ),
            const SizedBox(height: 30),
            // Edit Profile Button Expanded to Full Width
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle edit profile action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Joined Date and Delete Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text.rich(
                  TextSpan(
                    text: "Joined ",
                    style: TextStyle(fontSize: 12),
                    children: [
                      TextSpan(
                        text: "31 October 2024",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle delete action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    elevation: 0,
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTextField(
      {required String label, required IconData icon}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
