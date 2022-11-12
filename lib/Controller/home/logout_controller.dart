import 'dart:developer';

import 'package:code_template/Controller/auth/google_facebook_controller.dart';
import 'package:code_template/main.dart';
import 'package:code_template/module/model/home/logout_model.dart';
import 'package:code_template/module/provider/home/logout_provider.dart';
import 'package:code_template/services/internet_service.dart';
import 'package:code_template/view/utils/shared_preference.dart';
import 'package:get/get.dart';

import '../../view/screens/auth/login_screen.dart';
import '../../view/utils/global_variables.dart';
import '../../view/utils/loader.dart';
import '../../view/utils/strings.dart';
import '../../view/utils/toast.dart';

class LogOutController extends GetxController {
  userLogout() async {
    final hasInternet = await checkInternets();
    try {
      Loader.sw();

      LogoutModel? logoutModel = await LogoutProvider().userLogoutApi();

      if (logoutModel != null) {
        if (logoutModel.status == true) {
          uniqueToken = Preferences?.getString("uToken");
          Storage.clearData();
          await FGAuthControler().signOut();
          uniqueToken = logoutModel.data?.uniqueToken;
          await Preferences?.setString("uToken", uniqueToken!);
          log(uniqueToken.toString());
          MyToast().succesToast(toast: logoutModel.message.toString());

          Get.offAll(() => LoginScreen());
        } else {
          if (hasInternet == true) {
            MyToast().errorToast(toast: logoutModel.message.toString());
          }
        }
      } else {
        if (hasInternet == true) {
          MyToast().errorToast(toast: Validate.somethingWrong);
        }
      }
      Loader.hd();
      update();
    } catch (error) {
      Loader.hd();
      print("error == ${error.toString()}");
      MyToast().errorToast(toast: Validate.somethingWrong);
    }
  }
}
