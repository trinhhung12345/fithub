import 'package:flutter/material.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/services/chat_service.dart';

class ChatMessageItem {
  final String role; // 'user' hoặc 'bot'
  final String text;
  final List<AiProduct> products; // <-- Phải có dòng này
  final List<String> suggestions;

  ChatMessageItem({
    required this.role,
    required this.text,
    this.products = const [], // Mặc định rỗng
    this.suggestions = const [],
  });
}

class ChatViewModel extends ChangeNotifier {
  final ChatService _service = ChatService();

  final List<ChatMessageItem> _messages = [
    ChatMessageItem(
      role: 'bot',
      text:
          "Xin chào! Tôi là FitHub AI 🤖\nTôi có thể giúp bạn tìm dụng cụ thể thao nào?",
    ),
  ];
  List<ChatMessageItem> get messages => _messages;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  String? _lastSearchQuery;

  Future<void> sendMessage(String text, {bool isSuggestion = false}) async {
    if (text.trim().isEmpty) return;

    // UI: Thêm tin nhắn user
    _messages.add(ChatMessageItem(role: 'user', text: text));
    _isTyping = true;
    notifyListeners();

    // Logic ghép ngữ cảnh
    String textToSend = text;
    if (isSuggestion && _lastSearchQuery != null) {
      textToSend = "$_lastSearchQuery $text";
    } else {
      _lastSearchQuery = text;
    }

    try {
      // Gọi API
      final response = await _service.sendMessage(textToSend);

      if (response != null) {
        // --- LOG DEBUG: Kiểm tra xem có nhận được sản phẩm không ---
        print("Bot trả lời: ${response.message}");
        print("Số lượng sản phẩm: ${response.products.length}");
        // ----------------------------------------------------------

        _messages.add(
          ChatMessageItem(
            role: 'bot',
            text: response.message,
            products: response.products, // Truyền list sản phẩm vào đây
            suggestions: response.suggestions,
          ),
        );
      } else {
        _messages.add(
          ChatMessageItem(
            role: 'bot',
            text: "Lỗi kết nối server (Response null).",
          ),
        );
      }
    } catch (e) {
      print("Lỗi ViewModel Chat: $e");
      _messages.add(ChatMessageItem(role: 'bot', text: "Đã xảy ra lỗi xử lý."));
    }

    _isTyping = false;
    notifyListeners();
  }
}
