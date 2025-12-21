import '../models/review_model.dart';
import '../services/base_client.dart';
import '../../configs/app_config.dart';
import '../../core/utils/token_utils.dart';

class ReviewService {
  Future<List<Review>> getProductReviews(int productId) async {
    // Check Mock nếu cần (hoặc dùng chung cờ mockProductDetail)
    // if (AppConfig.mockProductDetail) return [];

    final url = '${AppConfig.baseUrl}/reviews/product/$productId';

    try {
      final json = await BaseClient.get(url);

      // API trả về: { code: 200, data: [...list review...], ... }
      if (json['code'] == 200 && json['data'] is List) {
        return (json['data'] as List).map((e) => Review.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Lỗi Get Reviews: $e");
      return [];
    }
  }

  // --- THÊM HÀM NÀY ---
  Future<Map<String, dynamic>> createReview({
    required int productId,
    required int rating,
    required String comment,
  }) async {
    // 1. Check Mock
    if (AppConfig.mockProductDetail) {
      // Hoặc cờ mockReview nếu có
      return {"success": true, "message": "Mock review thành công"};
    }

    // 2. Lấy UserId
    final userId = await TokenUtils.getUserId();
    if (userId == null) {
      return {"success": false, "message": "Bạn cần đăng nhập để đánh giá"};
    }

    final url = '${AppConfig.baseUrl}/reviews';

    // 3. Body request
    final body = {
      "productId": productId,
      "userId": userId,
      "rating": rating,
      "comment": comment,
    };

    try {
      final json = await BaseClient.post(url, body);

      // 4. Xử lý kết quả
      // Thành công: code 200
      if (json['code'] == 200) {
        return {"success": true, "message": "Đánh giá thành công!"};
      }
      // Lỗi logic (VD: Đã đánh giá rồi): code 400
      else if (json['code'] == 400) {
        return {
          "success": false,
          "message": json['message'] ?? "Bạn đã đánh giá sản phẩm này rồi",
        };
      }

      return {
        "success": false,
        "message": json['message'] ?? "Lỗi không xác định",
      };
    } catch (e) {
      print("Lỗi Post Review: $e");
      return {"success": false, "message": "Lỗi kết nối: $e"};
    }
  }

  Future<Map<String, dynamic>> updateReview({
    required int reviewId, // <-- Thay productId bằng reviewId
    required int rating,
    required String comment,
  }) async {
    // 1. Check Mock
    if (AppConfig.mockProductDetail) {
      return {"success": true, "message": "Mock update thành công"};
    }

    final userId = await TokenUtils.getUserId();
    if (userId == null) return {"success": false, "message": "Chưa đăng nhập"};

    // 2. URL: .../reviews/{reviewId} (ID của bài đánh giá)
    final url = '${AppConfig.baseUrl}/reviews/$reviewId';

    // Body vẫn cần gửi thông tin để backend validate/update
    final body = {"userId": userId, "rating": rating, "comment": comment};

    try {
      final json = await BaseClient.put(url, body);
      if (json['code'] == 200) {
        return {"success": true, "message": "Cập nhật thành công!"};
      }
      return {"success": false, "message": json['message'] ?? "Lỗi cập nhật"};
    } catch (e) {
      print("Lỗi Update Review: $e");
      return {"success": false, "message": "Lỗi kết nối: $e"};
    }
  }
}
