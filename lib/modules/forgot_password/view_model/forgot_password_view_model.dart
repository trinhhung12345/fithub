import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> submitRequest(String email) async {
    if (email.isEmpty || !email.contains('@')) {
      // Validate sơ bộ
      return false;
    }

    _isLoading = true;
    notifyListeners();

    final success = await _authService.requestNewPassword(email);

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
