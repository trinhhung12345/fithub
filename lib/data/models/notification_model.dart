class NotificationModel {
  final int id;
  final String content;
  final bool isUnread; // Để hiển thị cái chấm đỏ nếu cần
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.content,
    this.isUnread = false,
    required this.createdAt,
  });
}
