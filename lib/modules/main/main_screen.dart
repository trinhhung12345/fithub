import 'package:flutter/material.dart';
import '../../core/components/fit_hub_bottom_nav.dart'; // Import Component Footer
import '../home/view/home_screen.dart';
import '../order/view/order_history_screen.dart';
import '../notification/view/notification_screen.dart';
import '../profile/view/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const NotificationScreen(),
    const OrderHistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      // Sử dụng Component Footer đã tách
      bottomNavigationBar: FitHubBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
