import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../widgets/body.dart';

class DateFormatScreen extends StatefulWidget {
  const DateFormatScreen({Key? key}) : super(key: key);

  @override
  _DateFormatScreenState createState() => _DateFormatScreenState();
}

class _DateFormatScreenState extends State<DateFormatScreen> {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateAnyDirection],
      child: Scaffold(
        appBar: AppBar(
          title: Text("DateTime Format"),
        ),
        body: MySafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("UTC Time"),
                    Text(
                        "${DateFormat('dd MMM, yyyy. hh:mm:ss a').format(DateTime.now().toUtc())}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Local Time"),
                    Text(
                        "${DateFormat('yyyy MMM dd. hh:mm a').format(DateTime.now().toLocal())}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time Zone"),
                    Text(
                        "${DateTime.now().timeZoneOffset.toString().split(".").first} ${DateTime.now().timeZoneName.toString()}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${DateFormat('hh:mm a').format(DateTime.now().toLocal())}   isBefore   ${DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 5)).toLocal())}"),
                    Text(
                        "${DateTime.now().isBefore(DateTime.now().add(Duration(minutes: 5))).toString()}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${DateFormat('hh:mm a').format(DateTime.now().toLocal())}   isAfter   ${DateFormat('hh:mm a').format(DateTime.now().subtract(Duration(minutes: 5)).toLocal())}"),
                    Text(
                        "${DateTime.now().isAfter(DateTime.now().subtract(Duration(minutes: 5))).toString()}"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
