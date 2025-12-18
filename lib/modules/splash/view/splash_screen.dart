import 'package:flutter/material.dart';
import '../../../configs/app_assets.dart';
import '../../../configs/app_colors.dart';
import '../../auth/view/login_screen.dart'; // Import màn hình Login
import '../../../data/local/app_preferences.dart';
import '../../main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Hàm chuyển trang sau 3 giây
  Future<void> _checkLoginStatus() async {
    // Vẫn đợi 2-3 giây để user kịp nhìn thấy Logo
    await Future.delayed(const Duration(seconds: 2));

    // Lấy token từ bộ nhớ
    final token = await AppPreferences.getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // Đã có token -> Vào thẳng MainScreen (Trang chủ)
      print("Token found: $token");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // Chưa có token -> Vào LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
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
              width: 317, // Điều chỉnh kích thước logo tùy ý
              height: 114,
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
