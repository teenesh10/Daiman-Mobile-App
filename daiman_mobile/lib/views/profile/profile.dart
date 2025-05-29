import 'package:daiman_mobile/controllers/auth_controller.dart';
import 'package:daiman_mobile/views/profile/privacy.dart';
import 'package:daiman_mobile/views/profile/settings.dart';
import 'package:daiman_mobile/views/profile/terms.dart';
import 'package:daiman_mobile/views/widgets/confirmation_dialog.dart';
import 'package:daiman_mobile/views/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _authController.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Error loading profile data"));
          }

          final userData = snapshot.data!;
          final username = userData['username'] ?? "N/A";
          final email = userData['email'] ?? "N/A";

          return FutureBuilder<DateTime?>(
            future: _authController.getUserJoinedDate(),
            builder: (context, joinedDateSnapshot) {
              String joinedDate = "Date not available";

              if (joinedDateSnapshot.connectionState == ConnectionState.done &&
                  joinedDateSnapshot.hasData) {
                final date = joinedDateSnapshot.data!;
                joinedDate = DateFormat('d MMMM yyyy').format(date);
              }

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blueAccent.withOpacity(0.2),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        username,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                          title: "Settings",
                          icon: Icons.settings,
                          onPress: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const SettingsPage(),
                            ));
                          }),
                      const Divider(),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                        title: "Privacy Policy",
                        icon: Icons.privacy_tip,
                        onPress: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const PrivacyPolicyPage(),
                          ));
                        },
                      ),
                      ProfileMenuWidget(
                          title: "Terms & Conditions",
                          icon: Icons.info,
                          onPress: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const TermsConditionsPage()),
                            );
                          }),
                      ProfileMenuWidget(
                        title: "Logout",
                        icon: Icons.logout,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmationPopup(
                              title: "Are you sure you want to Logout?",
                              confirmText: "Yes",
                              cancelText: "No",
                              onConfirm: () async {
                                await _authController.logout();
                                Navigator.of(context)
                                    .pushReplacementNamed('/login');
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: "Joined ",
                              style: const TextStyle(fontSize: 12),
                              children: [
                                TextSpan(
                                  text: joinedDate,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
