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

  // 2. Lấy chi tiết (Backend chưa làm -> dùng Config.mockProductDetail = true)
  Future<Product?> getProductDetail(int id) async {
    if (AppConfig.mockProductDetail) {
      await Future.delayed(const Duration(seconds: 1));
      // Lọc tìm trong list giả
      return MockData.products.firstWhere(
        (p) => p.id == id,
        orElse: () => MockData.products[0],
      );
    }

    // Code API thật (Chờ backend làm xong thì viết vào đây sau)
    final response = await BaseClient.get('${AppConfig.baseUrl}/products/$id');
    return Product.fromJson(response);
  }
}
