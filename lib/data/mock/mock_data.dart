import '../models/product_model.dart';
import '../models/cart_model.dart';

class MockData {
  // Dữ liệu giả cho danh sách sản phẩm
  static final List<Product> products = [
    Product(
      id: 1,
      name: "Găng tay tập Gym (Mock)",
      description: "Găng tay xịn xò",
      price: 150000,
      stock: 10,
      mockImage:
          "https://example.com/gang-tay.png", // Dùng link ảnh mạng bất kỳ
    ),
    Product(
      id: 2,
      name: "Thảm Yoga Định Tuyến (Mock)",
      description: "Thảm êm ái",
      price: 300000,
      stock: 5,
      mockImage: "https://example.com/tham-yoga.png",
    ),
    // ... Thêm bao nhiêu tùy thích
  ];

  // Dữ liệu giả cho user
  static const Map<String, dynamic> userProfile = {
    "id": 1,
    "name": "Nguyễn Văn A (Mock)",
    "email": "test@gmail.com",
    "phone": "0999999999",
  };

  // Dữ liệu chi tiết 1 sản phẩm (Full option)
  static final Product productDetail = Product(
    id: 1,
    name:
        "Đệm Bảo Vệ Đầu Gối Điều Chỉnh Aolikes A-7929 - Dán Bảo Vệ Khớp Gối Chính Hãng",
    description:
        "Đệm bảo vệ khớp gối chất liệu neoprene, co giãn, điều chỉnh linh hoạt. Hỗ trợ tốt cho các bài tập nặng...",
    price: 148000,
    stock: 123, // "Còn lại"
    // Các trường giả lập thêm (Model chưa có thì cứ tạo biến riêng hoặc map vào description nếu lười sửa Model)
  );

  // List ảnh giả (Carousel)
  static final List<String> detailImages = [
    "https://img.lazcdn.com/g/p/65c82971206d0b6378e907c132170366.jpg_720x720q80.jpg",
    "https://vn-test-11.slatic.net/p/e9803023530349896409893963409834.jpg",
    "https://cf.shopee.vn/file/5a5639634d078762586716867386.jpg",
  ];

  // List Review giả
  static final List<Map<String, dynamic>> reviews = [
    {
      "name": "Alex Morgan",
      "avatar": "https://i.pravatar.cc/150?img=1",
      "rating": 5,
      "date": "12 days ago",
      "content":
          "Sản phẩm rất tốt, đóng gói cẩn thận. Đeo vào cảm giác chắc chắn hẳn.",
    },
    {
      "name": "Trần Hữu Hùng",
      "avatar": "https://i.pravatar.cc/150?img=3",
      "rating": 4,
      "date": "2 days ago",
      "content": "Giao hàng hơi chậm nhưng hàng chất lượng.",
    },
  ];

  static final List<CartItem> cartItems = [
    CartItem(
      id: 101,
      product: Product(
        id: 1,
        name: "Găng tay tập Gym thoáng khí",
        description: "",
        price: 150000,
        stock: 100,
        mockImage: "https://cf.shopee.vn/file/5a5639634d078762586716867386.jpg",
      ),
      quantity: 2,
    ),
    CartItem(
      id: 102,
      product: Product(
        id: 2,
        name: "iPhone 15 Pro Max",
        description: "",
        price: 34990000,
        stock: 10,
        // mockImage tự xử lý trong Model Product
      ),
      quantity: 1,
    ),
  ];
}
