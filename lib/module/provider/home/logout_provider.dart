import 'dart:developer';
import 'dart:io';

import 'package:code_template/main.dart';
import 'package:code_template/module/model/home/logout_model.dart';
import 'package:code_template/services/internet_service.dart';
import 'package:code_template/view/utils/strings.dart';
import 'package:code_template/view/utils/toast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../view/screens/auth/login_screen.dart';
import '../../../view/utils/const.dart';
import '../../../view/utils/global_variables.dart';

class LogoutProvider {
  Future<LogoutModel?> userLogoutApi() async {
    final hasInternet = await checkInternets();
    if (hasInternet == true) {
      try {
        // uniqueToken = await Storage.getToken();
        uniqueToken = Preferences?.getString("uToken");
        log(uniqueToken.toString());

        final url = "$baseUrl/user_logout";

        final response = await http.post(Uri.parse(url), headers: {"Token": uniqueToken!});

        final responseBody = returnResponse(response);

        if (response.statusCode == 200) {
          log(response.body, name: "logout User");
          // Store in Model
          LogoutModel data = LogoutModel.fromJson(responseBody);
          return data;
        } else if (response.statusCode == 101 || response.statusCode == 102) {
          // Show Error
          Get.offAll(() => LoginScreen());
          MyToast().errorToast(toast: Validate.somethingWrong);
          return null;
        } else if (response.statusCode == 404) {
          MyToast().errorToast(toast: Validate.somethingWrong);
          return null;
        } else if (response.statusCode == 500) {
          MyToast().errorToast(toast: Validate.inSReq);
          return null;
        } else {
          LogoutModel data = LogoutModel.fromJson(responseBody);
          return data;
        }
      } on SocketException catch (e) {
        throw Exception(Validate.noInternet);
      } on FormatException catch (e) {
        throw Exception(Validate.badReq);
      } catch (exception) {
        return null;
      }
    } else {
      MyToast().errorToast(toast: Validate.noInternet);
      return null;
    }
  }
}
