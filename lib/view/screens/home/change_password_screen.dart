import 'package:code_template/Controller/home/change_password_controller.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/view/utils/colors.dart';
import 'package:code_template/view/utils/strings.dart';
import 'package:code_template/view/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../utils/global_variables.dart';
import '../../widgets/body.dart';
import '../../widgets/textfields.dart';

class ChangePassScreen extends StatelessWidget {
  const ChangePassScreen({Key? key}) : super(key: key);

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
              Strings.changePassword,
              style: TextStyle(
                  letterSpacing: 0.1.w,
                  color: Clr.blackColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          body: SafeArea(
            child: GetBuilder<ChangePassController>(
              init: ChangePassController(),
              builder: (changePassLogic) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 5.w),
                child: Form(
                  autovalidateMode: changePassLogic.submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  key: changePassLogic.formKey,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 5.w),
                        MyTextField(
                          controller: changePassLogic.currentPassC,
                          obscureText: changePassLogic.cuPassHide.value,
                          keyboardType: TextInputType.text,
                          hintText: Strings.cuPassHint,
                          textFieldType: Validate.passTxt,
                          validate: Validate.passVal,
                          fill: false,
                          fillColor: Clr.transparent,
                          contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.w),
                          prefixIcon: Icon(Icons.lock_rounded, size: 7.w),
                          suffixIcon: IconButton(
                            onPressed: () {
                              changePassLogic.changeObscureCuP();
                            },
                            icon: Icon(changePassLogic.cuPassHide.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return Validate.cuPassEmpty;
                            }
                            return null;
                          },
                        ),
                        MyTextField(
                          controller: changePassLogic.passC,
                          obscureText: changePassLogic.passHide.value,
                          keyboardType: TextInputType.text,
                          hintText: Strings.newPassHint,
                          textFieldType: Validate.passTxt,
                          validate: Validate.passVal,
                          fill: false,
                          fillColor: Clr.transparent,
                          contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.w),
                          prefixIcon: Icon(Icons.lock_rounded, size: 7.w),
                          suffixIcon: IconButton(
                            onPressed: () {
                              changePassLogic.changeObscureP();
                            },
                            icon: Icon(changePassLogic.passHide.value
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
                          controller: changePassLogic.confirmPassC,
                          obscureText: changePassLogic.conPassHide.value,
                          keyboardType: TextInputType.text,
                          hintText: Strings.confirmPassHint,
                          textFieldType: Validate.passTxt,
                          validate: Validate.confirmPassVal,
                          textInputAction: TextInputAction.done,
                          fill: false,
                          fillColor: Clr.transparent,
                          contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.w),
                          prefixIcon: Icon(Icons.lock_rounded, size: 7.w),
                          suffixIcon: IconButton(
                            onPressed: () {
                              changePassLogic.changeObscureCP();
                            },
                            icon: Icon(changePassLogic.conPassHide.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return Validate.confirmPasswordEmpty;
                            } else if (value != changePassLogic.passC.text) {
                              return Validate.confirmPasswordNotMatch;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30.w),
                        Opacity(
                          opacity: buttonDisable ? 1.0 : 0.2,
                          child: MyButton(
                            width: 65.w,
                            title: Strings.changePassword,
                            onClick: () async {
                              if (buttonDisable) {
                                changePassLogic.submitted = true;
                                changePassLogic.update();
                                if (changePassLogic.formKey.currentState!.validate()) {
                                  buttonDisable = false;
                                  await changePassLogic.changePassword();
                                }
                                Future.delayed(Duration(milliseconds: 500), () {
                                  buttonDisable = true;
                                  changePassLogic.update();
                                });
                              }

                              changePassLogic.update();
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
      ),
    );
  }
}
