import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class locaNotificationChannel {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static initializer()
  {
    final InitializationSettings initializationSettings =InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  static Future<void> display(RemoteMessage message)
  async {
    try {
      final id = DateTime
          .now()
          .millisecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            'NukarShopChannel',
            'NukarShopChannel channal',
            'this is our channal',
            importance: Importance.max,
            priority: Priority.high,
          )
      );
      await _flutterLocalNotificationsPlugin.show(
          id, message.notification!.title, message.notification!.body,
          notificationDetails);
    }catch(e)
    {
      print(e);
    }
  }
}
