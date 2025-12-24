import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_button.dart';
import '../../order/view/order_detail_screen.dart'; // Import màn hình chi tiết đơn
import '../view_model/notification_view_model.dart';
import 'components/notification_item.dart'; // Import component mới

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationViewModel>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Nền xám nhạt để card nổi lên
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Thông báo", style: AppTextStyles.h2),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.notifications.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () => viewModel.loadNotifications(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: viewModel.notifications.length,
                itemBuilder: (context, index) {
                  final order = viewModel.notifications[index];
                  return NotificationItem(
                    order: order,
                    onTap: () {
                      // Bấm vào thông báo -> Sang chi tiết đơn hàng
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailScreen(order: order),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    // Giữ nguyên code Empty State cũ của bạn
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.notifications_off,
                  size: 50,
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text("Chưa có thông báo nào", style: AppTextStyles.h2),
            const SizedBox(height: 10),
            const Text(
              "Khi bạn mua hàng, thông báo sẽ hiện ở đây.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
