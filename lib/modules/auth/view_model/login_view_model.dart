import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/auth_model.dart';
import '../../main/main_screen.dart'; // Import trang chính
import '../../../data/local/app_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _authService.login(email, password);

      if (res.code == 200 && res.data?.accessToken != null) {
        // Login thành công
        await AppPreferences.saveToken(res.data!.accessToken!);
        print("Đã lưu token: ${res.data!.accessToken}");

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false,
          );
        }
      } else {
        _showError(context, res.message ?? "Đăng nhập thất bại");
      }
    } catch (e) {
      _showError(context, "Lỗi kết nối: $e");
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
