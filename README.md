# FitHub - Fitness & E-commerce App

FitHub là ứng dụng di động được xây dựng bằng **Flutter**, kết hợp giữa thương mại điện tử (bán dụng cụ thể thao) và các tính năng hỗ trợ tập luyện (hướng dẫn bài tập, cộng đồng, quản lý lộ trình).

Dự án được thiết kế theo kiến trúc **MVVM (Model - View - ViewModel)** kết hợp với **Provider** để quản lý trạng thái, đảm bảo tính mở rộng (scalability) và dễ bảo trì (maintainability).

## 📱 Tech Stack

*   **Framework:** Flutter
*   **Language:** Dart
*   **State Management:** Provider
*   **Architecture:** MVVM (Model-View-ViewModel)
*   **Fonts:** Google Fonts (Bricolage Grotesque & Inter)
*   **Networking:** HTTP (http package)
*   **Local Storage:** Shared Preferences
*   **Authentication:** JWT Decoder
*   **Image Handling:** Image Picker, Path Provider

## 📂 Cấu trúc dự án (Project Structure)

Dự án được tổ chức theo cấu trúc phân tách rõ ràng giữa **Giao diện (UI)**, **Logic (Business Logic)** và **Cấu hình (Configuration)**.

```text
lib/
├── configs/                 # CẤU HÌNH GIAO DIỆN & TÀI NGUYÊN
│   ├── app_assets.dart      # Quản lý đường dẫn ảnh, icon, logo (String constants)
│   ├── app_colors.dart      # Bảng màu toàn cục (Brand colors, background...)
│   ├── app_config.dart      # Cấu hình API endpoints và mock flags
│   └── app_text_styles.dart # Cấu hình Typography (Font, Size, Weight)
│
├── core/                    # THÀNH PHẦN CỐT LÕI (DÙNG CHUNG)
│   ├── components/          # Các Widget tái sử dụng (Custom Buttons, TextFields...)
│   │   ├── fit_hub_button.dart
│   │   └── fit_hub_text_field.dart
│   └── utils/               # Các hàm tiện ích (Format date, Validate email...)
│
├── data/                    # LỚP DỮ LIỆU
│   ├── models/              # Data Models (Object mapping từ JSON)
│   └── services/            # API Services (Gọi HTTP requests)
│
├── modules/                 # CÁC TÍNH NĂNG (SCREENS) - MVVM
│   ├── auth/                # Module Xác thực (Đăng nhập/Đăng ký)
│   │   ├── view/            # UI: Chỉ chứa code giao diện (LoginScreen, RegisterScreen)
│   │   └── view_model/      # Logic: Xử lý trạng thái, gọi API (LoginViewModel...)
│   └── splash/              # Module Màn hình chờ
│       └── view/
│
└── main.dart                # ĐIỂM KHỞI CHẠY (Entry Point & Provider Setup)
```

## 📖 Giải thích chi tiết các thư mục
1. lib/configs/ (Design System)
Nơi tập trung mọi cấu hình về giao diện. Giúp đồng bộ thiết kế toàn app.
Nếu muốn đổi màu chủ đạo từ Cam sang Xanh -> Chỉ cần sửa app_colors.dart.
Nếu muốn đổi Font chữ -> Chỉ cần sửa app_text_styles.dart.
2. lib/core/ (Core Components)
Chứa các thành phần không phụ thuộc vào logic nghiệp vụ cụ thể nào ("Dumb Widgets").
Ví dụ: FitHubButton là một nút bấm có style chuẩn của App. Nó có thể được dùng ở màn hình Login, màn hình Thanh toán, hay màn hình Profile.
3. lib/modules/ (Features - MVVM)
Đây là nơi chứa code chính của các màn hình. Mỗi tính năng (Feature) sẽ là một thư mục riêng (Auth, Home, Product, Cart...). Bên trong mỗi module chia làm 2 phần:
View: Chịu trách nhiệm hiển thị UI, nhận input từ người dùng. View không xử lý logic phức tạp (như gọi API).
ViewModel: Chịu trách nhiệm giữ trạng thái (State) của màn hình (ví dụ: isLoading, errorMessage), xử lý logic và gọi xuống lớp Data.
4. lib/data/ (Data Layer)
Models: Định nghĩa cấu trúc dữ liệu (User, Product...).
Services: Nơi thực hiện các cuộc gọi API (GET, POST...). ViewModel sẽ gọi các hàm trong Service để lấy dữ liệu.

## 🚀 Tính năng chính (Key Features)

*   **🔐 Xác thực (Authentication)**
    *   Đăng nhập/Đăng ký tài khoản
    *   Quên mật khẩu
    *   JWT token management

*   **🏠 Trang chủ (Home)**
    *   Banner quảng cáo
    *   Danh mục sản phẩm
    *   Sản phẩm nổi bật

