import 'package:code_template/Controller/auth/splash_controller.dart';
import 'package:code_template/View/Utils/const.dart';
import 'package:code_template/module/model/auth/user_login_model.dart';
import 'package:code_template/module/provider/common_provider.dart';
import 'package:code_template/services/internet_service.dart';
import 'package:code_template/services/local_storage.dart';
import 'package:code_template/view/screens/home/userlist_screen.dart';
import 'package:code_template/view/utils/loader.dart';
import 'package:code_template/view/utils/shared_preference.dart';
import 'package:code_template/view/utils/strings.dart';
import 'package:code_template/view/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class LoginController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  UserLoginModel? userLoginModel;
  Database? database;
  final passHide = true.obs;
  bool submitted = false;

  @override
  void onInit() {
    SplashController().getUniqueToken();
    super.onInit();
  }


  //for hide and show password
  changeObscureP() {
    passHide.value = !passHide.value;
    update();
  }

  userLogin() async {
    final hasInternet = await checkInternets();
    try {
      Loader.sw();
      final url = "$baseUrl/user_login";
      Map<String, dynamic> data = Map<String, dynamic>();
      data["email"] = emailC.text;
      data["password"] = passC.text;

      //
      dynamic response = await AllProvider().apiProvider(
        url: url,
        bodyData: data,
        database: database,
        method: Method.post,
        storeDB: 0,
      );

      userLoginModel = await UserLoginModel.fromJson(response);
      //

      if (userLoginModel != null) {
        if (userLoginModel?.responsecode == 1) {
          MyToast().succesToast(toast: userLoginModel?.message.toString());
          Utils.userID = userLoginModel?.data?.userId.toString();
          box.write("user_id", Utils.userID);
          Storage.saveUser(userLoginModel!);
          Get.off(() => UserListScreen());
        } else {
          if (hasInternet == true) {
            MyToast().errorToast(toast: userLoginModel?.message.toString());
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
      if (hasInternet == true) {
        MyToast().errorToast(toast: Validate.somethingWrong);
      }
    }
  }

// userLogin() async {
//   final hasInternet = await checkInternets();
//   try {
//     Loader.sw();
//     Map<String, dynamic> data = Map<String, dynamic>();
//     data["email"] = emailC.text;
//     data["password"] = passC.text;
//     UserLoginModel? userLoginModel =
//         await LoginScreenProvider().userLogin(data);
//     if (userLoginModel != null) {
//       if (userLoginModel.responsecode == 1) {
//         MyToast().succesToast(toast: userLoginModel.message.toString());
//         Utils.userID = userLoginModel.data?.userId.toString();
//         box.write("user_id", Utils.userID);
//         Storage.saveUser(userLoginModel);
//         Get.off(() => UserListScreen());
//       } else {
//         if (hasInternet == true) {
//           MyToast().errorToast(toast: userLoginModel.message.toString());
//         }
//       }
//     } else {
//       if (hasInternet == true) {
//         MyToast().errorToast(toast: Validate.somethingWrong);
//       }
//     }
//     Loader.hd();
//     update();
//   } catch (error) {
//     Loader.hd();
//     print("error == ${error.toString()}");
//     MyToast().errorToast(toast: Validate.somethingWrong);
//   }
// }
}
