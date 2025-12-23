import '../models/cart_model.dart';
import '../services/base_client.dart'; // Dùng để gọi API có kèm Token
import '../../configs/app_config.dart'; // Lấy baseUrl
import '../../core/utils/token_utils.dart'; // Lấy userId từ token

class CartService {
  // --- THÊM HÀM NÀY ---
  Future<CartResponse?> getCart() async {
    // 1. Kiểm tra Mock
    if (AppConfig.mockCart) {
      return null;
    }

    // 2. Cấu hình URL
    // Endpoint mới không cần truyền userId vào đường dẫn
    final url = '${AppConfig.baseUrl}/cart/my';

    try {
      // 3. Gọi API (BaseClient sẽ tự động gắn Token vào Header)
      final json = await BaseClient.get(url);

      // 4. Parse kết quả
      // Cấu trúc JSON vẫn khớp với Model CartResponse đã tạo
      return CartResponse.fromJson(json);
    } catch (e) {
      print("Lỗi Get Cart: $e");

      // Xử lý lỗi: Nếu server trả 404 (chưa có giỏ) hoặc lỗi khác
      // Trả về giỏ hàng rỗng để UI không bị crash
      return CartResponse(
        cartId: 0,
        totalPrice: 0,
        totalQuantity: 0,
        items: [],
      );
    }
  }

  // Hàm thêm sản phẩm vào giỏ hàng
  // Trả về CartResponse (chứa danh sách items mới nhất từ server)
  Future<CartResponse?> addToCart(int productId, int quantity) async {
    // 1. Kiểm tra nếu đang dùng chế độ Mock (Giả lập)
    if (AppConfig.mockCart) {
      // Nếu đang mock, bạn có thể return null hoặc giả lập dữ liệu ở đây
      // Nhưng vì ta đang tích hợp API thật, đoạn này để chặn lại thôi.
      print("Đang dùng Mock Cart, không gọi API thật.");
      return null;
    }

    // 2. Lấy UserId từ Token (Giải mã JWT)
    // Vì body request yêu cầu "userId": 5
    final userId = await TokenUtils.getUserId();

    if (userId == null) {
      print("Lỗi: Không tìm thấy UserID (Token hết hạn hoặc chưa đăng nhập)");
      return null;
    }

    // 3. Cấu hình URL và Body
    final url = '${AppConfig.baseUrl}/cart/add';

    final body = {
      "userId": userId, // Lấy từ token
      "productId": productId, // Truyền vào
      "quantity": quantity, // Truyền vào
    };

    try {
      // 4. Gọi API qua BaseClient
      // BaseClient đã tự động gắn Header: Authorization: Bearer ...
      final json = await BaseClient.post(url, body);

      // 5. Parse kết quả trả về
      // JSON trả về có dạng: { "cartId": 6, "items": [...], "totalPrice": ... }
      return CartResponse.fromJson(json);
    } catch (e) {
      print("Lỗi Add to Cart: $e");
      return null;
    }
  }

  // 1. Cập nhật số lượng (PUT hoặc POST)
  Future<CartResponse?> updateCartItem(int productId, int newQuantity) async {
    if (AppConfig.mockCart) return null;

    final userId = await TokenUtils.getUserId();
    if (userId == null) return null;

    final url = '${AppConfig.baseUrl}/cart/update';

    // Body theo yêu cầu: userId, productId, quantity
    final body = {
      "userId": userId,
      "productId": productId,
      "quantity": newQuantity,
    };

    try {
      // Gọi method PUT vừa tạo ở BaseClient
      final json = await BaseClient.put(url, body);
      return CartResponse.fromJson(json);
    } catch (e) {
      print("Lỗi Update Cart: $e");
      return null;
    }
  }

  // 2. Xóa sản phẩm khỏi giỏ (DELETE hoặc POST)
  Future<CartResponse?> removeCartItem(int productId) async {
    if (AppConfig.mockCart) return null;

    final userId = await TokenUtils.getUserId();
    if (userId == null) return null;

    final url = '${AppConfig.baseUrl}/cart/remove';

    final body = {"userId": userId, "productId": productId};

    try {
      // --- SỬA THÀNH DELETE ---
      final json = await BaseClient.delete(url, body);
      return CartResponse.fromJson(json);
    } catch (e) {
      print("Lỗi Remove Cart: $e");
      return null;
    }
  }
}
