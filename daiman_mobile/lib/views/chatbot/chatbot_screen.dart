// ignore_for_file: library_private_types_in_public_api

import 'package:daiman_mobile/services/chatbot.dart';
import 'package:daiman_mobile/services/chatbot_response.dart';
import 'package:daiman_mobile/views/chatbot/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  final OpenAIService _openAIService = OpenAIService();
  final _user = const types.User(id: "user");
  final _bot = const types.User(id: "bot");
  final _uuid = const Uuid();
  bool _showCategories = true;

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _sendMessage(String text) async {
    final userMessage = types.TextMessage(
      author: _user,
      id: _uuid.v4(),
      text: text,
    );

    _addMessage(userMessage);

    // Check if the text matches any predefined keywords
    String? response = _getKeywordResponse(text);

    if (response == null) {
      // If no predefined response, use OpenAI API
      try {
        response = await _openAIService.sendMessage(text);
      } catch (e) {
        response = "Sorry! Please contact our customer service to know more.";
      }
    }

    final botMessage = types.TextMessage(
      author: _bot,
      id: _uuid.v4(),
      text: response,
    );

    _addMessage(botMessage);
  }

  String? _getKeywordResponse(String text) {
    // Normalize input text and check for keywords
    final normalizedText = text.toLowerCase();
    for (final keyword in keywordResponses.keys) {
      if (normalizedText.contains(keyword)) {
        return keywordResponses[keyword];
      }
    }
    return null;
  }

  void _handleCategorySelection(String category) {
    if (category == "General Inquiry") {
      setState(() {
        _showCategories = false;
        _addMessage(
          types.TextMessage(
            author: _bot,
            id: _uuid.v4(),
            text: "What would you like to know?",
          ),
        );
      });
    } else if (category == "Report an Issue") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportIssueScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _addMessage(
      types.TextMessage(
        author: _bot,
        id: _uuid.v4(),
        text:
            "Hello! Welcome to our Daiman Sport Centre. What can we help you with today?",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Chatbot")),
      body: Column(
        children: [
          if (_showCategories)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          _handleCategorySelection("General Inquiry"),
                      child: const Text("General Inquiry"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () =>
                          _handleCategorySelection("Report an Issue"),
                      child: const Text("Report an Issue"),
                    ),
                  ],
                ),
              ),
            ),
          if (!_showCategories)
            Expanded(
              child: Chat(
                messages: _messages,
                onSendPressed: (types.PartialText message) {
                  _sendMessage(message.text);
                },
                user: _user,
              ),
            ),
        ],
      ),
    );
  }
}
