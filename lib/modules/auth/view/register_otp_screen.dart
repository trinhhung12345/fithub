import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart';
import '../../../core/components/fit_hub_button.dart';
import '../../../core/components/fit_hub_otp_input.dart';
import '../view_model/register_view_model.dart';

class RegisterOtpScreen extends StatefulWidget {
  const RegisterOtpScreen({super.key});

  @override
  State<RegisterOtpScreen> createState() => _RegisterOtpScreenState();
}

class _RegisterOtpScreenState extends State<RegisterOtpScreen> {
  // Vì FitHubOtpInput hiện tại chưa expose controller ra ngoài,
  // để đơn giản mình sẽ sửa FitHubOtpInput một chút ở Bước phụ bên dưới
  // HOẶC dùng cách get value thủ công.
  // TUY NHIÊN: Để nhanh nhất, mình giả định bạn nhập OTP vào biến này:
  String _otpCode = "";

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegisterViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const FitHubBackButton(),
              const SizedBox(height: 30),
              Text("Xác thực OTP", style: AppTextStyles.h1),
              const SizedBox(height: 10),
              const Text("Nhập mã OTP được gửi về Email của bạn"),
              const SizedBox(height: 40),

              // Bạn cần sửa FitHubOtpInput để lấy được giá trị OTP ra
              // Tạm thời mình dùng TextField thường để test logic trước nhé
              // Sau đó bạn custom lại FitHubOtpInput để có callback onCompleted
              TextField(
                onChanged: (val) => _otpCode = val,
                decoration: const InputDecoration(
                  hintText: "Nhập mã OTP 6 số (Ví dụ: 123456)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 30),

              FitHubButton(
                text: "Hoàn tất đăng ký",
                isLoading: viewModel.isLoading,
                onPressed: () {
                  if (_otpCode.length < 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Vui lòng nhập OTP")),
                    );
                    return;
                  }
                  viewModel.verifyAndRegister(context, _otpCode);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
