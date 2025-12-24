import '../models/category_model.dart';
import '../services/base_client.dart';
import '../../configs/app_config.dart';

class CategoryService {
  Future<List<Category>> getCategories() async {
    // 1. Check Mock (Nếu muốn)
    // if (AppConfig.mockCategory) return MockData.categories;

    // 2. Gọi API
    final url = '${AppConfig.baseUrl}/categories';

    try {
      final response = await BaseClient.get(url);

      // 3. Parse kết quả
      if (response is List) {
        return response
            .map((json) => Category.fromJson(json))
            // --- THÊM BỘ LỌC TẠI ĐÂY ---
            .where((category) => category.active == true) // Chỉ lấy active
            .toList();
      }
      return [];
    } catch (e) {
      print("Lỗi Get Categories: $e");
      return [];
    }
  }
}
