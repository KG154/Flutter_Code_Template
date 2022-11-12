import 'dart:convert';

import 'package:code_template/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  Future<void> initialize() async {
    final AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings iOSInitializationSettings =
        IOSInitializationSettings(
      defaultPresentAlert: false,
      defaultPresentBadge: false,
      defaultPresentSound: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    //initialize notification
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? id) {
      print("onSelectNotification");
      if (id!.isNotEmpty) {
        print("Router:==$id");
      }
    });
  }

  //create notification
  static void createAndDisplayNotification(RemoteMessage message) async {
    try {
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          playSound: true,
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      //show notification
      await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } on Exception catch (e) {
      print("error==$e");
    }
  }
}
