
import 'package:daiman_mobile/views/widgets/curved_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          CustomShapeWidget(
            child: Container(
              color: Colors.blueAccent,
              padding: const EdgeInsets.all(0),
              child: const SizedBox(
                height: 300,
                child: Stack(
                  children: [
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}


