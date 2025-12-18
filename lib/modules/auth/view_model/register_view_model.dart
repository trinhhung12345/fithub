import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/local/app_preferences.dart';
import '../view/register_otp_screen.dart'; // Màn hình OTP mới cho đăng ký
import '../../main/main_screen.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Lưu trữ dữ liệu tạm thời để dùng ở bước 2 (OTP)
  String? _tempName;
  String? _tempEmail;
  String? _tempPhone;
  String? _tempPass;
  int? _codeId; // ID của OTP session

  // Bước 1: Gửi OTP
  Future<void> sendOtp(
    BuildContext context,
    String name,
    String email,
    String phone,
    String password,
    String confirmPass,
  ) async {
    if (password != confirmPass) {
      _showError(context, "Mật khẩu không khớp!");
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final res = await _authService.sendOtpRegister(email, phone);

      if (res.code == 200 && res.data?.id != null) {
        // Thành công, lưu dữ liệu tạm
        _tempName = name;
        _tempEmail = email;
        _tempPhone = phone;
        _tempPass = password;
        _codeId = res.data!.id; // Lưu codeId quan trọng

        // Chuyển sang màn hình nhập OTP
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterOtpScreen()),
          );
        }
      } else {
        _showError(context, res.message ?? "Gửi OTP thất bại");
      }
    } catch (e) {
      _showError(context, "Lỗi kết nối: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Bước 2: Xác thực OTP và Đăng ký
  Future<void> verifyAndRegister(BuildContext context, String otpCode) async {
    if (_codeId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final res = await _authService.register(
        name: _tempName!,
        email: _tempEmail!,
        phone: _tempPhone!,
        password: _tempPass!,
        codeId: _codeId!,
        otpCode: otpCode,
      );

      if (res.code == 200) {
        // Đăng ký thành công -> Vào app luôn hoặc về login tùy bạn
        // Ở đây mình cho vào MainScreen luôn
        if (res.data?.accessToken != null) {
          await AppPreferences.saveToken(res.data!.accessToken!);
        }

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false,
          );
        }
      } else {
        _showError(context, res.message ?? "Đăng ký thất bại");
      }
    } catch (e) {
      _showError(context, "Lỗi: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showError(BuildContext context, String msg) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }
}
