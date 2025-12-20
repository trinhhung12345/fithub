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
      // BaseClient tự động gắn Token
      final json = await BaseClient.get(url);

      // JSON trả về dạng: { code: 200, data: {...}, message: "..." }
      if (json['code'] == 200 && json['data'] != null) {
        return Product.fromJson(json['data']);
      }

      return null;
    } catch (e) {
      print("Lỗi lấy chi tiết SP: $e");
      return null;
    }
  }
}
