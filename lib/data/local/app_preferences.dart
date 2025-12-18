import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _keyAccessToken = 'access_token';

  // 1. Lưu Token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, token);
  }

  // 2. Lấy Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  // 3. Xóa Token (Dùng khi Đăng xuất)
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
  }
}
