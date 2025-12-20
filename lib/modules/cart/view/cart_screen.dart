import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart';
import '../view_model/cart_view_model.dart';
import '../../checkout/view/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartViewModel>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Center(child: FitHubBackButton()), // Nút back custom
        title: Text("Giỏ hàng", style: AppTextStyles.h2.copyWith(fontSize: 20)),
        centerTitle: true,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                // Danh sách cuộn
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: viewModel.cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final item = viewModel.cartItems[index];
                      return _buildCartItem(context, viewModel, item);
                    },
                  ),
                ),

                // Bottom Bar (Tổng tiền & Checkout)
                _buildBottomBar(viewModel),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          Text("Giỏ hàng trống trơn", style: AppTextStyles.h2),
          const SizedBox(height: 10),
          const Text(
            "Hãy thêm vài món đồ xịn xò vào nhé!",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartViewModel viewModel,
    var item,
  ) {
    return Dismissible(
      key: Key(item.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      onDismissed: (direction) {
        viewModel.removeItem(item.id);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Ảnh sản phẩm
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(item.product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Thông tin
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.product.formattedPrice,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Bộ tăng giảm số lượng mini
                  Row(
                    children: [
                      _buildQtyIcon(
                        Icons.remove,
                        () => viewModel.decreaseQuantity(item.id),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "${item.quantity}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _buildQtyIcon(
                        Icons.add,
                        () => viewModel.increaseQuantity(item.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Nút xóa
            IconButton(
              onPressed: () => viewModel.removeItem(item.id),
              icon: const Icon(Icons.close, color: Colors.grey, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Icon(icon, size: 14, color: Colors.black),
      ),
    );
  }

  Widget _buildBottomBar(CartViewModel viewModel) {
    return Container(
      // Bỏ padding ở đây, chuyển vào bên trong SafeArea
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      // --- SỬA TỪ ĐÂY ---
      child: SafeArea(
        // 1. Bọc SafeArea để tránh bị che bởi thanh điều hướng
        top: false, // Chỉ cần tránh đáy, không cần tránh đỉnh
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ), // 2. Đưa padding vào đây
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Quan trọng: Chỉ chiếm chiều cao vừa đủ
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tổng cộng:",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  Text(
                    viewModel.formattedTotalAmount,
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.black,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (viewModel.cartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Giỏ hàng đang trống!")),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Tiến hành thanh toán",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // --- HẾT SỬA ---
    );
  }
}
