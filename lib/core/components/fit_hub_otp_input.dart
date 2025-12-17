import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để dùng LengthLimitingTextInputFormatter
import '../../configs/app_colors.dart';
import '../../configs/app_text_styles.dart';

class FitHubOtpInput extends StatefulWidget {
  const FitHubOtpInput({super.key});

  @override
  State<FitHubOtpInput> createState() => _FitHubOtpInputState();
}

class _FitHubOtpInputState extends State<FitHubOtpInput> {
  // Tạo danh sách 6 FocusNode và Controller
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    // Khởi tạo 6 node và 6 controller tương ứng với 6 ô
    _focusNodes = List.generate(6, (index) => FocusNode());
    _controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị hủy
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Hàm xử lý khi người dùng nhập liệu
  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Trường hợp nhập số:
      // Nếu không phải ô cuối cùng (index < 5) -> Nhảy sang ô kế tiếp
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Nếu là ô cuối cùng -> Ẩn bàn phím
        _focusNodes[index].unfocus();
      }
    } else {
      // Trường hợp xóa số (value rỗng):
      // Nếu không phải ô đầu tiên (index > 0) -> Lùi về ô trước đó
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return Container(
          width: 45,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.hintText.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(fontSize: 20),
            keyboardType: TextInputType.number,

            // Giới hạn chỉ nhập 1 ký tự và chỉ nhập số
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],

            // Logic nhảy ô
            onChanged: (value) => _onChanged(value, index),

            decoration: const InputDecoration(
              counterText: "", // Ẩn bộ đếm
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        );
      }),
    );
  }
}
