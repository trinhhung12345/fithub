import '../models/order_model.dart';
import '../services/base_client.dart';
import '../../configs/app_config.dart';
import '../../core/utils/token_utils.dart';

class OrderService {
  // Hàm lấy danh sách đơn hàng (URL Mới: /orders/my)
  Future<List<OrderModel>> getMyOrders() async {
    // 1. Check Mock
    if (AppConfig.mockOrder) {
      return [];
    }

    // 2. Cấu hình URL
    // Không cần lấy userId thủ công nữa, Backend tự lấy từ Token
    final url = '${AppConfig.baseUrl}/orders/my';

    try {
      // 3. Gọi API (BaseClient tự gắn Token)
      final json = await BaseClient.get(url);

      // 4. Parse kết quả
      // JSON trả về: { "code": 200, "data": [ ...list... ] }
      if (json['code'] == 200 && json['data'] is List) {
        return (json['data'] as List)
            .map((e) => OrderModel.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      print("Lỗi Get Orders: $e");
      return [];
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    // 1. Check Mock
    if (AppConfig.mockOrder) return true;

    // 2. URL: .../orders/{id}
    final url = '${AppConfig.baseUrl}/orders/$orderId';

    // 3. Body: { "status": "CANCEL" }
    final body = {"status": "CANCEL"};

    try {
      // Gọi PUT
      final json = await BaseClient.put(url, body);

      // API trả về code 200 là thành công
      if (json['code'] == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Lỗi Cancel Order: $e");
      return false;
    }
  }
}
