import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportIssueScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ReportIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report an Issue")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Describe your issue...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final issue = _controller.text.trim();
                if (issue.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection('query_reports')
                      .add({
                    "issue": issue,
                    "timestamp": FieldValue.serverTimestamp(),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Issue reported!")),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
