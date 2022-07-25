import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationdetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.high,
            icon: 'drawable/signupimage',
            color: Colors.blue[900]));
  }

  static Future init() async {
    final android = AndroidInitializationSettings('drawable/signupimage');
    final settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  static Future shownotification(
      {int id = 1234, String? title, String? body, String? payload}) async {
    _notifications.show(id, title, body, await _notificationdetails(),
        payload: payload);
    //
  }
}
