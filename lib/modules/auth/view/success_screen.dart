import 'package:flutter/material.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../home/view/home_screen.dart'; // Import trang Home

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Tự động chuyển trang sau 3 giây
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Chuyển đến Home và xóa hết lịch sử các trang trước đó (Login, OTP...)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Checkmark lớn
              // Bạn có thể thay bằng Image.asset nếu có icon ảnh riêng
              // Ở đây mình dùng Icon có sẵn của Flutter và chỉnh size lớn
              Icon(
                Icons.check,
                color: AppColors.primary,
                size: 100,
                weight: 20.0, // Tăng độ dày cho icon (yêu cầu Flutter mới)
              ),

              // Nếu Icon trên chưa đủ dày giống design, bạn có thể dùng ảnh:
              // Image.asset(AppAssets.iconSuccess, width: 100),
              const SizedBox(height: 40),

              Text(
                "Thành công! Bạn sẽ được chuyển đến trang chủ sau vài giây",
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18, // Chỉnh lại size chữ cho vừa mắt
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
