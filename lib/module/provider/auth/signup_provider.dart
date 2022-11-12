import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:code_template/main.dart';
import 'package:code_template/module/model/auth/signup_model.dart';
import 'package:code_template/services/internet_service.dart';
import 'package:code_template/view/utils/strings.dart';
import 'package:code_template/view/utils/toast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../view/screens/auth/login_screen.dart';
import '../../../view/utils/const.dart';
import '../../../view/utils/global_variables.dart';

class SignUpProvider {
  Future<SignUpModel?> signUpUser({
    String? user_login_type,
    String? name,
    String? email,
    String? password,
    String? social_id,
    String? phone,
    String? phone_country_code,
    String? profile_image,
    String? bio_video,
    String? bio_thumb,
  }) async {
    final hasInternet = await checkInternets();
    if (hasInternet == null || !hasInternet) {
      MyToast().errorToast(toast: Validate.noInternet);
      return null;
    }

    final url = "$baseUrl/user_register";
    log("$url", name: "User Register");
    try {
      uniqueToken = Preferences?.getString("uToken");
      log(uniqueToken.toString());

      //if sand image(File) in to server than we use MultipartRequest api method
      final response = await http.MultipartRequest('POST', Uri.parse(url));
      var headers = {"Token": uniqueToken!};
      response.headers.addAll(headers);
      response.fields["user_login_type"] = user_login_type!;
      response.fields["name"] = name!;
      response.fields["email"] = email!;
      if (password != null) {
        response.fields["password"] = password;
      }
      response.fields["social_id"] = social_id!;
      if (phone != null) {
        response.fields["phone"] = phone;
      }
      if (phone_country_code != null) {
        response.fields["phone_country_code"] = phone_country_code;
      }
      if (profile_image != null) {
        if (user_login_type == "normal_login") {
          response.files.add(await http.MultipartFile.fromPath('profile_image', profile_image));
        } else {
          response.fields["profile_image"] = profile_image;
        }
      }
      if (user_login_type == "normal_login") {
        if (bio_video != null) {
          response.files.add(await http.MultipartFile.fromPath('bio_video', bio_video));
        }
        if (bio_thumb != null) {
          response.files.add(await http.MultipartFile.fromPath('bio_thumb', bio_thumb));
        }
      }
      response.fields["device_type"] = Utils.deviceType.toString();
      response.fields["device_token"] = Utils.deviceToken.toString();

      var res = await response.send();

      var respond = await http.Response.fromStream(res);

      //Set data in Model
      if (res.statusCode == 200) {
        SignUpModel data = SignUpModel.fromJson(jsonDecode(respond.body));
        log(res.statusCode.toString(), name: "SignUp User");
        return data;
      } else if (res.statusCode == 101 || res.statusCode == 102) {
        Get.offAll(() => LoginScreen());
        MyToast().errorToast(toast: Validate.somethingWrong);
        return null;
      } else if (res.statusCode == 404) {
        //for if there is no data found or something went wrong
        MyToast().errorToast(toast: Validate.somethingWrong);
        return null;
      } else if (res.statusCode == 500) {
        MyToast().errorToast(toast: Validate.inSReq);
        return null;
      } else {
        SignUpModel data = SignUpModel.fromJson(jsonDecode(respond.body));
        return data;
      }
    } on SocketException catch (e) {
      throw Exception(e);
    } on FormatException catch (e) {
      throw Exception(Validate.badReq);
    } catch (exception) {
      return null;
    }
  }
}
