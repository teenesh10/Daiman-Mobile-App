// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daiman_mobile/views/widgets/facility_button.dart';
import 'package:daiman_mobile/views/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class FacilityListPage extends StatefulWidget {
  const FacilityListPage({super.key});

  @override
  _FacilityListPageState createState() => _FacilityListPageState();
}

class _FacilityListPageState extends State<FacilityListPage> {
  int? _selectedFacilityIndex; // Track the selected facility index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facilities'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SearchContainer(),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('facility')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error loading facilities'));
                  }

                  final facilities = snapshot.data?.docs ?? [];

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: facilities.length,
                    itemBuilder: (context, index) {
                      final facilityData =
                          facilities[index].data() as Map<String, dynamic>;

                      return FacilityButton(
                        facilityName: facilityData['facilityName'],
                        isSelected: _selectedFacilityIndex ==
                            index, // Animate if selected
                        onPressed: () {
                          setState(() {
                            // Update selected facility index for animation
                            _selectedFacilityIndex = index;
                          });
                          // Optionally, navigate or perform other actions here
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
