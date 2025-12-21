import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/product_model.dart';
import '../view_model/update_product_view_model.dart';

class UpdateProductScreen extends StatelessWidget {
  final Product product; // Sản phẩm cần sửa

  const UpdateProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          UpdateProductViewModel()..initData(product), // Init dữ liệu
      child: _UpdateProductForm(product: product),
    );
  }
}

class _UpdateProductForm extends StatefulWidget {
  final Product product;
  const _UpdateProductForm({required this.product});

  @override
  State<_UpdateProductForm> createState() => _UpdateProductFormState();
}

class _UpdateProductFormState extends State<_UpdateProductForm> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    // Điền sẵn dữ liệu cũ
    final p = widget.product;
    _nameController = TextEditingController(text: p.name);
    _descController = TextEditingController(text: p.description);
    // Lưu ý: price trong model là double, chuyển về int nếu cần bỏ .0
    _priceController = TextEditingController(text: p.price.toStringAsFixed(0));
    _stockController = TextEditingController(text: p.stock.toString());
    _categoryController = TextEditingController(
      text: p.category?.id.toString() ?? p.categoryId?.toString() ?? "1",
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UpdateProductViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text("Sửa: ${widget.product.name}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              decoration: const InputDecoration(labelText: "Category ID"),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            // --- KHU VỰC ẢNH ---
            Row(
              children: [
                const Text(
                  "Hình ảnh:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => viewModel.pickNewImages(),
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text("Thêm ảnh"),
                ),
              ],
            ),

            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: viewModel.currentImages.length,
                itemBuilder: (context, index) {
                  final item = viewModel.currentImages[index];
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        // Logic hiển thị ảnh (File hoặc Network)
                        child: item is File
                            ? Image.file(item, fit: BoxFit.cover)
                            : Image.network(item as String, fit: BoxFit.cover),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () => viewModel.removeImage(index),
                          child: Container(
                            color: Colors.red,
                            padding: const EdgeInsets.all(2),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
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

            // NÚT CẬP NHẬT
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        final success = await viewModel.updateProduct(
                          id: widget.product.id,
                          name: _nameController.text,
                          desc: _descController.text,
                          price: _priceController.text,
                          stock: _stockController.text,
                          categoryId: _categoryController.text,
                        );

                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cập nhật thành công!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context); // Đóng màn hình
                        }
                      },
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "LƯU THAY ĐỔI",
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
