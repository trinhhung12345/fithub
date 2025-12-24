import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart';
import '../../../data/models/order_model.dart';
import '../../../core/utils/order_status_helper.dart';
import 'package:provider/provider.dart';
import '../../../core/components/fit_hub_dialog.dart';
import '../view_model/order_view_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    bool canCancel = order.status == "NEW";
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Center(child: FitHubBackButton()),
        title: const Text(
          "Chi tiết đơn hàng",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // 1. Phần nội dung cuộn (Đã xóa nút bấm ở cuối)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusSection(),
            const SizedBox(height: 16),
            _buildAddressSection(),
            const SizedBox(height: 16),
            _buildItemsList(currencyFormat),
            const SizedBox(height: 16),
            _buildPaymentSummary(currencyFormat),

            // Thêm khoảng trắng để nội dung cuối không bị sát mép dưới nếu cuộn hết
            const SizedBox(height: 20),
          ],
        ),
      ),

      // 2. Ghim nút xuống đáy và xử lý Safe Area
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false, // Không cần tránh phần trên của container
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Nút HỦY ĐƠN (Chỉ hiện nếu canCancel = true)
                if (canCancel)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _confirmCancel(context);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Hủy đơn hàng",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                if (canCancel) const SizedBox(width: 16),

                // Nút MUA LẠI (Luôn hiện)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Logic Mua lại: Thường là add tất cả items vào giỏ rồi chuyển sang Cart
                      print("Mua lại đơn #${order.id}");
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 50),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Mua lại",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS CON ---

  Widget _buildStatusSection() {
    final statusInfo = OrderStatusHelper.getStatusInfo(order.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Viền màu bên trái để nhấn mạnh
        border: Border(left: BorderSide(color: statusInfo.color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon lớn
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusInfo.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusInfo.icon, color: statusInfo.color, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Đơn hàng #${order.id}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                statusInfo.text, // Text tiếng Việt (Đang giao, Hoàn thành...)
                style: TextStyle(
                  color: statusInfo.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Text(
                "Địa chỉ nhận hàng",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
          const Text(
            "Trinh Huu Hung",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text("0867276214", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          const Text("Hà Nội, Việt Nam", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildItemsList(NumberFormat format) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Danh sách sản phẩm",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  // Ảnh giả lập (Vì OrderItem API chưa trả về ảnh)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(_getMockImage(item.productName)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Thông tin
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "x${item.quantity}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              format.format(item.price),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(NumberFormat format) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            "Tạm tính",
            format.format(order.totalAmount),
          ), // Giả sử chưa trừ ship
          const SizedBox(height: 8),
          _buildSummaryRow("Phí vận chuyển", "0 đ"), // API chưa có ship
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Thành tiền",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                format.format(order.totalAmount),
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  // Hàm hiện Popup xác nhận hủy đơn
  void _confirmCancel(BuildContext context) {
    FitHubDialog.show(
      context,
      title: "Xác nhận hủy",
      content:
          "Bạn có chắc chắn muốn hủy đơn hàng này không? Thao tác này không thể hoàn tác.",
      isSuccess: false, // Icon cảnh báo
      buttonText: "Đồng ý hủy",
      onPressed: () async {
        // Gọi ViewModel
        final success = await context.read<OrderViewModel>().cancelOrder(
          order.id,
        );

        if (!context.mounted) return;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Đã hủy đơn hàng thành công"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Quay về danh sách đơn hàng
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Hủy thất bại, vui lòng thử lại"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  // Helper lấy ảnh giả giống ProductModel
  String _getMockImage(String name) {
    if (name.toLowerCase().contains("iphone"))
      return "https://cdn.tgdd.vn/Products/Images/42/305658/iphone-15-pro-max-blue-titan-1-750x500.jpg";
    if (name.toLowerCase().contains("cáp") ||
        name.toLowerCase().contains("sạc"))
      return "https://cdn.tgdd.vn/Products/Images/58/236016/cap-type-c-1m-anker-a8023-trang-thumb-600x600.jpeg";
    if (name.toLowerCase().contains("macbook"))
      return "https://cdn.tgdd.vn/Products/Images/44/282827/macbook-air-m2-2022-gray-600x600.jpg";
    if (name.toLowerCase().contains("tai nghe"))
      return "https://cdn.tgdd.vn/Products/Images/54/289710/airpods-pro-2-thumb-600x600.jpg";
    return "https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/9769966c-54a4-4bf8-b543-96b66e30b057/m-j-ess-flc-short-x-ma-bQWvj1.png";
  }
}
