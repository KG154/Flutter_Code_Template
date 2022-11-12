import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:code_template/Controller/auth/sign_up_controller.dart';
import 'package:code_template/Controller/image_picker_controller.dart';
import 'package:code_template/Controller/video_player_controller.dart';
import 'package:code_template/View/widgets/body.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/view/utils/colors.dart';
import 'package:code_template/view/utils/dialog.dart';
import 'package:code_template/view/utils/strings.dart';
import 'package:code_template/view/utils/toast.dart';
import 'package:code_template/view/widgets/button.dart';
import 'package:code_template/view/widgets/textfields.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/const.dart';
import '../../utils/global_variables.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateAnyDirection],
      child: MySafeArea(
        child: Scaffold(
          backgroundColor: Clr.whiteColor,
          appBar: AppBar(
            backgroundColor: Clr.whiteColor,
            centerTitle: true,
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.only(left: 3.w, top: 3.w),
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Clr.blackColor,
                  )),
            ),
          ),
          body: SafeArea(
            child: GetBuilder<SignUpController>(
              init: SignUpController(),
              initState: (signUpLogic) async {
                ///use for get countryCode
                final country = await getDefaultCountry(context);
                signUpLogic.controller?.selectedCountry = country;
                signUpLogic.controller?.countryCodeC.text =
                    signUpLogic.controller?.selectedCountry?.callingCode ?? "";
                print(signUpLogic.controller?.countryCodeC.text.toString());
                signUpLogic.controller?.update();
              },
              builder: (signUpLogic) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 5.w),
                child: Form(
                  autovalidateMode: signUpLogic.submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  key: signUpLogic.formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///show image picker and get image from camera & gallery
                          GetBuilder<ImagePickerController>(
                            init: ImagePickerController(),
                            builder: (imageGetX) => Column(
                              children: [
                                Container(
                                  height: 27.w,
                                  width: 27.w,
                                  margin: EdgeInsets.only(top: 2.w, bottom: 2.w),
                                  decoration: BoxDecoration(
                                      color: Clr.whiteColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 10,
                                            spreadRadius: 5),
                                      ]),
                                  child: imageGetX.pickedImageFile != null
                                      ? Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: FileImage(
                                                  imageGetX.pickedImageFile as File,
                                                ),
                                                fit: BoxFit.fill,
                                              )),
                                        )
                                      : Icon(Icons.camera),
                                ),
                                MyButton(
                                  width: 30.w,
                                  height: 10.w,
                                  title: Strings.imageSelect,
                                  fontSize: 11.sp,
                                  borderRadius: BorderRadius.circular(2.w),
                                  onClick: () {
                                    buildImagePickerDialog(context, () {
                                      Get.back();
                                      imageGetX.pickImage(context, ImageSource.camera);
                                    }, () {
                                      Get.back();
                                      imageGetX.pickImage(context, ImageSource.gallery);
                                    });
                                    signUpLogic.update();
                                  },
                                ),
                              ],
                            ),
                          ),

                          ///get video from gallery
                          GetBuilder<VideoCompressorGetX>(
                            init: VideoCompressorGetX(),
                            builder: (videoGetX) => Column(
                              children: [
                                Container(
                                  height: 27.w,
                                  width: 27.w,
                                  margin: EdgeInsets.only(top: 2.w, bottom: 2.w),
                                  decoration: BoxDecoration(
                                      color: Clr.whiteColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 10,
                                            spreadRadius: 5),
                                      ]),
                                  child: videoGetX.thumbnailFile != null
                                      ? Stack(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                image: DecorationImage(
                                                  image: FileImage(
                                                    videoGetX.thumbnailFile as File,
                                                  ),
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                          Center(
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.play_circle_outline,
                                                color: Clr.whiteColor,
                                                size: 10.w,
                                              ),
                                            ),
                                          ),
                                        ])
                                      : Icon(Icons.video_call),
                                ),
                                MyButton(
                                  width: 30.w,
                                  height: 10.w,
                                  title: Strings.videoSelect,
                                  fontSize: 11.sp,
                                  borderRadius: BorderRadius.circular(2.w),
                                  onClick: () async {
                                    ///check permission for storage file
                                    var status = await Permission.storage.request();

                                    if (status.isGranted) {
                                      videoGetX.pickVideo(null);
                                    } else if (status.isPermanentlyDenied) {
                                      ///if permission isPermanentlyDenied than open setting box dialog
                                      permissionDialog(
                                          context: context,
                                          subTitle: Strings.permissionVideo,
                                          onPressed: () {
                                            AppSettings.openAppSettings();
                                            Get.back();
                                          },
                                          buttonText: Strings.setting,
                                          buttonColor: Clr.blackColor);
                                    }
                                    signUpLogic.update();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.w),
                      MyTextField(
                        controller: signUpLogic.nameC,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        hintText: Strings.nameHint,
                        textFieldType: Validate.nameTxt,
                        validate: Validate.nameVal,
                        prefixIcon: Icon(Icons.person, size: 7.w),
                        fill: false,
                        fillColor: Clr.transparent,
                        contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.w),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Validate.nameEmpty;
                          } else if (value.length <= 2) {
                            return Validate.fNameValidValidator;
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        controller: signUpLogic.emailC,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        hintText: Strings.emailHint,
                        textFieldType: Validate.emailTxt,
                        validate: Validate.emailVal,
                        prefixIcon: Icon(Icons.mail, size: 7.w),
                        fill: false,
                        fillColor: Clr.transparent,
                        contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.w),
                        validator: (v) {
                          if (v!.isEmpty) {
                            return Validate.emailEmpty;
                          } else if (!emailValid.hasMatch(v)) {
                            return Validate.emailValid;
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: MyTextField(
                              onTap: () {
                                ///open country code picker bottom sheet
                                signUpLogic.onPressedShowBottomSheet(context);
                                signUpLogic.update();
                              },
                              controller: signUpLogic.countryCodeC,
                              keyboardType: TextInputType.visiblePassword,
                              hintText: Strings.countryCodeHint,
                              validate: Validate.passVal,
                              textFieldType: Validate.passTxt,
                              readOnly: true,
                              fill: false,
                              fillColor: Clr.transparent,
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      signUpLogic.countryCodeC.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600, color: Colors.black87),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down_rounded,
                                      size: 10.w,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: MyTextField(
                              controller: signUpLogic.phoneAuthC,
                              hintText: Strings.mobileNumberHint,
                              validate: Validate.mobileVal,
                              keyboardType: TextInputType.phone,
                              textFieldType: Validate.numberTxt,
                              maxLength: 10,
                              fill: false,
                              fillColor: Clr.transparent,
                              contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.w),
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return Validate.mobileNumberEmpty;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      MyTextField(
                        controller: signUpLogic.passC,
                        obscureText: signUpLogic.passHide.value,
                        keyboardType: TextInputType.text,
                        hintText: Strings.passHint,
                        textFieldType: Validate.passTxt,
                        validate: Validate.passVal,
                        fill: false,
                        fillColor: Clr.transparent,
                        contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.w),
                        prefixIcon: Icon(Icons.lock_rounded, size: 7.w),
                        suffixIcon: IconButton(
                          onPressed: () {
                            signUpLogic.changeObscureP();
                          },
                          icon: Icon(
                            signUpLogic.passHide.value ? Icons.visibility_off : Icons.visibility,
                          ),
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
                        controller: signUpLogic.confirmPassC,
                        obscureText: signUpLogic.conPassHide.value,
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
                            signUpLogic.changeObscureCP();
                          },
                          icon: Icon(signUpLogic.conPassHide.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return Validate.confirmPasswordEmpty;
                          } else if (value != signUpLogic.passC.text) {
                            return Validate.confirmPasswordNotMatch;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 3.w),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              value: signUpLogic.checkBox.value,
                              onChanged: (value) {
                                signUpLogic.checkBox.value = value ?? false;
                                signUpLogic.update();
                              },
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                                text: "I agree with ",
                                style: TextStyle(color: Colors.black87),
                                children: [
                                  TextSpan(
                                      text: "Terms and conditions",
                                      style: TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          print("click");
                                        }),
                                ]),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.w),
                      Opacity(
                        opacity: buttonDisable ? 1.0 : 0.2,
                        child: MyButton(
                          width: 50.w,
                          title: Strings.signUp,
                          onClick: () async {
                            if (buttonDisable) {
                              signUpLogic.submitted = true;
                              signUpLogic.update();
                              if (signUpLogic.imagePickerController.pickedImageFile == null) {
                                MyToast().warningToast(toast: Validate.imageEmpty);
                              } else if (signUpLogic.videoCompressorGetX.thumbnailFile == null) {
                                MyToast().warningToast(toast: Validate.videoEmpty);
                              } else if (signUpLogic.formKey.currentState!.validate() &&
                                  signUpLogic.imagePickerController.pickedImageFile != null &&
                                  signUpLogic.videoCompressorGetX.thumbnailFile != null) {
                                buttonDisable = false;
                                await signUpLogic.signUpUser();
                              }
                              Future.delayed(Duration(milliseconds: 500), () {
                                buttonDisable = true;
                                signUpLogic.update();
                              });
                            }

                            signUpLogic.update();
                          },
                        ),
                      ),
                      SizedBox(height: 2.w),
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Strings.alrHaveAccount,
                              style: TextStyle(
                                color: Clr.blackColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                              ),
                            ),
                            TextButton(
                              autofocus: false,
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                Strings.login,
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
              dispose: (signUpLogic) {
                ///dispose all controller
                signUpLogic.controller?.nameC.clear();
                signUpLogic.controller?.emailC.clear();
                signUpLogic.controller?.phoneAuthC.clear();
                signUpLogic.controller?.passC.clear();
                signUpLogic.controller?.confirmPassC.clear();
                signUpLogic.controller?.countryCodeC.clear();
              },
            ),
          ),
        ),
      ),
    );
  }
}
