import 'package:flutter/material.dart';
// import api service here

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // Báo UI hiện loading

    // Giả lập gọi API (sau này thay bằng code http thật)
    await Future.delayed(const Duration(seconds: 2));

    print("Login với: $email / $password");

    _isLoading = false;
    notifyListeners(); // Báo UI tắt loading
  }
}
