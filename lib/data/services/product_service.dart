import '../services/base_client.dart';
import '../models/product_model.dart';

class ProductService {
  // Thay IP và Port của bạn vào đây
  static const String baseUrl = 'http://100.127.71.42:6868/api/v1';

  Future<List<Product>> getProducts() async {
    final url = '$baseUrl/products';

    // Gọi BaseClient.get (Tự động kèm Token)
    final response = await BaseClient.get(url);

    // API trả về 1 List JSON: [{...}, {...}]
    if (response is List) {
      return response.map((json) => Product.fromJson(json)).toList();
    }

    // Trường hợp API trả về dạng Pageable { content: [...] } thì xử lý khác
    // Nhưng theo dữ liệu bạn đưa thì nó là List trực tiếp.
    return [];
  }
}
