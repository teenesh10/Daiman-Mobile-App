import 'package:daiman_mobile/constants.dart';
import 'package:daiman_mobile/home_page.dart';
import 'package:daiman_mobile/views/booking/booking.dart';
import 'package:daiman_mobile/views/booking/booking_history.dart';
import 'package:daiman_mobile/views/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBarWrapper extends StatelessWidget {
  final int initialIndex;

  const NavBarWrapper({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return NavBar(initialIndex: initialIndex);
  }
}

class NavBar extends StatefulWidget {
  final int initialIndex;

  const NavBar({super.key, this.initialIndex = 0});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    const HomePage(),
    const BookingPage(),
    const BookingHistoryPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, -1),
              blurRadius: 1.0,
              spreadRadius: 1.0,
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
              tabBackgroundColor: primaryColor,
              duration: const Duration(milliseconds: 400),
              rippleColor: Colors.white54,
              onTabChange: _onItemTapped,
              selectedIndex: _selectedIndex,
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
