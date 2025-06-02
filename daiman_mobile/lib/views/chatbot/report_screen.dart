import 'package:daiman_mobile/controllers/chatbot_controller.dart';
import 'package:daiman_mobile/custom_snackbar.dart';
import 'package:flutter/material.dart';

class ReportIssueScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final ChatbotController _chatbotController = ChatbotController();

  ReportIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report an Issue",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
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
              onPressed: () async {
                final issue = _controller.text.trim();
                if (issue.isNotEmpty) {
                  try {
                    await _chatbotController.submitReport(issue);
                    CustomSnackBar.showSuccess(
                      context,
                      "Issue Reported",
                      "Thank you for your feedback!",
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    CustomSnackBar.showFailure(
                      context,
                      "Submission Failed",
                      "Oops! Something went wrong. Please try again.",
                    );
                  }
                } else {
                  CustomSnackBar.showFailure(
                    context,
                    "Empty Report",
                    "Please describe the issue before submitting.",
                  );
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
