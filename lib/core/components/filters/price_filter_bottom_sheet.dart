import 'package:flutter/material.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../fit_hub_button.dart'; // Component nút bấm cũ

class PriceFilterBottomSheet extends StatefulWidget {
  final Function(double? min, double? max) onApply;

  const PriceFilterBottomSheet({super.key, required this.onApply});

  @override
  State<PriceFilterBottomSheet> createState() => _PriceFilterBottomSheetState();
}

class _PriceFilterBottomSheetState extends State<PriceFilterBottomSheet> {
  final _minController = TextEditingController();
  final _maxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(
          context,
        ).viewInsets.bottom, // Đẩy lên khi hiện phím
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _minController.clear();
                    _maxController.clear();
                  },
                  child: const Text(
                    "Clear",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Text("Price", style: AppTextStyles.h2.copyWith(fontSize: 18)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2 ô nhập Min - Max
            Column(
              children: [
                _buildPriceInput("Min", _minController),
                const SizedBox(height: 16),
                _buildPriceInput("Max", _maxController),
              ],
            ),

            const SizedBox(height: 24),
            FitHubButton(
              text: "Apply",
              onPressed: () {
                final min = double.tryParse(_minController.text);
                final max = double.tryParse(_maxController.text);
                widget.onApply(min, max);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInput(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
