import 'package:flutter/material.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';

class SortBottomSheet extends StatelessWidget {
  final String currentSort;
  final Function(String) onApply;

  const SortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      "Recommended",
      "Newest",
      "Lowest - Highest Price",
      "Highest - Lowest Price",
    ];

    return Container(
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
              // Nút Clear giả (để cân đối layout)
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Clear",
                  style: TextStyle(color: Colors.transparent),
                ),
              ),
              Text("Sort by", style: AppTextStyles.h2.copyWith(fontSize: 18)),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...options.map((option) => _buildOption(context, option)).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String text) {
    final isSelected = currentSort == text;
    return GestureDetector(
      onTap: () {
        onApply(text);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(30),
        ),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.check, color: Colors.white, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
