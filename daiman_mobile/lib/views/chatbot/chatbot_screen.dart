// ignore_for_file: library_private_types_in_public_api

import 'package:daiman_mobile/constants.dart';
// import 'package:daiman_mobile/services/chatbot.dart';
import 'package:daiman_mobile/services/chatbot_response.dart';
import 'package:daiman_mobile/views/chatbot/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

enum ChatCategory { general, report }

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  // final OpenAIService _openAIService = OpenAIService();
  final _user = const types.User(id: "user");
  final _bot = const types.User(id: "bot");
  final _uuid = const Uuid();
  bool _showCategories = true;

  ChatCategory? _selectedCategory;

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

    // String response;
    String? response = _getKeywordResponse(text);

    // if (response == null) {
    //   try {
    //     response = await _openAIService.sendMessage(text);
    //   } catch (e) {
    //     response = "Sorry! Please contact our customer service, 07-557 3888.";
    //   }
    // }

    response ??=
        "Sorry, I couldn't understand your question. Please try contact our customer service 07-557 3888.";

    final botMessage = types.TextMessage(
      author: _bot,
      id: _uuid.v4(),
      text: response,
    );

    _addMessage(botMessage);
  }

  String? _getKeywordResponse(String text) {
    final normalizedText = text.toLowerCase();

    for (final keyword in keywordSynonyms.keys) {
      final synonyms = keywordSynonyms[keyword]!;
      for (final phrase in synonyms) {
        if (normalizedText.contains(phrase)) {
          return keywordResponses[keyword];
        }
      }
    }

    return null;
  }

  void _handleCategorySelection(ChatCategory category) {
    setState(() {
      _selectedCategory = category;
    });

    if (category == ChatCategory.general) {
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
    } else if (category == ChatCategory.report) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportIssueScreen()),
      );
    }
  }

  Widget _buildCategoryOption(
      ChatCategory category, IconData icon, String label) {
    final isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () => _handleCategorySelection(category),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: const Text(
          "AI Chatbot",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          if (_showCategories)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCategoryOption(ChatCategory.general,
                        Icons.question_answer, "General Inquiry"),
                    const SizedBox(height: 20),
                    _buildCategoryOption(ChatCategory.report,
                        Icons.report_problem, "Report an Issue"),
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
                theme: const DefaultChatTheme(
                  inputBackgroundColor: primaryColor,
                  inputTextColor: Colors.white,
                  inputTextCursorColor: Colors.white,
                  sendButtonIcon: Icon(Icons.send, color: Colors.white),
                  inputTextStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
