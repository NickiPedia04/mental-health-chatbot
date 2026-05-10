import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mental_app_support/secret_file.dart';

class AIServices {
  final String apiKey = key;

  Future<String> sendMessage(String message) async {
    final curl =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=$apiKey";

    final response = await http.post(
      Uri.parse(curl),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": message},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      print("AI service prob: ${response.body}");

      return "Sorry, something went wrong.";
    }
  }
}
