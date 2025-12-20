import 'package:flutter/material.dart';
import '../../../configs/app_config.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/notification_model.dart';

class NotificationViewModel extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    if (AppConfig.mockNotification) {
      await Future.delayed(const Duration(milliseconds: 500));
      // Để test trang TRỐNG: Bạn comment dòng dưới lại
      _notifications = List.from(MockData.notifications);
      // _notifications = []; // Mở comment dòng này để test trang trống
    } else {
      // API thật sau này
    }

    _isLoading = false;
    notifyListeners();
  }
}
