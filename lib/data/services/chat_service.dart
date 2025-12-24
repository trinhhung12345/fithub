import '../models/chat_model.dart';
import '../services/base_client.dart';
import '../../configs/app_config.dart';

class ChatService {
  Future<AiResponse?> sendMessage(String message) async {
    final url = '${AppConfig.baseUrl}/ai/chat';

    final body = {"message": message};

    try {
      // BaseClient tự động gắn Token
      final response = await BaseClient.post(url, body);

      // Map JSON sang Model
      return AiResponse.fromJson(response);
    } catch (e) {
      print("Lỗi Chat Bot: $e");
      return null;
    }
  }
}
