import 'package:code_template/Controller/home/logout_controller.dart';
import 'package:code_template/Controller/home/setting_screen_controller.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/view/screens/home/change_password_screen.dart';
import 'package:code_template/view/utils/dialog.dart';
import 'package:code_template/view/widgets/body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/colors.dart';
import '../../utils/strings.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MySafeArea(
      child: Scaffold(
        backgroundColor: Clr.whiteColor,
        appBar: AppBar(
          toolbarHeight: 20.w,
          backgroundColor: Clr.whiteColor,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Clr.blackColor,
              )),
          title: Text(
            "Settings",
            style: TextStyle(
                letterSpacing: 0.1.w,
                color: Clr.blackColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: SafeArea(
          child: GetBuilder<SettingScreenController>(
            init: SettingScreenController(),
            builder: (controller) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonCard(
                    onTap: () {
                      Share.share("check out my website https://example.com'");
                    },
                    icon: Icons.share,
                    text: "Share Application"),
                commonCard(
                    onTap: () {
                      Get.to(() => ChangePassScreen());
                    },
                    icon: Icons.lock,
                    text: Strings.changePassword),
                commonCard(
                    onTap: () {
                      commonDialog(
                          context: context,
                          subTitle: Strings.logoutPopUp,
                          onPressed: () {
                            LogOutController().userLogout();
                          },
                          buttonText: Strings.logout,
                          buttonColor: Clr.redColor);
                    },
                    icon: Icons.logout,
                    text: Strings.logout),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget commonCard(
      {required IconData icon, required String text, void Function()? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 2.5.w),
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 2.5.w),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Clr.whiteColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1.5),
                blurRadius: 5,
                color: Colors.black38,
              )
            ],
          ),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(
                width: 3.w,
              ),
              Text(
                text,
                style: TextStyle(
                    color: Clr.blackColor,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*
  Future logOutPopup(BuildContext context, LogOutController logOutController) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Clr.whiteColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.w)),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.aySure,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Clr.textClr4,
                      fontSize: 15.sp,
                      height: 0.3.w,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  Strings.logoutPopUp,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Clr.textClr4,
                      fontSize: 15.sp,
                      height: 0.3.w,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(bottom: 3.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DialogButton(
                        height: 9.w,
                        width: 25.w,
                        buttonColor: Clr.blueColor2,
                        onPressed: () {
                          Get.back();
                        },
                        text: Strings.cancel,
                        fontSize: 13.sp),
                    SizedBox(width: 4.w),
                    DialogButton(
                        height: 9.w,
                        width: 25.w,
                        buttonColor: Clr.noRedClr,
                        onPressed: () async {
                          logOutController.userLogout();
                        },
                        text: Strings.logout,
                        fontSize: 13.sp),
                  ],
                ),
              )
            ],
          );
        });
  }
*/
}
