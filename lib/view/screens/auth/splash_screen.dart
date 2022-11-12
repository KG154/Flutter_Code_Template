import 'package:code_template/Controller/auth/splash_controller.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/View/Utils/assets.dart';
import 'package:code_template/View/Utils/colors.dart';
import 'package:code_template/module/model/auth/user_login_model.dart';
import 'package:code_template/view/screens/home/userlist_screen.dart';
import 'package:code_template/view/utils/shared_preference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<SplashController>(
          init: SplashController(),
          initState: (splashLogic) async {
            ///check if user login so move userList page either login page
            UserLoginModel? userModel = await Storage.getUser();
            Future.delayed(Duration(seconds: 1), () {
              if (userModel != null ||
                  FirebaseAuth.instance.currentUser != null) {
                Get.off(() => UserListScreen());
              } else {
                Get.off(() => LoginScreen());
              }
            });
          },
          builder: (controller) => Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Clr.whiteColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(55),
                topLeft: Radius.circular(55),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  child: Image.asset(
                    Ast.splash_screen_bg,
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Image.asset(
                    Ast.splash_screen_logo,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.w),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "version 1.0.0",
                      style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Clr.versionClr),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
