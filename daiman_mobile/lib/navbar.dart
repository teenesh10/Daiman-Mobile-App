// ignore_for_file: library_private_types_in_public_api

import 'package:daiman_mobile/home_page.dart';
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
    const Center(child: Text('Book Screen')),
    const Center(child: Text('History Screen')),
    const Center(child: Text('Profile Screen')),
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
          color: Color.fromARGB(
              255, 0, 0, 0), // Background color for the bottom nav
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(30)), // Rounded corners
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GNav(
              gap: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: Colors.transparent,
              color: Colors.white70,
              activeColor: Colors.white,
              iconSize: 24,
              tabBackgroundColor: const Color.fromARGB(
                  255, 30, 30, 30), // Color for the active tab background
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
