import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../models/notification_model.dart';

class MockData {
  // Dữ liệu giả cho danh sách sản phẩm
  static final List<Product> products = [
    Product(
      id: 1,
      name: "Găng tay tập Gym (Mock)",
      description: "Găng tay xịn xò",
      price: 150000,
      stock: 10,
      mockImage: "https://example.com/gang-tay.png",
      active: true, // Dùng link ảnh mạng bất kỳ
    ),
    Product(
      id: 2,
      name: "Thảm Yoga Định Tuyến (Mock)",
      description: "Thảm êm ái",
      price: 300000,
      stock: 5,
      mockImage: "https://example.com/tham-yoga.png",
      active: true, // Dùng link ảnh mạng bất kỳ
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
    active: true,
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
      cartItemId: 101, // Đổi từ id thành cartItemId
      productId: 1, // Thêm productId
      product: Product(
        id: 1,
        name: "Găng tay tập Gym thoáng khí",
        description: "",
        price: 150000,
        stock: 100,
        mockImage: "https://cf.shopee.vn/file/5a5639634d078762586716867386.jpg",
        active: true, // Dùng link ảnh mạng bất kỳ
      ),
      quantity: 2,
    ),
    CartItem(
      cartItemId: 102, // Đổi từ id thành cartItemId
      productId: 2, // Thêm productId
      product: Product(
        id: 2,
        name: "iPhone 15 Pro Max",
        description: "",
        price: 34990000,
        stock: 10,
        active: true, // Dùng link ảnh mạng bất kỳ
        // mockImage tự xử lý trong Model Product
      ),
      quantity: 1,
    ),
  ];

  static final List<OrderModel> orders = [
    OrderModel(
      id: 456765,
      status: "Đang xử lý",
      totalAmount: 450000,
      createdAt: DateTime.now().toIso8601String(),
      items: [
        OrderItem(
          productId: 1,
          productName: "Găng tay tập Gym",
          quantity: 2,
          price: 150000,
        ),
        OrderItem(
          productId: 2,
          productName: "Thảm Yoga",
          quantity: 1,
          price: 150000,
        ),
      ],
    ),
    OrderModel(
      id: 354569,
      status: "Đã giao",
      totalAmount: 300000,
      createdAt: DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
      items: [
        OrderItem(
          productId: 1,
          productName: "Găng tay tập Gym",
          quantity: 2,
          price: 150000,
        ),
      ],
    ),
    OrderModel(
      id: 454809,
      status: "Đã hủy",
      totalAmount: 148000,
      createdAt: DateTime.now()
          .subtract(const Duration(days: 5))
          .toIso8601String(),
      items: [
        OrderItem(
          productId: 3,
          productName: "Đệm bảo vệ đầu gối",
          quantity: 1,
          price: 148000,
        ),
      ],
    ),
    OrderModel(
      id: 112233,
      status: "Đã giao",
      totalAmount: 750000,
      createdAt: DateTime.now()
          .subtract(const Duration(days: 10))
          .toIso8601String(),
      items: [
        OrderItem(
          productId: 1,
          productName: "Găng tay tập Gym",
          quantity: 5,
          price: 150000,
        ),
      ],
    ),
  ];

  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 1,
      content:
          "Gilbert, you placed and order check your order history for full details",
      isUnread: true, // Có chấm đỏ
      createdAt: DateTime.now(),
    ),
    NotificationModel(
      id: 2,
      content:
          "Gilbert, Thank you for shopping with us we have canceled order #24568.",
      isUnread: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 3,
      content:
          "Gilbert, your Order #24568 has been confirmed check your order history for full details",
      isUnread: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}
