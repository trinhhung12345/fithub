import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_text_styles.dart';
import 'fit_hub_button.dart';

class FitHubDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback? onPressed;
  final bool isSuccess; // True: Icon tích xanh/cam, False: Icon báo lỗi

  const FitHubDialog({
    super.key,
    required this.title,
    required this.content,
    this.buttonText = "Đóng",
    this.onPressed,
    this.isSuccess = true,
  });

  // Hàm static để gọi nhanh từ bất cứ đâu
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String content,
    String buttonText = "OK",
    VoidCallback? onPressed,
    bool isSuccess = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible:
          false, // Bắt buộc bấm nút mới tắt được (hoặc true tùy bạn)
      barrierColor: Colors.black.withOpacity(0.5), // Làm tối background 50%
      builder: (context) => FitHubDialog(
        title: title,
        content: content,
        buttonText: buttonText,
        onPressed: onPressed,
        isSuccess: isSuccess,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Bo tròn góc dialog
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Chỉ chiếm chiều cao vừa đủ nội dung
          children: [
            // 1. Icon (Dấu tích hoặc Cảnh báo)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSuccess
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.check : Icons.error_outline,
                color: isSuccess ? AppColors.primary : Colors.red,
                size: 32,
              ),
            ),

            const SizedBox(height: 20),

            // 2. Title
            Text(
              title,
              style: AppTextStyles.h2.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // 3. Content
            Text(
              content,
              style: AppTextStyles.body.copyWith(
                color: AppColors.hintText,
                height: 1.5, // Giãn dòng cho dễ đọc
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // 4. Button
            FitHubButton(
              text: buttonText,
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog trước
                if (onPressed != null) {
                  onPressed!(); // Thực hiện hành động tiếp theo (nếu có)
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
