import 'dart:convert';
import 'dart:developer';

import 'package:code_template/main.dart';
import 'package:code_template/module/model/auth/user_login_model.dart';

class Storage {
  static String userData = 'UserData';
  static String token = 'token';

  static saveUser(UserLoginModel userModel) async {
    String json = jsonEncode(userModel.toJson());
    log(json.toString(), name: "sharepref");
    await appPreferences?.setString(userData, json.toString());
  }

  static getUser() {
    var userString = appPreferences?.getString(userData);
    if (userString != null) {
      Map<String, dynamic> userMap = jsonDecode(userString);
      UserLoginModel user = UserLoginModel.fromJson(userMap);
      return user;
    } else {
      return null;
    }
  }

  /*static saveToken(String? uniqueToken) async {
    log(uniqueToken.toString(), name: "Store Unique Token");
    await appPreferences?.setString(token, uniqueToken.toString());
  }

  static getToken() {
    var uniqueToken = appPreferences?.getString(token);
    log(uniqueToken.toString(), name: "Get Unique Token");

    return uniqueToken;
  }*/

  static clearData() {
    return appPreferences?.clear();
  }
}
