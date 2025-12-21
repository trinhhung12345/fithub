import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_button.dart';
import '../view_model/order_view_model.dart';
import 'components/order_card.dart';
import 'components/order_filter_bar.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Đơn hàng", style: AppTextStyles.h2),
        centerTitle: true,
        automaticallyImplyLeading:
            false, // Ẩn nút back nếu nằm trong MainScreen
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 1. Filter Bar (Luôn hiện nếu có dữ liệu hoặc muốn giữ style)
                // Tuy nhiên theo ảnh 1, nếu trống thì không hiện Filter.
                // Ở đây mình check: nếu list gốc rỗng -> hiện Empty.
                // Nếu list gốc có data nhưng lọc ra rỗng -> hiện Filter + thông báo trống.
                if (viewModel.orders.isNotEmpty ||
                    viewModel.selectedStatusIndex != 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: OrderFilterBar(
                      statuses: viewModel.statusList,
                      selectedIndex: viewModel.selectedStatusIndex,
                      onSelected: (index) => viewModel.setFilter(index),
                    ),
                  ),

                // 2. Nội dung chính
                Expanded(
                  child: viewModel.orders.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: viewModel.orders.length,
                          itemBuilder: (context, index) {
                            final order = viewModel.orders[index];
                            return OrderCard(
                              orderCode: order.id.toString(),
                              itemCount:
                                  "${order.totalItemCount} sản phẩm", // Dùng helper trong model
                              price: order
                                  .formattedTotal, // Dùng helper trong model
                              status: order.status,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // Truyền thẳng object order sang, không cần gọi API lại
                                    builder: (context) =>
                                        OrderDetailScreen(order: order),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  // Widget trạng thái trống (Ảnh 1)
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon giỏ hàng có dấu tích
            Stack(
              alignment: Alignment.topRight,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.black,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.purpleAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 20, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text("Chưa có đơn hàng nào", style: AppTextStyles.h2),

            const SizedBox(height: 30),

            // Nút Khám phá sản phẩm
            SizedBox(
              width: 200,
              child: FitHubButton(
                text: "Khám phá sản phẩm",
                onPressed: () {
                  // Chuyển về Tab Home (Tab 0)
                  // Cách đơn giản nhất nếu dùng MainScreen là thông báo cho cha
                  // Hoặc dùng:
                  // DefaultTabController.of(context)?.animateTo(0);
                  print("Về trang chủ");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
