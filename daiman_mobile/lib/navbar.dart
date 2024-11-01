// ignore_for_file: library_private_types_in_public_api

import 'package:daiman_mobile/home_page.dart';
import 'package:daiman_mobile/views/booking/booking.dart';
import 'package:daiman_mobile/views/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const BookingPage(),
    const Center(child: Text('History Screen')),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color to transparent so it matches the home page
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Background color for the bottom nav
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(0)), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Shadow color
              offset: Offset(0, -1), // Shadow position
              blurRadius: 1.0, // Shadow blur radius
              spreadRadius: 1.0, // Shadow spread radius
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: GNav(
              gap: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: Colors.transparent,
              color: Colors.black,
              activeColor: Colors.white,
              iconSize: 24,
              tabBackgroundColor:
                  Colors.blueAccent, // Color for the active tab background
              duration: const Duration(milliseconds: 400),
              rippleColor: Colors.white54,
              onTabChange: _onItemTapped,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.calendar_today,
                  text: 'Book',
                ),
                GButton(
                  icon: Icons.history,
                  text: 'History',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
