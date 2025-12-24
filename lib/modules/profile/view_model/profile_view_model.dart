import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _userService.getProfile();
    } catch (e) {
      print("Lỗi ViewModel Profile: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserInfo({
    required String name,
    required String phone,
    required String address,
    required String birthday,
  }) async {
    _isLoading = true;
    notifyListeners();

    final updatedUser = await _userService.updateProfile(
      name: name,
      phone: phone,
      address: address,
      birthday: birthday,
    );

    if (updatedUser != null) {
      _user = updatedUser; // Cập nhật dữ liệu local
      _isLoading = false;
      notifyListeners();
      return true; // Thành công
    } else {
      _isLoading = false;
      notifyListeners();
      return false; // Thất bại
    }
  }

  Future<String?> changePassword({
    required String oldPass,
    required String newPass,
    required String confirmPass,
  }) async {
    // 1. Validate Client
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      return "Vui lòng nhập đầy đủ thông tin";
    }
    if (newPass != confirmPass) {
      return "Mật khẩu xác nhận không khớp";
    }
    if (newPass.length < 6) {
      // Tuỳ chỉnh độ dài
      return "Mật khẩu mới phải từ 6 ký tự trở lên";
    }

    _isLoading = true;
    notifyListeners();

    // 2. Gọi Service
    final result = await _userService.changePassword(
      oldPassword: oldPass,
      newPassword: newPass,
    );

    _isLoading = false;
    notifyListeners();

    if (result['success'] == true) {
      return null; // Thành công
    } else {
      return result['message']; // Trả về lỗi từ server (VD: Sai mật khẩu cũ)
    }
  }
}
