import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey = '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'; // Replace with your OpenAI API Key

  Future<String> sendMessage(String message) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey",
    };

    final body = jsonEncode({
      "model": "gpt-4-mini", // Use "gpt-4-mini" if applicable
      "messages": [
        {"role": "user", "content": message}
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to fetch response: ${response.body}');
    }
  }
}
