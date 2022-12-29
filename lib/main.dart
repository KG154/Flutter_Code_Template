import 'dart:developer';

import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/Module/routes/app_pages.dart';
import 'package:code_template/View/Screens/auth/splash_screen.dart';
import 'package:code_template/View/Utils/colors.dart';
import 'package:code_template/View/Utils/const.dart';
import 'package:code_template/services/local_notification.dart';
import 'package:code_template/services/permissions.dart';
import 'package:code_template/services/push_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


SharedPreferences? appPreferences;
SharedPreferences? Preferences;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log(" This is message from background ${message.data.toString()}");
  print(" ${message.notification?.title.toString()}");
  print(" ${message.notification?.body.toString()}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  appPreferences = await SharedPreferences.getInstance();
  Preferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  ///for get Current Location
  CurrLocation().getCurrentLocation();

  ///for firebase push notification
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  LocalNotificationService().initialize();
  await PushNotificationsManager().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OKToast(
      textStyle: TextStyle(fontSize: 20, color: Color(0xFF2E3E5C)),
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return GlobalLoaderOverlay(
            overlayColor: Clr.blackColor,
            child: GetMaterialApp(
              title: "Flutter Template",
              routes: {
                Routes.Splash: (context) => SplashScreen(),
              },
              navigatorKey: navigatorKey,
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
              defaultTransition: Transition.native,
            ),
          );
        },
      ),
      animationCurve: Curves.easeIn,
      animationDuration: Duration(milliseconds: 200),
      duration: Duration(seconds: 3),
    );
  }
}



// Network Connectivity
// Alert / Toast
// Notifications
// Api Class / Pagination
// Image Picker / CacheImage
// Image And Video Compressor
// Video Player
// Validator
// UI Component
// Theme Class
// on Loader show taping disable
// Location
// App Share
// Permission Handling => Location
// Google-FaceBook Login
