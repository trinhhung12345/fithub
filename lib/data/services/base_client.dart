import 'dart:convert';
import 'package:http/http.dart' as http;
import '../local/app_preferences.dart';
import '../../core/utils/session_utils.dart'; // Import SessionUtils vừa tạo

class BaseClient {
  // Client của http để tái sử dụng
  static final http.Client _client = http.Client();

  // Hàm GET chung
  static Future<dynamic> get(String url) async {
    final token = await AppPreferences.getToken();

    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception("Lỗi kết nối: $e");
    }
  }

  // Hàm POST chung
  static Future<dynamic> post(String url, dynamic body) async {
    final token = await AppPreferences.getToken();

    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception("Lỗi kết nối: $e");
    }
  }

  // Xử lý Response tập trung
  static dynamic _processResponse(http.Response response) {
    // === ĐÂY LÀ CHỖ QUAN TRỌNG NHẤT ===
    if (response.statusCode == 401 || response.statusCode == 403) {
      // 401: Unauthorized (Token hết hạn hoặc không hợp lệ)
      SessionUtils.handleSessionExpired();
      throw Exception("Phiên đăng nhập hết hạn");
    }
    // ===================================

    // Các trường hợp khác trả về body để Service tự xử lý tiếp
    return jsonDecode(response.body);
    // Lưu ý: Nếu response không phải JSON chuẩn thì cần try-catch chỗ này
  }

  static Future<dynamic> put(String url, dynamic body) async {
    final token = await AppPreferences.getToken();

    try {
      final response = await _client.put(
        // Sử dụng PUT
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception("Lỗi kết nối (PUT): $e");
    }
  }

  // --- THÊM HÀM NÀY ---
  static Future<dynamic> delete(String url, dynamic body) async {
    final token = await AppPreferences.getToken();

    try {
      // Sử dụng request builder để đảm bảo gửi được Body trong lệnh DELETE
      final request = http.Request('DELETE', Uri.parse(url));

      request.headers.addAll({
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      request.body = jsonEncode(body);

      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      return _processResponse(response);
    } catch (e) {
      throw Exception("Lỗi kết nối (DELETE): $e");
    }
  }
}
