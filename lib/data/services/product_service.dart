import '../models/product_model.dart';
import '../services/base_client.dart';
import '../../configs/app_config.dart';
import '../mock/mock_data.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../data/local/app_preferences.dart';
import 'dart:convert';

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

  Future<bool> addProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required int categoryId,
    List<File>? images,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/products');
    final token = await AppPreferences.getToken();

    // 1. Tự tạo Boundary (Vách ngăn dữ liệu)
    final String boundary =
        '---FitHubBoundary${DateTime.now().millisecondsSinceEpoch}';

    // 2. Cấu hình Header thủ công (Đảm bảo có boundary và KHÔNG có charset)
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data; boundary=$boundary',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    // 3. Xây dựng Body (Dữ liệu)
    final List<int> bodyBytes = [];

    // Hàm tiện ích để thêm field text
    void addFormField(String key, String value) {
      bodyBytes.addAll('--$boundary\r\n'.codeUnits);
      bodyBytes.addAll(
        'Content-Disposition: form-data; name="$key"\r\n\r\n'.codeUnits,
      );
      bodyBytes.addAll(utf8.encode(value)); // Encode utf8 để hỗ trợ tiếng Việt
      bodyBytes.addAll('\r\n'.codeUnits);
    }

    // Thêm các trường Text
    addFormField('name', name);
    addFormField('description', description);
    addFormField('price', price.toString());
    addFormField('stock', stock.toString());
    addFormField('categoryId', categoryId.toString());

    // 4. Thêm File (Ảnh)
    if (images != null) {
      for (var image in images) {
        final String filename = image.path.split('/').last;
        final List<int> imageBytes = await image.readAsBytes();

        bodyBytes.addAll('--$boundary\r\n'.codeUnits);
        bodyBytes.addAll(
          'Content-Disposition: form-data; name="files"; filename="$filename"\r\n'
              .codeUnits,
        );
        // Content-Type của ảnh (tùy chọn, Spring Boot thường tự nhận)
        bodyBytes.addAll('Content-Type: image/jpeg\r\n\r\n'.codeUnits);
        bodyBytes.addAll(imageBytes);
        bodyBytes.addAll('\r\n'.codeUnits);
      }
    }

    // 5. Kết thúc Body
    bodyBytes.addAll('--$boundary--\r\n'.codeUnits);

    try {
      // 6. Gửi Request
      final request = http.Request('POST', url);
      request.headers.addAll(headers);
      request.bodyBytes = bodyBytes;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print("Lỗi upload thủ công: $e");
      return false;
    }
  }

  Future<bool> updateProduct({
    required int id,
    required String name,
    required String description,
    required double price,
    required int stock,
    required int categoryId,
    List<dynamic>?
    finalImages, // List chứa cả File (ảnh mới) và String (URL ảnh cũ)
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/products');
    final token = await AppPreferences.getToken();
    final boundary =
        '---FitHubBoundary${DateTime.now().millisecondsSinceEpoch}';

    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data; boundary=$boundary',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final List<int> bodyBytes = [];

    void addFormField(String key, String value) {
      bodyBytes.addAll('--$boundary\r\n'.codeUnits);
      bodyBytes.addAll(
        'Content-Disposition: form-data; name="$key"\r\n\r\n'.codeUnits,
      );
      bodyBytes.addAll(utf8.encode(value));
      bodyBytes.addAll('\r\n'.codeUnits);
    }

    // 1. Thêm các trường Text (Bao gồm cả ID)
    addFormField('id', id.toString()); // <-- QUAN TRỌNG
    addFormField('name', name);
    addFormField('description', description);
    addFormField('price', price.toString());
    addFormField('stock', stock.toString());
    addFormField('categoryId', categoryId.toString());

    // 2. Xử lý Ảnh (Logic phức tạp ở đây)
    if (finalImages != null) {
      for (var img in finalImages) {
        List<int>? imageBytes;
        String filename = "image.jpg";

        if (img is File) {
          // A. Ảnh mới (File từ máy)
          imageBytes = await img.readAsBytes();
          filename = img.path.split('/').last;
        } else if (img is String && img.startsWith('http')) {
          // B. Ảnh cũ (URL) -> Phải tải về rồi mới gửi lại được
          try {
            final uri = Uri.parse(img);
            final response = await http.get(uri);
            if (response.statusCode == 200) {
              imageBytes = response.bodyBytes;
              filename = uri.pathSegments.last;
            }
          } catch (e) {
            print("Lỗi tải ảnh cũ để re-upload: $e");
          }
        }

        // Nếu có data ảnh thì đóng gói vào body
        if (imageBytes != null) {
          bodyBytes.addAll('--$boundary\r\n'.codeUnits);
          bodyBytes.addAll(
            'Content-Disposition: form-data; name="files"; filename="$filename"\r\n'
                .codeUnits,
          );
          bodyBytes.addAll('Content-Type: image/jpeg\r\n\r\n'.codeUnits);
          bodyBytes.addAll(imageBytes);
          bodyBytes.addAll('\r\n'.codeUnits);
        }
      }
    }

    bodyBytes.addAll('--$boundary--\r\n'.codeUnits);

    try {
      // 3. Gửi PUT Request
      final request = http.Request('PUT', url);
      request.headers.addAll(headers);
      request.bodyBytes = bodyBytes;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Update Status: ${response.statusCode}");
      print("Update Body: ${response.body}");

      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      print("Lỗi update: $e");
      return false;
    }
  }
}
