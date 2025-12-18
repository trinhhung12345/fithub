import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_model.dart';

class AuthService {
  // Thay đổi IP này nếu cần. Lưu ý: http (không s) cần cấu hình AndroidManifest
  static const String baseUrl = 'http://100.127.71.42:6868/api/v1/auth';

  // 1. Gửi OTP (Bước 1 Đăng ký)
  Future<AuthResponse> sendOtpRegister(String email, String phone) async {
    final url = Uri.parse('$baseUrl/send-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "phone": phone,
        "email": email,
        "type": 1, // 1: Mail
        "purpose": 1, // 1: Đăng ký
      }),
    );
    return _processResponse(response);
  }

  // 2. Đăng ký & Xác thực OTP (Bước 2 Đăng ký)
  Future<AuthResponse> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required int codeId, // ID nhận được từ bước sendOtp
    required String otpCode, // Mã người dùng nhập
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "accountPhone": phone,
        "accountName": name,
        "email": email,
        "password": password,
        "confirmPassword": password, // Backend yêu cầu, mình tự điền giống pass
        "businessRole": 1,
        "codeId": codeId,
        "code": otpCode,
      }),
    );
    return _processResponse(response);
  }

  // 3. Đăng nhập
  Future<AuthResponse> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );
    return _processResponse(response);
  }

  // Hàm xử lý chung response
  AuthResponse _processResponse(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return AuthResponse.fromJson(body);
    } catch (e) {
      return AuthResponse(code: 500, message: "Lỗi parse JSON: $e");
    }
  }
}
