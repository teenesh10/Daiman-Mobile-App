import 'package:daiman_mobile/views/widgets/history_tab.dart';
import 'package:flutter/material.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar background color
        elevation: 0, // No shadow for the AppBar
        automaticallyImplyLeading: false, // Hides the back button
      ),
      body: Container(
        color: Colors.white, // Set a white background
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // TabBar background color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const TabBar(
                  indicator: BoxDecoration(
                    color: Colors.blueAccent, // Indicator color
                    // Make the indicator expand to each tab's width
                    borderRadius: BorderRadius.zero,
                  ),
                  labelColor: Colors.white, // Active tab text color
                  unselectedLabelColor:
                      Colors.blueAccent, // Inactive tab text color
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: 'Upcoming'), // First tab
                    Tab(text: 'Past'), // Second tab
                  ],
                  indicatorSize: TabBarIndicatorSize
                      .tab, // Makes the indicator expand to the tab size
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    BookingHistoryTab(isUpcoming: true), // Upcoming bookings
                    BookingHistoryTab(isUpcoming: false), // Past bookings
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
