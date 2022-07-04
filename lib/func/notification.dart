import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationAPI {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static Future init({bool scheduled = false}) async {
    var initAndroidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    final settings = InitializationSettings(android: initAndroidSettings,iOS: ios);
    await _notifications.initialize(settings);
  }
  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        channelDescription: 'channel description',
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);
}