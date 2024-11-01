// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class DurationSelector extends StatefulWidget {
  const DurationSelector({super.key});

  @override
  _DurationSelectorState createState() => _DurationSelectorState();
}

class _DurationSelectorState extends State<DurationSelector> {
  int _duration = 1; // Start with 1 hour

  void _incrementDuration() {
    if (_duration < 24) {
      setState(() {
        _duration++;
      });
      print("Selected duration: $_duration Hour(s)");
    }
  }

  void _decrementDuration() {
    if (_duration > 1) {
      setState(() {
        _duration--;
      });
      print("Selected duration: $_duration Hour(s)");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Decrement Button
          GestureDetector(
            onTap: _decrementDuration,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              '$_duration Hour${_duration > 1 ? 's' : ''}', // Add 's' for plural if needed
              style: const TextStyle(fontSize: 18),
            ),
          ),
          // Increment Button
          GestureDetector(
            onTap: _incrementDuration,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
