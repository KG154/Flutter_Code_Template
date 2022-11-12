import 'package:code_template/Controller/auth/reset_password_controller.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/View/Utils/colors.dart';
import 'package:code_template/View/Utils/strings.dart';
import 'package:code_template/View/Widgets/body.dart';
import 'package:code_template/View/Widgets/button.dart';
import 'package:code_template/View/Widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../utils/const.dart';
import '../../utils/global_variables.dart';

class ResetPassScreen extends StatelessWidget {
  ResetPassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateAnyDirection],
      child: MySafeArea(
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
              Strings.resetPass,
              style: appTitleStyle,
            ),
          ),
          body: SafeArea(
            child: GetBuilder<ResetPassController>(
              init: ResetPassController(),
              builder: (resetPassLogic) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.5.w,
                  vertical: 0.5.h,
                ),
                child: Form(
                  autovalidateMode: resetPassLogic.submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  key: resetPassLogic.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5.w),
                      MyTextField(
                        controller: resetPassLogic.passC,
                        obscureText: resetPassLogic.passHide.value,
                        keyboardType: TextInputType.text,
                        hintText: Strings.newPassHint,
                        textFieldType: Validate.passTxt,
                        validate: Validate.passVal,
                        fill: false,
                        fillColor: Clr.transparent,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 4.w),
                        prefixIcon: Icon(Icons.lock_rounded, size: 7.w),
                        suffixIcon: IconButton(
                          onPressed: () {
                            resetPassLogic.changeObscureP();
                          },
                          icon: Icon(resetPassLogic.passHide.value
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
                      MyTextField(
                        controller: resetPassLogic.confirmPassC,
                        obscureText: resetPassLogic.conPassHide.value,
                        keyboardType: TextInputType.text,
                        hintText: Strings.confirmPassHint,
                        textFieldType: Validate.passTxt,
                        validate: Validate.confirmPassVal,
                        textInputAction: TextInputAction.done,
                        fill: false,
                        fillColor: Clr.transparent,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 4.w),
                        prefixIcon: Icon(Icons.lock_rounded, size: 7.w),
                        suffixIcon: IconButton(
                          onPressed: () {
                            resetPassLogic.changeObscureCP();
                          },
                          icon: Icon(resetPassLogic.conPassHide.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return Validate.confirmPasswordEmpty;
                          } else if (value != resetPassLogic.passC.text) {
                            return Validate.confirmPasswordNotMatch;
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        controller: resetPassLogic.emailC,
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
                      SizedBox(height: 30.w),
                      Opacity(
                        opacity: buttonDisable ? 1.0 : 0.2,
                        child: MyButton(
                          width: 65.w,
                          title: Strings.resetPass,
                          onClick: () async {
                            if (buttonDisable) {
                              resetPassLogic.submitted = true;
                              resetPassLogic.update();
                              if (resetPassLogic.formKey.currentState!
                                  .validate()) {
                                buttonDisable = false;
                                await resetPassLogic.resetPass();
                              }
                              Future.delayed(Duration(milliseconds: 500), () {
                                buttonDisable = true;
                                resetPassLogic.update();
                              });
                            }
                          },
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
}
