class OrderModel {
  final String id; // Mã đơn hàng hiển thị (VD: #456765)
  final String status; // Trạng thái: "Đang xử lý", "Đã giao", ...
  final int itemCount; // Số lượng món
  final DateTime date;

  OrderModel({
    required this.id,
    required this.status,
    required this.itemCount,
    required this.date,
  });
}
