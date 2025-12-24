import '../models/user_model.dart';
import '../services/base_client.dart';
import '../../configs/app_config.dart';

class UserService {
  Future<UserModel?> getProfile() async {
    // URL: .../users/me
    final url = '${AppConfig.baseUrl}/users/me';

    try {
      // Gọi API (BaseClient tự gắn Token)
      final response = await BaseClient.get(url);

      // JSON: { "code": 200, "data": { ... } }
      if (response['code'] == 200 && response['data'] != null) {
        return UserModel.fromJson(response['data']);
      }

      return null;
    } catch (e) {
      print("Lỗi Get Profile: $e");
      return null;
    }
  }

  Future<UserModel?> updateProfile({
    required String name,
    required String phone,
    required String address,
    required String birthday, // Định dạng YYYY-MM-DD
  }) async {
    final url = '${AppConfig.baseUrl}/users/me';

    final body = {
      "name": name,
      "phone": phone,
      "address": address,
      "birthday": birthday,
    };

    try {
      // Gọi PUT
      final json = await BaseClient.put(url, body);

      // Nếu thành công, API trả về thông tin user mới nhất
      if (json['code'] == 200 && json['data'] != null) {
        return UserModel.fromJson(json['data']);
      }

      return null;
    } catch (e) {
      print("Lỗi Update Profile: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = '${AppConfig.baseUrl}/users/me/password';

    final body = {"oldPassword": oldPassword, "newPassword": newPassword};

    try {
      // Gọi PUT
      final json = await BaseClient.put(url, body);

      // Xử lý kết quả
      // API trả về: { "code": 200, "message": "Password changed successfully" }
      if (json['code'] == 200) {
        return {"success": true, "message": json['message']};
      }

      // Trường hợp lỗi (Ví dụ sai mật khẩu cũ, code có thể là 400 hoặc 401)
      return {
        "success": false,
        "message": json['message'] ?? "Đổi mật khẩu thất bại",
      };
    } catch (e) {
      print("Lỗi Change Password: $e");
      return {"success": false, "message": "Lỗi kết nối: $e"};
    }
  }
}
