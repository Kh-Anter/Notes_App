import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:note/models/timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class MyNotification {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static Future init() async {
    const antroid = AndroidInitializationSettings('mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const setting = InitializationSettings(android: antroid, iOS: ios);
    await _notification.initialize(setting,
        onDidReceiveNotificationResponse: (payload) async {
      print(
          "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh---- done $payload");
      onNotification.add(payload as String?);
    });
  }

  static Future _notificationDetails() async {
    await _notification.initialize(
      const InitializationSettings(
          android: AndroidInitializationSettings('mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings()),
    );
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: "channel_description",
          playSound: true,
          //sound: RawResourceAndroidNotificationSound('notification'),
          importance: Importance.max,
          // priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails());
  }

  // static Future showNotification({
  //   var id = 0,
  //   required String title,
  //   required String body,
  //   var payload,
  // }) async {
  //   await _notification.show(0, title, body, await _notificationDetails(),
  //       payload: payload);
  // }

  static Future showScheduleNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required DateTime schedualDate}) async {
    final timeZone = TimeZone();

    // The device's timezone.
    String timeZoneName = await timeZone.getTimeZoneName();

    // Find the 'current location'
    final location = await timeZone.getLocation(timeZoneName);

    final tzScheduledDate = tz.TZDateTime.from(schedualDate, location);

    await _notification.zonedSchedule(
        0, title, body, tzScheduledDate, await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
