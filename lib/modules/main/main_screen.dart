import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import '../home/view/home_screen.dart'; // Import trang Home sắp làm

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Danh sách các màn hình
  final List<Widget> _pages = [
    const HomeScreen(),
    const Scaffold(body: Center(child: Text("Thông báo"))), // Placeholder
    const Scaffold(body: Center(child: Text("Đơn hàng"))), // Placeholder
    const Scaffold(body: Center(child: Text("Cá nhân"))), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed, // Giữ cố định vị trí icon
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false, // Ẩn label như trong design
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: "Noti",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
