import 'package:code_template/View/Widgets/bottomsheet.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../View/utils/strings.dart';
import 'package:code_template/view/widgets/button.dart';
import 'colors.dart';

buildImagePickerDialog(BuildContext context, Function cameraFun, Function galleryFun) async {
  return showCustomBottomSheet(context,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                cameraFun();
              },
              minLeadingWidth: 0,
              dense: true,
              leading: Icon(Icons.camera),
              title: Text("Camera"),
            ),
            ListTile(
              onTap: () {
                galleryFun();
              },
              minLeadingWidth: 0,
              dense: true,
              leading: Icon(Icons.camera),
              title: Text("Gallery"),
            ),
          ],
        ),
      ));
}

logoutDialog(BuildContext context, void Function()? onPressed) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Clr.dialogShadow,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.w))),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: EdgeInsets.only(top: 3.w, bottom: 3.w, right: 5.w, left: 5.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 3.w),
                  child: Text(
                    "Are you sure \nyou want to logout ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15.sp, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(width: 4.w),
                Row(
                  children: [
                    Expanded(
                      child: DialogButton(
                          height: 9.w,
                          width: 25.w,
                          bordered: true,
                          radius: 10,
                          fontWeight: FontWeight.w400,
                          buttonColor: Clr.whiteColor,
                          onPressed: () => Get.back(),
                          text: Strings.cancel,
                          textColor: Clr.blackColor,
                          fontSize: 13.sp),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: DialogButton(
                          height: 9.w,
                          width: 25.w,
                          radius: 10,
                          fontWeight: FontWeight.w400,
                          buttonColor: Clr.redColor,
                          onPressed: onPressed,
                          text: Strings.logout,
                          fontSize: 13.sp),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

commonDialog(
    {required BuildContext context,
    required String? subTitle,
    required void Function()? onPressed,
    required String? buttonText,
    Color? buttonColor}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Clr.dialogShadow,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.w))),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: EdgeInsets.only(top: 3.w, bottom: 3.w, right: 5.w, left: 5.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 1.w, top: 2.w),
                  child: Text(
                    "Are you sure ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.sp, color: Clr.blackColor, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 3.w),
                  child: Text(
                    subTitle.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13.5.sp, color: Clr.blackColor, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(width: 2.5.w),
                Row(
                  children: [
                    Expanded(
                      child: DialogButton(
                          height: 9.w,
                          width: 20.w,
                          bordered: true,
                          radius: 10,
                          fontWeight: FontWeight.w400,
                          buttonColor: Clr.whiteColor,
                          onPressed: () => Get.back(),
                          text: Strings.cancel,
                          textColor: Clr.blackColor,
                          fontSize: 13.sp),
                    ),
                    SizedBox(width: 2.5.w),
                    Expanded(
                      child: DialogButton(
                          height: 9.w,
                          width: 20.w,
                          radius: 10,
                          fontWeight: FontWeight.w400,
                          buttonColor: buttonColor,
                          onPressed: onPressed,
                          text: buttonText.toString(),
                          fontSize: 13.sp),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

permissionDialog(
    {required BuildContext context,
    required String? subTitle,
    required void Function()? onPressed,
    required String? buttonText,
    Color? buttonColor}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Clr.dialogShadow,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.w))),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: EdgeInsets.only(top: 3.w, bottom: 3.w, right: 5.w, left: 5.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 3.w),
                  child: Text(
                    subTitle.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13.sp, color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(width: 2.5.w),
                Row(
                  children: [
                    Expanded(
                      child: DialogButton(
                          height: 9.w,
                          width: 25.w,
                          bordered: true,
                          radius: 10,
                          fontWeight: FontWeight.w400,
                          buttonColor: Clr.whiteColor,
                          onPressed: () => Get.back(),
                          text: Strings.cancel,
                          textColor: Clr.blackColor,
                          fontSize: 13.sp),
                    ),
                    SizedBox(width: 2.5.w),
                    Expanded(
                      child: DialogButton(
                          height: 9.w,
                          width: 25.w,
                          radius: 10,
                          fontWeight: FontWeight.w400,
                          buttonColor: buttonColor,
                          onPressed: onPressed,
                          text: buttonText.toString(),
                          fontSize: 13.sp),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
