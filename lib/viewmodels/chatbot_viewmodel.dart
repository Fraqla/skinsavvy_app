import 'package:flutter/material.dart';
import '../models/chatbot_message.dart';
import '../services/chatbot_service.dart';

class ChatbotViewModel extends ChangeNotifier {
  final List<ChatbotMessage> _messages = [];
  final ChatbotService _service = ChatbotService();

  List<ChatbotMessage> get messages => _messages;

  Future<void> sendMessage(String userInput) async {
    _messages.add(ChatbotMessage(message: userInput, isUser: true));
    notifyListeners();

    try {
      String reply = await _service.sendMessage(userInput);
      _messages.add(ChatbotMessage(message: reply, isUser: false));
    } catch (e) {
      _messages.add(ChatbotMessage(message: 'Error: ${e.toString()}', isUser: false));
    }

    notifyListeners();
  }
}
