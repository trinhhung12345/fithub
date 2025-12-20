import 'package:jwt_decoder/jwt_decoder.dart';
import '../../data/local/app_preferences.dart';

class TokenUtils {
  // Hàm lấy User ID (dạng int) từ Token đang lưu trong máy
  static Future<int?> getUserId() async {
    final token = await AppPreferences.getToken();
    if (token == null || JwtDecoder.isExpired(token)) return null;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    // Theo token bạn gửi trước đó: "sub": "5" -> Đây là userId
    if (decodedToken['sub'] != null) {
      return int.tryParse(decodedToken['sub'].toString());
    }
    return null;
  }
}
