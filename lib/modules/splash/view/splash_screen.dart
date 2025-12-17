import 'package:flutter/material.dart';
import '../../../configs/app_assets.dart';
import '../../../configs/app_colors.dart';
import '../../auth/view/login_screen.dart'; // Import màn hình Login

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  // Hàm chuyển trang sau 3 giây
  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return; // Kiểm tra xem màn hình còn tồn tại không

    // Dùng pushReplacement để user không back lại được Splash
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Nền màu cam chủ đạo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo chính
            Image.asset(
              AppAssets.logo,
              width: 150, // Điều chỉnh kích thước logo tùy ý
              height: 150,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // Loading xoay tròn (tùy chọn, để màu trắng cho nổi)
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
