import 'dart:io';

import 'package:code_template/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'local_notification.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  bool _initialized = false;
  BuildContext? context;

  static bool notificationReceived = false;

  Future<void> init() async {
    // if (!_initialized) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentSound: true,
      // onDidReceiveLocalNotification: (id, title, body, payload) {
      //   return onDidRecieveLocalNotification();
      // },
    );

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? id) {
      print("onSelectNotification");
      if (id!.isNotEmpty) {
        print("Router:==$id");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('OnMessage ' + message.data.toString());
      print(message.notification!.title);
      print(message.notification!.body);
      if (Platform.isAndroid) {
        LocalNotificationService.createAndDisplayNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp' + message.notification.toString());
      print(message.notification?.title.toString());
      print(message.notification?.body.toString());
      print("FCM Click Notification >> ${message.notification}");
    });
    // }
  }
}