*   **🛍️ Sản phẩm (Products)**
    *   Danh sách sản phẩm theo danh mục
    *   Chi tiết sản phẩm
    *   Tìm kiếm sản phẩm
    *   Lọc và sắp xếp (giá, tên, mới nhất)

*   **🛒 Giỏ hàng (Cart)**
    *   Thêm/xóa sản phẩm
    *   Cập nhật số lượng
    *   Tính tổng tiền

*   **💳 Thanh toán (Checkout)**
    *   Điền thông tin giao hàng
    *   Chọn phương thức thanh toán
    *   Xác nhận đơn hàng

*   **📦 Đơn hàng (Orders)**
    *   Lịch sử đơn hàng
    *   Chi tiết đơn hàng
    *   Theo dõi trạng thái

*   **👤 Hồ sơ (Profile)**
    *   Thông tin cá nhân
    *   Chỉnh sửa profile
    *   Đăng xuất

*   **🔍 Tìm kiếm (Search)**
    *   Tìm kiếm theo từ khóa
    *   Lọc kết quả

*   **📢 Thông báo (Notifications)**
    *   Push notifications
    *   Lịch sử thông báo

*   **💬 Chatbot**
    *   Hỗ trợ tư vấn sản phẩm
    *   Hướng dẫn sử dụng

## 🛠️ Cài đặt và Chạy (Installation & Setup)

### Yêu cầu hệ thống
*   Flutter SDK: ^3.9.0
*   Dart SDK: ^3.9.0
*   Android Studio / VS Code
*   Android SDK / Xcode (cho iOS)

### Các bước cài đặt

1. **Clone repository:**
   ```bash
   git clone https://github.com/trinhhung12345/fithub.git
   cd fithub
   ```

2. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```

3. **Chạy ứng dụng:**
   ```bash
   # Chạy trên Android
   flutter run

   # Chạy trên iOS (chỉ trên macOS)
   flutter run --platform ios

   # Chạy trên Web
   flutter run --platform web
   ```

4. **Build release:**
   ```bash
   # Build APK Android
   flutter build apk --release

   # Build iOS (chỉ trên macOS)
   flutter build ios --release
   ```

## 🔗 API Backend

Ứng dụng sử dụng REST API với backend server tại:
```
Base URL: https://mobile-backend-x50a.onrender.com/api/v1
```

### Các endpoint chính:
*   `POST /auth/login` - Đăng nhập
*   `POST /auth/register` - Đăng ký
*   `GET /products` - Danh sách sản phẩm
*   `GET /products/{id}` - Chi tiết sản phẩm
*   `POST /orders` - Tạo đơn hàng
*   `GET /orders` - Lịch sử đơn hàng

## ⚙️ Cấu hình Mock Data

Trong `lib/configs/app_config.dart`, bạn có thể bật/tắt chế độ mock data:

```dart
class AppConfig {
  static const String baseUrl = 'https://mobile-backend-x50a.onrender.com/api/v1';

  // Bật mock data khi backend chưa sẵn sàng
  static const bool mockAuth = false;           // Xác thực
  static const bool mockProductList = false;    // Danh sách sản phẩm
  static const bool mockProductDetail = false;  // Chi tiết sản phẩm
  static const bool mockCart = false;           // Giỏ hàng
  static const bool mockCheckout = false;       // Thanh toán
  static const bool mockOrder = false;          // Đơn hàng
  static const bool mockNotification = true;    // Thông báo
}
```

## 📦 Dependencies

### Core Dependencies:
*   **provider:** `^6.1.1` - State management cho MVVM pattern
*   **http:** `^1.2.0` - HTTP client cho API calls
*   **shared_preferences:** `^2.2.2` - Lưu trữ dữ liệu local
*   **google_fonts:** `^6.1.0` - Font chữ Bricolage Grotesque & Inter

### Authentication & Security:
*   **jwt_decoder:** `^2.0.1` - Decode JWT tokens
*   **intl:** `^0.20.2` - Internationalization support

### Media & Files:
*   **image_picker:** `^1.0.7` - Chọn ảnh từ gallery/camera
*   **path_provider:** `^2.1.2` - Truy cập đường dẫn file system

### Development:
*   **flutter_lints:** `^5.0.0` - Code linting rules
*   **integration_test:** & **flutter_test:** - Testing frameworks

## 🏗️ Ví dụ kiến trúc MVVM

### ViewModel (Business Logic)
```dart
class ProductListViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productService.getProducts();
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
```

### View (UI)
```dart
class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductListViewModel>();

    return Scaffold(
      body: viewModel.isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: viewModel.products.length,
              itemBuilder: (context, index) {
                final product = viewModel.products[index];
                return ProductCard(product: product);
              },
            ),
    );
  }
}
```

### Service (Data Layer)
```dart
class ProductService {
  final String baseUrl = AppConfig.baseUrl;

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
```
