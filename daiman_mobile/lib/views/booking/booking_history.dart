import 'package:daiman_mobile/views/widgets/history_tab.dart';
import 'package:flutter/material.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    color: Colors.blueAccent,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.blueAccent,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Past'),
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    BookingHistoryTab(isUpcoming: true),
                    BookingHistoryTab(isUpcoming: false),
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
