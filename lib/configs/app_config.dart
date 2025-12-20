class AppConfig {
  // Config chung
  static const String baseUrl = 'http://100.127.71.42:6868/api/v1';

  // --- CÔNG TẮC CHI TIẾT ---

  // 1. Auth (Đăng nhập/Đăng ký): Đã xong API -> Tắt Mock
  static const bool mockAuth = false;

  // 2. Product List (Danh sách): Đã xong API -> Tắt Mock
  static const bool mockProductList = false;

  // 3. Product Detail (Chi tiết): Backend chưa làm -> Bật Mock
  static const bool mockProductDetail = false;

  // 4. Cart (Giỏ hàng): Backend chưa làm -> Bật Mock
  static const bool mockCart = false;

  static const bool mockCheckout = false; // BẬT MOCK CHECKOUT
  static const bool mockOrder = true; // BẬT MOCK ORDER
  static const bool mockNotification = true;
}
