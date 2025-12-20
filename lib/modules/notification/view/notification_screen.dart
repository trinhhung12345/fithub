import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_button.dart';
import '../view_model/notification_view_model.dart';
import 'components/notification_card.dart';

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
      backgroundColor: Colors.white,
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
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: viewModel.notifications.length,
              itemBuilder: (context, index) {
                final noti = viewModel.notifications[index];
                return NotificationCard(
                  content: noti.content,
                  isUnread: noti.isUnread,
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Chuông vàng to (Mô phỏng ảnh 1)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2), // Vòng tròn mờ
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.notifications_active,
                  size: 60,
                  color: Color(0xFFFFC107), // Màu vàng cam
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text("Chưa có thông báo nào", style: AppTextStyles.h2),

            const SizedBox(height: 40),

            // Nút Explore Categories
            SizedBox(
              width: 250,
              child: FitHubButton(
                text: "Explore Categories",
                onPressed: () {
                  // Chuyển về Home (Tab 0) - Tạm thời dùng print
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
