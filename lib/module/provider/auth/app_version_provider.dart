import 'dart:developer';
import 'dart:io';

import 'package:code_template/module/model/auth/check_app_version_model.dart';
import 'package:code_template/services/internet_service.dart';
import 'package:code_template/view/utils/strings.dart';
import 'package:code_template/view/utils/toast.dart';
import 'package:http/http.dart' as http;

import '../../../view/utils/const.dart';

class CheckAppVersionProvider {
  Future<CheckAppVersionModel?> checkAppVersion(bodyData) async {
    final hasInternet = await checkInternets();
    if (hasInternet == true) {
      try {
        final url = "$baseUrl/check_app_version";

        log("<=============${url}=============>\n${bodyData}",
            name: "Check Version bodyData");

        final response = await http.post(
          Uri.parse(url),
          body: bodyData,
        );
        final responseBody = returnResponse(response);

        if (response.statusCode == 200) {
          print(response.statusCode);
          log("${response.body}", name: "Check Version");
          CheckAppVersionModel data = CheckAppVersionModel.fromJson(responseBody);
          return data;
        } else if (response.statusCode == 101 || response.statusCode == 102) {
          // Show Error
          MyToast().errorToast(toast: Validate.somethingWrong);
          return null;
        } else if (response.statusCode == 404) {
          MyToast().errorToast(toast: Validate.somethingWrong);
          return null;
        } else if (response.statusCode == 500) {
          MyToast().errorToast(toast: Validate.inSReq);
          return null;
        } else {
          CheckAppVersionModel data = CheckAppVersionModel.fromJson(responseBody);
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
    }
  }
}
