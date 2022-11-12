import 'dart:developer';
import 'dart:io';

import 'package:code_template/View/Utils/toast.dart';
import 'package:code_template/module/model/auth/check_app_version_model.dart';
import 'package:code_template/module/provider/auth/app_version_provider.dart';
import 'package:code_template/services/internet_service.dart';
import 'package:code_template/services/local_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../view/utils/const.dart';
import '../../view/utils/loader.dart';
import '../../view/utils/strings.dart';

class SplashController extends GetxController {
  CheckAppVersionModel? checkAppVersionModel;

  getUniqueToken() async {
    await checkAppVersion();
  }

  checkAppVersion() async {
    final hasInternet = await checkInternets();
    try {
      Utils.deviceToken = await FirebaseMessaging.instance.getToken();
      Utils.deviceType = await Platform.isIOS ? "ios" : "android";
      log(Utils.deviceToken.toString(), name: "deviceToken");

      Map<String, dynamic> data = Map<String, dynamic>();
      data["application_version"] = Utils.appVersion;
      data["device_type"] = Utils.deviceType;
      data["device_token"] = Utils.deviceToken;

      checkAppVersionModel = await CheckAppVersionProvider().checkAppVersion(data);

      if (checkAppVersionModel != null) {
        if (checkAppVersionModel?.data != null) {
          String? uToken = checkAppVersionModel?.data?.uniqueToken;
          await Preferences?.setString("uToken", uToken!);
          setToken(deviceToken: Utils.deviceToken);
          update();
        } else {
          if (hasInternet == true) {
            MyToast().errorToast(toast: checkAppVersionModel?.message.toString());
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
