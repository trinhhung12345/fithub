import 'package:flutter/material.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart';
import '../../../core/components/fit_hub_button.dart';
import '../../../core/components/fit_hub_otp_input.dart';
import 'reset_password_screen.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        // THÊM WIDGET NÀY: SingleChildScrollView
        child: SingleChildScrollView(
          // Nên thêm thuộc tính này để khi cuộn không bị nảy ngược lên
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FitHubBackButton(),
                const SizedBox(height: 30),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Xác thực tài khoản", style: AppTextStyles.h1),
                ),

                const SizedBox(height: 10),

                Text(
                  "Chúng tôi đã gửi Mã OTP đến\nexample@gmail.com\nVui lòng nhập mã để xác thực",
                  style: AppTextStyles.body.copyWith(color: AppColors.hintText),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nhập Mã",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                // Ô nhập OTP
                const FitHubOtpInput(),

                const SizedBox(height: 40),

                FitHubButton(
                  text: "Xác Thực",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                RichText(
                  text: TextSpan(
                    text: "Không thấy Email của bạn? ",
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(
                        text: "(Gửi lại sau 02:09)",
                        style: AppTextStyles.link.copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
