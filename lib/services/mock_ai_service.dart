import 'dart:math';
import '../models/chat_message.dart';

class MockAIService {
  static final List<String> _mockResponses = [
    "That's an interesting question! Let me think about that for a moment.",
    "I understand what you're asking. Based on my analysis, here's what I think...",
    "Great point! Here's my perspective on that topic.",
    "I'd be happy to help you with that. Let me break it down for you.",
    "That's a fascinating topic! From what I know, here's the answer.",
    "I see where you're coming from. Let me provide some insights.",
    "Excellent question! Here's what I can tell you about that.",
    "I appreciate you asking. Let me share my thoughts on this.",
    "That's something I've been trained on extensively. Here's what I know.",
    "Let me help you understand this better. Here's my explanation.",
  ];

  static final List<String> _followUpResponses = [
    "Is there anything else you'd like to know about this?",
    "Would you like me to elaborate on any specific part?",
    "Feel free to ask if you need more clarification!",
    "I hope that helps! Let me know if you have more questions.",
    "Does this answer your question? I'm here if you need more details.",
  ];

  static Future<ChatMessage> generateResponse(String userMessage) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800 + Random().nextInt(700)));

    final random = Random();
    final mainResponse = _mockResponses[random.nextInt(_mockResponses.length)];
    final followUp = _followUpResponses[random.nextInt(_followUpResponses.length)];

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: '$mainResponse\n\n$followUp',
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  static List<ChatMessage> getInitialMessages() {
    return [
      ChatMessage(
        id: '1',
        text: 'Hello! I\'m your AI assistant. How can I help you today?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
  }
}

