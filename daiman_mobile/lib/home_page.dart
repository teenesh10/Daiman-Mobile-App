import 'package:daiman_mobile/views/widgets/card_design.dart';
import 'package:daiman_mobile/views/widgets/curved_widget.dart';
import 'package:daiman_mobile/views/widgets/heading.dart';
import 'package:daiman_mobile/views/widgets/home_appbar.dart';
import 'package:daiman_mobile/views/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Curved widget wrapping the blue section
            CustomShapeWidget(
              child: Container(
                color: Colors.blueAccent,
                height: 250, // Adjust based on carousel height
                child: const Center(
                  child: Text(
                    'Image Carousel Placeholder', // Placeholder for the carousel
                    style: TextStyle(color: Colors.white),
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
    );
  }
}
