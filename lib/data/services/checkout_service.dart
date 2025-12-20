import '../services/base_client.dart';
import '../../configs/app_config.dart';
import '../../core/utils/token_utils.dart';

class CheckoutService {
  // Hàm gọi API tạo đơn hàng
  Future<bool> createOrder() async {
    // 1. Check Mock
    if (AppConfig.mockCheckout) {
      // Logic mock cũ (nếu có)
      return true;
    }

    // 2. Lấy UserId
    final userId = await TokenUtils.getUserId();
    if (userId == null) return false;

    // 3. Cấu hình URL và Body
    final url = '${AppConfig.baseUrl}/orders';
    final body = {"userId": userId};

    try {
      // 4. Gọi POST
      final json = await BaseClient.post(url, body);

      // 5. Kiểm tra kết quả
      // API trả về: { "code": 200, "data": {...}, "message": "Successful!" }
      if (json['code'] == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Lỗi tạo đơn hàng: $e");
      return false;
    }
  }
}
