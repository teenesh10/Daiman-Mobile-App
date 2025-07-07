import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey =
      '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';

  Future<String> sendMessage(String message) async {
    final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey",
    };

    final body = jsonEncode({
      "model": "meta-llama/llama-3-8b-instruct",
      "messages": [
        {"role": "user", "content": message}
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reply = data['choices'][0]['message']['content'];
        return reply;
      } else {
        print("OpenRouter API Error: ${response.body}");
        return "Sorry, I couldn’t get a response from the AI.";
      }
    } catch (e) {
      print("OpenRouter Exception: $e");
      return "Something went wrong. Please try again later.";
    }
  }
}
