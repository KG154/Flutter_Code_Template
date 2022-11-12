import 'package:code_template/module/model/auth/reset_password_model.dart';
import 'package:code_template/module/provider/common_provider.dart';
import 'package:code_template/services/internet_service.dart';
import 'package:code_template/view/utils/loader.dart';
import 'package:code_template/view/utils/strings.dart';
import 'package:code_template/view/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../view/utils/const.dart';

class ResetPassController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  ResetPassModel? resetPassModel;

  Database? database;
  final passHide = true.obs;
  final conPassHide = true.obs;

  bool submitted = false;
  bool buttonDisable = true;

  changeObscureP() {
    if (passHide.value == true) {
      passHide.value = false;
    } else {
      passHide.value = true;
    }
    update();
  }

  changeObscureCP() {
    if (conPassHide.value == true) {
      conPassHide.value = false;
    } else {
      conPassHide.value = true;
    }
    update();
  }

  resetPass() async {
    final hasInternet = await checkInternets();
    try {
      Loader.sw();
      final url = "$baseUrl/reset_password";

      Map<String, dynamic> data = Map<String, dynamic>();
      data["new_pass"] = passC.text.toString();
      data["confirm_pass"] = confirmPassC.text.toString();
      data["email"] = emailC.text.toString();

      //
      dynamic response = await AllProvider().apiProvider(
        url: url,
        bodyData: data,
        database: database,
        method: Method.post,
        storeDB: 0,
      );

      resetPassModel = ResetPassModel.fromJson(response);
      //

      if (resetPassModel != null) {
        if (resetPassModel?.responsecode == 1) {
          MyToast().succesToast(toast: resetPassModel!.message.toString());
          Get.back();
        } else {
          if (hasInternet == true) {
            MyToast().errorToast(toast: resetPassModel!.message.toString());
          }
        }
      } else {
        if (hasInternet == true) {
          MyToast().errorToast(toast: Validate.somethingWrong);
        }
      }
      update();
      Loader.hd();
    } catch (error) {
      Loader.hd();
      print("error == ${error.toString()}");
      if (hasInternet == true) {
        MyToast().errorToast(toast: Validate.somethingWrong);
      }
    }
  }

/*resetPass() async {
    final hasInternet = await checkInternets();
    try {
      Loader.sw();
      Map<String, dynamic> data = Map<String, dynamic>();
      data["new_pass"] = passC.text.toString();
      data["confirm_pass"] = confirmPassC.text.toString();
      data["email"] = emailC.text.toString();
      resetPassModel = await ResetPassProvider().resetPassword(data);
      if (resetPassModel != null) {
        if (resetPassModel?.responsecode == 1) {
          MyToast().succesToast(toast: resetPassModel!.message.toString());
          Get.back();
        } else {
          if (hasInternet == true) {
            MyToast().errorToast(toast: resetPassModel!.message.toString());
          }
        }
      } else {
        if (hasInternet == true) {
          MyToast().errorToast(toast: Validate.somethingWrong);
        }
      }
      update();
      Loader.hd();
    } catch (error) {
      Loader.hd();
      print("error == ${error.toString()}");
      MyToast().errorToast(toast: Validate.somethingWrong);
    }
  }*/

}
