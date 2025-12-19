import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';

class FitHubBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FitHubBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Thêm viền trên mờ mờ cho đẹp (tùy chọn)
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType
            .fixed, // Giữ vị trí cố định (không hiệu ứng zoom)
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false, // Ẩn chữ theo design
        showUnselectedLabels: false,
        elevation: 0, // Tắt bóng đổ mặc định để tự xử lý style
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 28),
            activeIcon: Icon(Icons.home, size: 28),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined, size: 28),
            activeIcon: Icon(Icons.notifications, size: 28),
            label: "Noti",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined, size: 28),
            activeIcon: Icon(Icons.description, size: 28),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 28),
            activeIcon: Icon(Icons.person, size: 28),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
