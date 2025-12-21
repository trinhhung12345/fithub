import 'package:intl/intl.dart';

class OrderModel {
  final int id;
  final String status; // VD: "NEW"
  final double totalAmount;
  final String? createdAt; // API trả về null hoặc String date
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.status,
    required this.totalAmount,
    this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List? ?? [];
    List<OrderItem> itemsList = list.map((i) => OrderItem.fromJson(i)).toList();

    return OrderModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? "UNKNOWN",
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      createdAt: json['createdAt'],
      items: itemsList,
    );
  }

  // Helper: Đếm số lượng sản phẩm (để hiển thị lên Card)
  int get totalItemCount {
    int count = 0;
    for (var item in items) {
      count += item.quantity;
    }
    return count;
  }

  // Helper: Format tiền
  String get formattedTotal {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatCurrency.format(totalAmount);
  }
}

class OrderItem {
  final int productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? "",
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
