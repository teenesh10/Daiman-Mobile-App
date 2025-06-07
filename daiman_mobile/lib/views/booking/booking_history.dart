import 'package:daiman_mobile/constants.dart';
import 'package:daiman_mobile/views/widgets/history_tab.dart';
import 'package:flutter/material.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          title: const Text(
            'Booking History',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                indicator: BoxDecoration(
                  color: primaryColor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: primaryColor,
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
    );
  }
}
