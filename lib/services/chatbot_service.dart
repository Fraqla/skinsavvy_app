import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatbotService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api';
    } else {
      return 'http://localhost:8000/api';
    }
  }

Future<String> sendMessage(String message) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/dialogflow-send-message'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'message': message,
        'session_id': 'flutter_user_session'
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('error')) {
        return 'Error: ${data['error']}';
      }
      return data['reply'] ?? 'No reply';
    } else {
      final errorData = json.decode(response.body);
      return 'Error: ${errorData['error'] ?? 'Unknown error (${response.statusCode})'}';
    }
  } catch (e) {
    return 'Connection error: ${e.toString()}';
  }
}
}
