import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../data/models/chat_model.dart';
import '../../product/view/product_detail_screen.dart';
import '../view_model/chat_view_model.dart';
import 'components/chat_product_card.dart';

class ChatBotSheet extends StatelessWidget {
  const ChatBotSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng ChangeNotifierProvider để tạo ViewModel riêng cho mỗi lần mở popup
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(),
      child: const _ChatBotContent(),
    );
  }
}

class _ChatBotContent extends StatefulWidget {
  const _ChatBotContent();

  @override
  State<_ChatBotContent> createState() => _ChatBotContentState();
}

class _ChatBotContentState extends State<_ChatBotContent> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    // Tự động cuộn xuống khi có tin nhắn mới
    if (viewModel.isTyping || viewModel.messages.isNotEmpty) {
      _scrollToBottom();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // HEADER
          _buildHeader(context),

          // LIST MESSAGE
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount:
                  viewModel.messages.length + (viewModel.isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == viewModel.messages.length) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        "Bot đang nhập...",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                }

                final msg = viewModel.messages[index];
                return _buildMessageItem(context, msg, viewModel);
              },
            ),
          ),

          // INPUT
          _buildInputArea(viewModel, bottomPadding),
        ],
      ),
    );
  }

  // --- WIDGETS CON ---

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.smart_toy, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Text(
                "FitHub AI",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
    BuildContext context,
    ChatMessageItem msg,
    ChatViewModel viewModel,
  ) {
    final isUser = msg.role == 'user';
    return Column(
      crossAxisAlignment: isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        // 1. Text Message
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isUser ? AppColors.primary : Colors.grey[100],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: Radius.circular(isUser ? 12 : 0),
              bottomRight: Radius.circular(isUser ? 0 : 12),
            ),
          ),
          child: Text(
            msg.text,
            style: TextStyle(color: isUser ? Colors.white : Colors.black87),
          ),
        ),

        // 2. Product List (HIỂN THỊ SẢN PHẨM)
        if (!isUser && msg.products.isNotEmpty)
          Container(
            height: 190, // Tăng chiều cao lên chút để thẻ thoải mái
            margin: const EdgeInsets.only(bottom: 10, top: 5),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: msg.products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return ChatProductCard(aiProduct: msg.products[index]);
              },
            ),
          ),

        // 3. Suggestions
        if (!isUser && msg.suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: msg.suggestions.map((sug) {
                return ActionChip(
                  label: Text(sug, style: const TextStyle(fontSize: 12)),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    viewModel.sendMessage(sug, isSuggestion: true);
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // Widget Thẻ sản phẩm trong Chat
  Widget _buildProductCard(BuildContext context, AiProduct product) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return GestureDetector(
      onTap: () {
        // Chuyển sang chi tiết
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        width: 140, // Chiều rộng cố định
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh (Giả lập vì API AI không trả về ảnh)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  image: const DecorationImage(
                    // Dùng ảnh mặc định của Nike/Dụng cụ
                    image: NetworkImage(
                      "https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/9769966c-54a4-4bf8-b543-96b66e30b057/m-j-ess-flc-short-x-ma-bQWvj1.png",
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Thông tin
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(product.price),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(ChatViewModel viewModel, double bottomPadding) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 10 + bottomPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Nhập tin nhắn...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onSubmitted: (val) {
                viewModel.sendMessage(
                  val,
                  isSuggestion: false,
                ); // Gõ tay là false
                _controller.clear();
              },
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              viewModel.sendMessage(_controller.text);
              _controller.clear();
            },
            child: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
