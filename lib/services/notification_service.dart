class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  Future<void> initialize() async {
    // TODO: Initialize push notification service
  }

  Future<void> requestPermission() async {
    // TODO: Request notification permissions
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    // TODO: Show local notification
  }
}
