import 'package:flutter/material.dart';
import '../../data/local/app_preferences.dart';
import '../../modules/auth/view/login_screen.dart';
import '../../main.dart'; // Import để lấy navigatorKey
import '../components/fit_hub_dialog.dart';

class SessionUtils {
  static bool _isDialogShowing = false; // Tránh hiện 2-3 popup cùng lúc

  static Future<void> handleSessionExpired() async {
    // Nếu dialog đang hiện rồi thì thôi, không hiện cái nữa
    if (_isDialogShowing) return;

    _isDialogShowing = true;

    // 1. Xóa Token
    await AppPreferences.removeToken();

    // 2. Lấy context từ GlobalKey
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // 3. Hiện Popup bắt buộc
    await FitHubDialog.show(
      context,
      title: "Phiên đăng nhập hết hạn",
      content: "Vui lòng đăng nhập lại để tiếp tục sử dụng.",
      isSuccess: false, // Icon đỏ cảnh báo
      buttonText: "Đăng nhập lại",
      onPressed: () {
        _isDialogShowing = false;
        // 4. Chuyển về màn hình Login và xóa hết lịch sử cũ
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      },
    );
  }
}
