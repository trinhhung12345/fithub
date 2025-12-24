import 'package:flutter/material.dart';
import '../../../../configs/app_colors.dart';
import '../../../../configs/app_text_styles.dart';

class WriteReviewDialog extends StatefulWidget {
  final Function(int rating, String content) onSubmit;
  final int initialRating; // <--- Thêm
  final String initialContent;

  const WriteReviewDialog({
    super.key,
    required this.onSubmit,
    this.initialRating = 5, // Mặc định 5 sao
    this.initialContent = "", // Mặc định rỗng
  });

  @override
  State<WriteReviewDialog> createState() => _WriteReviewDialogState();
}

class _WriteReviewDialogState extends State<WriteReviewDialog> {
  late int _rating;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    // Gán giá trị ban đầu (nếu là Sửa thì lấy data cũ, nếu là Mới thì lấy mặc định)
    _rating = widget.initialRating;
    _contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Viết đánh giá",
              style: AppTextStyles.h2.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 20),

            // 1. Chọn Sao
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 32,
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Text(
              _rating == 5
                  ? "Tuyệt vời!"
                  : _rating > 3
                  ? "Hài lòng"
                  : "Chưa tốt lắm",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // 2. Ô nhập nội dung
            TextField(
              controller: _contentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Chia sẻ cảm nhận của bạn về sản phẩm...",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3. Nút Gửi
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  if (_contentController.text.trim().isEmpty) {
                    return; // Không cho gửi rỗng
                  }
                  // Trả dữ liệu về
                  widget.onSubmit(_rating, _contentController.text);
                  Navigator.pop(context); // Đóng dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Gửi đánh giá",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
