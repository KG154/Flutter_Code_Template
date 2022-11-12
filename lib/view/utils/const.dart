import 'package:flutter/material.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';

import 'colors.dart';

//here const dart file
/*
  put common textStyle, BoxDecoration, customBoxShadow,
  Container etc..
*/

GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

RegExp emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

String baseUrl = "http://192.168.29.72/codestructuredemo/api/v_1_0";

class Utils {
  static String? token;
  static String? userID;
  static bool? isProfileSet;
  static String? deviceToken;
  static String? deviceType;
  static const String appVersion = "v.1.0";
// static Map<String, String> headerDate = {"Token": uniqueToken!};
}

///
TextStyle appTitleStyle = TextStyle(
    letterSpacing: 0.1.w, color: Clr.blackColor, fontSize: 15.sp, fontWeight: FontWeight.w500);
