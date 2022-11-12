import 'package:code_template/module/model/home/change_password_model.dart';
import 'package:code_template/module/provider/common_provider.dart';
import 'package:code_template/services/internet_service.dart';
import 'package:code_template/view/utils/loader.dart';
import 'package:code_template/view/utils/strings.dart';
import 'package:code_template/view/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../view/utils/const.dart';

class ChangePassController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();
  TextEditingController currentPassC = TextEditingController();

  Database? database;
  final cuPassHide = true.obs;
  final passHide = true.obs;
  final conPassHide = true.obs;

  ChangePassModel? changePassModel;

  bool submitted = false;

  //for hide and show password
  changeObscureCuP() {
    if (cuPassHide.value == true) {
      cuPassHide.value = false;
    } else {
      cuPassHide.value = true;
    }
    update();
  }

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

  changePassword() async {
    final hasInternet = await checkInternets();
    try {
      Loader.sw();
      final url = "$baseUrl/change_password";
      Map<String, dynamic> data = Map<String, dynamic>();
      data["current_pass"] = currentPassC.text.toString();
      data["new_pass"] = passC.text.toString();
      data["confirm_pass"] = confirmPassC.text.toString();

      //
      dynamic response = await AllProvider().apiProvider(
        url: url,
        bodyData: data,
        database: database,
        method: Method.post,
        storeDB: 0,
      );
      changePassModel = await ChangePassModel.fromJson(response);

      //
      if (changePassModel != null) {
        if (changePassModel?.responsecode == 1) {
          MyToast().succesToast(toast: changePassModel!.message.toString());
          Get.back();
          currentPassC.clear();
          passC.clear();
          confirmPassC.clear();
        } else {
          if (hasInternet == true) {
            MyToast().errorToast(toast: changePassModel!.message.toString());
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
  }
}
