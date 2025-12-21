import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/add_product_view_model.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddProductViewModel(),
      child: const _AddProductContent(),
    );
  }
}

class _AddProductContent extends StatefulWidget {
  const _AddProductContent();

  @override
  State<_AddProductContent> createState() => _AddProductContentState();
}

class _AddProductContentState extends State<_AddProductContent> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController(text: "2"); // Mặc định ID 2

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddProductViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Thêm sản phẩm (Test)")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FORM INPUT ---
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Tên sản phẩm"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Mô tả"),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: "Giá"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _stockController,
                    decoration: const InputDecoration(labelText: "Kho"),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: "Category ID (VD: 1, 2)",
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            // --- CHỌN ẢNH ---
            Row(
              children: [
                const Text(
                  "Hình ảnh:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => viewModel.pickImages(),
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text("Chọn ảnh"),
                ),
              ],
            ),

            // Grid hiển thị ảnh đã chọn
            if (viewModel.selectedImages.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 100,
                          height: 100,
                          child: Image.file(
                            viewModel.selectedImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => viewModel.removeImage(index),
                            child: Container(
                              color: Colors.red,
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            const SizedBox(height: 30),

            // --- NÚT SUBMIT ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        final success = await viewModel.submitProduct(
                          name: _nameController.text,
                          desc: _descController.text,
                          price: _priceController.text,
                          stock: _stockController.text,
                          categoryId: _categoryController.text,
                        );

                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Thêm thành công!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context); // Đóng màn hình
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Thất bại! Xem log."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("ĐĂNG SẢN PHẨM"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
