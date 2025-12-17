import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPass,
  ) async {
    // Validate cơ bản
    if (password != confirmPass) {
      // Trong thực tế bạn nên show dialog hoặc snackbar lỗi
      print("Mật khẩu không khớp!");
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Giả lập gọi API đăng ký
    await Future.delayed(const Duration(seconds: 2));

    print("Đăng ký thành công: $email");

    _isLoading = false;
    notifyListeners();
  }
}
