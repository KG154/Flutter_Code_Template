import 'package:code_template/Controller/auth/google_facebook_controller.dart';
import 'package:code_template/Controller/auth/login_controller.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../utils/colors.dart';
import '../../utils/const.dart';
import '../../utils/global_variables.dart';
import '../../utils/strings.dart';
import '../../widgets/body.dart';
import '../../widgets/button.dart';
import '../../widgets/textfields.dart';
import 'reset_password_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateAnyDirection],
      child: MySafeArea(
        child: Scaffold(
          body: SafeArea(
            child: GetBuilder<LoginController>(
              init: LoginController(),
              initState: (loginLogic) {},
              builder: (loginLogic) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.5.w,
                  vertical: 0.5.h,
                ),
                child: Form(
                  ///for textFormFiled autoValidation check
                  autovalidateMode: loginLogic.submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  key: loginLogic.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 35.w,
                      ),
                      Text(
                        Strings.loginText,
                        style: TextStyle(
                            color: Clr.blackColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5.w,
                      ),
                      MyTextField(
                        controller: loginLogic.emailC,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        hintText: Strings.emailHint,
                        textFieldType: Validate.emailTxt,
                        validate: Validate.emailVal,
                        prefixIcon: Icon(Icons.mail, size: 7.w),
                        fill: false,
                        fillColor: Clr.transparent,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 4.w),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return Validate.emailEmpty;
                          } else if (!emailValid.hasMatch(v)) {
                            return Validate.emailValid;
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        controller: loginLogic.passC,
                        obscureText: loginLogic.passHide.value,
                        keyboardType: TextInputType.text,
                        hintText: Strings.passHint,
                        textFieldType: Validate.passTxt,
                        validate: Validate.passVal,
                        fill: false,
                        fillColor: Clr.transparent,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 4.w),
                        prefixIcon: Icon(Icons.lock_rounded, size: 7.w),
                        suffixIcon: IconButton(
                          onPressed: () {
                            loginLogic.changeObscureP();
                          },
                          icon: Icon(loginLogic.passHide.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return Validate.passEmpty;
                          } else if (value.toString().length < 6) {
                            return Validate.passValid;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.w),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ResetPassScreen());
                          },
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              Strings.forgotPwd,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: Clr.blackColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.w,
                      ),

                      ///Opacity use for hide button
                      Opacity(
                        opacity: buttonDisable ? 1.0 : 0.2,
                        child: MyButton(
                          width: 50.w,
                          title: Strings.login,
                          onClick: () async {
                            ///check condition for button disable or enable
                            if (buttonDisable) {
                              loginLogic.submitted = true;
                              loginLogic.update();
                              if (loginLogic.formKey.currentState!.validate()) {
                                buttonDisable = false;
                                await loginLogic.userLogin();
                              }
                              Future.delayed(Duration(milliseconds: 500), () {
                                buttonDisable = true;
                                loginLogic.update();
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                      Column(
                        children: [
                          ElevatedButton.icon(
                              onPressed: () async {
                                await FGAuthControler().googleAuth();
                              },
                              icon: Icon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              label: Text("Login With Google")),
                          ElevatedButton.icon(
                              onPressed: () async {
                                await FGAuthControler().facebookAuth();
                              },
                              icon: Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.white,
                              ),
                              label: Text("Login With Facebook")),
                        ],
                      ),

                      SizedBox(
                        height: 2.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Strings.donTHaveAccount,
                              style: TextStyle(
                                color: Clr.blackColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                              ),
                            ),
                            TextButton(
                              autofocus: false,
                              onPressed: () {
                                Get.to(() => SignUpScreen());
                              },
                              child: Text(
                                Strings.signUp,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Clr.buttonClr,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

 /* Future<UserCredential> signInWithGoogle() async {
    // Initiate the auth procedure
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();
    // fetch the auth details from the request made earlier
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential for signing in with google
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }*/

  /*signInWithFacebook() async {
    final fb = FacebookLogin();
    // Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
      FacebookPermission.userFriends
    ]);
    // Check result status

    if (res.status == FacebookLoginStatus.success) {
      final FacebookAccessToken? accessToken = res.accessToken;
      final AuthCredential authCredential =
          FacebookAuthProvider.credential(accessToken!.token);
      final result =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      // Get profile data from facebook for use in the app
      final profile = await fb.getUserProfile();
      print('Hello, ${profile?.name}! You ID: ${profile?.userId}');
      // Get user profile image url
      final imageUrl = await fb.getProfileImageUrl(width: 100);
      print('Your profile image: $imageUrl');
      // fetch user email
      final email = await fb.getUserEmail();
      // But user can decline permission
      if (email != null) print('And your email is $email');
      return await FirebaseAuth.instance.signInWithCredential(authCredential);
    } else if (res.status == FacebookLoginStatus.cancel) {
      print('Cancel while log');
    } else {
      print('Error while log in: ${res.error}');
    }
  }*/
}
