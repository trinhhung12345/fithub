import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để format tiền
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart';
import '../../cart/view_model/cart_view_model.dart';
import '../view_model/checkout_view_model.dart';
import 'order_success_screen.dart'; // Trang thông báo thành công (làm ở bước 4)

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Controller cho form
  final _nameController = TextEditingController(
    text: "Trinh Huu Hung",
  ); // Mock sẵn cho nhanh
  final _phoneController = TextEditingController(text: "0867276214");
  final _addressController = TextEditingController(text: "Hà Nội, Việt Nam");
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu từ CartViewModel (để tính tiền)
    final cartViewModel = context.watch<CartViewModel>();
    final checkoutViewModel = context.watch<CheckoutViewModel>();

    // Tính toán tiền
    final subTotal = cartViewModel.totalAmount;
    final shipping = checkoutViewModel.shippingFee;
    final total = subTotal + shipping;

    // Hàm format tiền
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Nền xám nhẹ
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Center(child: FitHubBackButton()),
        title: Text(
          "Thanh toán",
          style: AppTextStyles.h2.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Thông tin vận chuyển
            _buildSectionTitle("Thông tin vận chuyển"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildTextField("Họ tên", _nameController, Icons.person),
                  const Divider(),
                  _buildTextField(
                    "Số điện thoại",
                    _phoneController,
                    Icons.phone,
                    inputType: TextInputType.phone,
                  ),
                  const Divider(),
                  _buildTextField(
                    "Địa chỉ nhận hàng",
                    _addressController,
                    Icons.location_on,
                  ),
                  const Divider(),
                  _buildTextField(
                    "Ghi chú (Tùy chọn)",
                    _noteController,
                    Icons.note,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Danh sách sản phẩm (Tóm tắt)
            _buildSectionTitle("Đơn hàng của bạn"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: cartViewModel.cartItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        // Ảnh nhỏ
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(item.product.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Tên + Số lượng
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "x${item.quantity}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        // Giá
                        Text(
                          currencyFormat.format(item.totalPrice),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // 3. Phương thức thanh toán (COD Only)
            _buildSectionTitle("Phương thức thanh toán"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.money, color: Colors.green),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Thanh toán khi nhận hàng (COD)",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(Icons.check_circle, color: AppColors.primary),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. Chi tiết thanh toán
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSummaryRow("Tạm tính", currencyFormat.format(subTotal)),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    "Phí vận chuyển",
                    currencyFormat.format(shipping),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tổng thanh toán",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        currencyFormat.format(total),
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
            ),
            // Khoảng trống cho nút bấm đỡ bị sát đáy
            const SizedBox(height: 30),
          ],
        ),
      ),
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
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: checkoutViewModel.isLoading
                    ? null
                    : () async {
                        // Gọi hàm đặt hàng
                        bool success = await checkoutViewModel.placeOrder(
                          cartViewModel,
                          name: _nameController.text,
                          phone: _phoneController.text,
                          address: _addressController.text,
                          note: _noteController.text,
                        );

                        if (success && context.mounted) {
                          // Chuyển sang trang thành công
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderSuccessScreen(),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: checkoutViewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "ĐẶT HÀNG NGAY",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets phụ ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    IconData icon, {
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
        icon: Icon(icon, size: 20, color: Colors.grey),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
