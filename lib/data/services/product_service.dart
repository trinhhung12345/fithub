import '../models/product_model.dart';
import '../services/base_client.dart';
import '../../configs/app_config.dart';
import '../mock/mock_data.dart';

class ProductService {
  // 1. Lấy danh sách (Backend đã xong -> dùng Config.mockProductList)
  Future<List<Product>> getProducts() async {
    // Nếu đang bật Mock HOẶC Server đang tắt (bạn tự bật tay)
    if (AppConfig.mockProductList) {
      await Future.delayed(const Duration(seconds: 1));
      return MockData.products; // List giả
    }

    // Code gọi API thật
    try {
      final response = await BaseClient.get('${AppConfig.baseUrl}/products');
      if (response is List) {
        return response.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Mẹo: Nếu gọi API thật bị lỗi (do Server tắt), tự động fallback về Mock
      print("⚠️ Server sập/tắt, chuyển sang dùng Mock Data tạm!");
      return MockData.products;
    }
  }

  Future<Product?> getProductDetail(int id) async {
    // 1. Kiểm tra Mock
    if (AppConfig.mockProductDetail) {
      await Future.delayed(const Duration(seconds: 1));
      return MockData.products.firstWhere(
        (p) => p.id == id,
        orElse: () => MockData.productDetail,
      );
    }

    // 2. Gọi API thật
    final url = '${AppConfig.baseUrl}/products/$id';

    try {
      final json = await BaseClient.get(url);

      // In ra JSON nhận được để kiểm tra
      print("🔍 JSON API Detail: $json");

      if (json['code'] == 200 && json['data'] != null) {
        return Product.fromJson(json['data']);
      }
      return null;
    } catch (e, stackTrace) {
      // Thêm stackTrace để dò lỗi sâu hơn
      print("🔥 Lỗi CRITICAL lấy chi tiết SP: $e");
      print(stackTrace);
      return null;
    }
  }

  Future<List<Product>> searchProducts(String keyword) async {
    // 1. Check Mock (nếu cần)
    if (AppConfig.mockProductList) {
      // Logic mock cũ hoặc trả về rỗng
      return [];
    }

    // 2. Cấu hình URL với Query Parameter
    // Lưu ý: encodeComponent để xử lý các ký tự đặc biệt hoặc khoảng trắng (VD: "iphone 15" -> "iphone%2015")
    final encodedKeyword = Uri.encodeComponent(keyword);
    final url = '${AppConfig.baseUrl}/products/search?keyword=$encodedKeyword';

    try {
      // 3. Gọi API (BaseClient tự gắn Token)
      final response = await BaseClient.get(url);

      // 4. Parse kết quả
      // API trả về List [...]
      if (response is List) {
        return response.map((json) => Product.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print("Lỗi Search: $e");
      return [];
    }
  }

  // --- THÊM HÀM NÀY ---
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    // 1. Check Mock
    if (AppConfig.mockProductList) {
      return []; // Hoặc logic mock
    }

    // 2. Cấu hình URL: /products/category/{id}
    final url = '${AppConfig.baseUrl}/products/category/$categoryId';

    try {
      // 3. Gọi API (BaseClient tự gắn Token)
      final response = await BaseClient.get(url);

      // 4. Parse kết quả (API trả về List)
      if (response is List) {
        return response.map((json) => Product.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print("Lỗi Get Products By Category: $e");
      return [];
    }
  }
}
