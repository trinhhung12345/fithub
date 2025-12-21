import '../models/order_model.dart';
import '../services/base_client.dart';
import '../../configs/app_config.dart';
import '../../core/utils/token_utils.dart';

class OrderService {
  Future<List<OrderModel>> getMyOrders() async {
    // 1. Check Mock
    if (AppConfig.mockOrder) {
      return []; // Hoặc return MockData.orders nếu chưa muốn tắt
    }

    // 2. Lấy UserId
    final userId = await TokenUtils.getUserId();
    if (userId == null) return [];

    // 3. Cấu hình URL: .../orders/myOrder?userId=...
    final url = '${AppConfig.baseUrl}/orders/myOrder?userId=$userId';

    try {
      // 4. Gọi API (BaseClient tự gắn Token)
      final json = await BaseClient.get(url);

      // 5. Parse kết quả
      // API trả về: { code: 200, data: [ ...list orders... ] }
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
}
