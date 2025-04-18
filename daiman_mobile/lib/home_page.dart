import 'package:daiman_mobile/views/widgets/card_design.dart';
import 'package:daiman_mobile/views/widgets/curved_shape.dart';
import 'package:daiman_mobile/views/widgets/curved_widget.dart';
import 'package:daiman_mobile/views/widgets/heading.dart';
import 'package:daiman_mobile/views/widgets/home_appbar.dart';
import 'package:daiman_mobile/views/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final List<String> _images = [
    'assets/images/img1.jpg',
    'assets/images/img2.jpg',
    'assets/images/img3.jpg',
  ];
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Curved widget wrapping the image carousel
            CustomShapeWidget(
              child: SizedBox(
                height: 250,
                child: ClipPath(
                  clipper: CurvedShape(),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        _images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
            // White section for remaining content
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  HomeAppBar(),
                  const SizedBox(height: 25.0),
                  const SearchContainer(),
                  const SizedBox(height: 32.0),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(
                      children: [
                        SectionHeading(
                          title: "Events",
                          showActionButton: true,
                        ),
                      ],
                    ),
                  ),
                  // Wrap ListView in a SizedBox to prevent infinite height
                  SizedBox(
                    height:
                        250, // Set a fixed height to contain the horizontal ListView
                    child: ListView(
                      scrollDirection: Axis
                          .horizontal, // Set to horizontal to display in a row
                      children: const [
                        CustomCard(
                          imageUrl: 'https://via.placeholder.com/150',
                          title: 'Card Title 1',
                        ),
                        CustomCard(
                          imageUrl: 'https://via.placeholder.com/150',
                          title: 'Card Title 2',
                        ),
                        CustomCard(
                          imageUrl: 'https://via.placeholder.com/150',
                          title: 'Card Title 3',
                        ),
                        CustomCard(
                          imageUrl: 'https://via.placeholder.com/150',
                          title: 'Card Title 4',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/chat');
        },
        backgroundColor: Colors.blueAccent, // Example robot icon
        tooltip: 'Chatbot',
        child: const Icon(Icons.android,
            color: Colors.white), // Tooltip when hovering over the button
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Default location
    );
  }
}
