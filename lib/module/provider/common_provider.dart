import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:code_template/services/internet_service.dart';
import 'package:code_template/services/sqflite_database.dart';
import 'package:code_template/view/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../../main.dart';
import '../../view/utils/global_variables.dart';
import '../../view/utils/strings.dart';
import '../../view/utils/toast.dart';

class AllProvider {
  ///create common provider for api calling

  Future<dynamic> apiProvider(
      {required String? url,
      String? method = Method.post,
      required Map<String, dynamic> bodyData,
      int? storeDB = 1,
      required Database? database}) async {
    // 1 for store in database and 0 for only api calling
    final hasInternet = await checkInternets();
    if (hasInternet == true) {
      try {
        uniqueToken = Preferences?.getString("uToken");
        log(uniqueToken.toString());

        http.Response? response;
        if (method == Method.post) {
          ///get response for post method
          response =
              await http.post(Uri.parse(url!), body: bodyData, headers: {"Token": uniqueToken!});
        } else if (method == Method.get) {
          response = await http.get(Uri.parse(url!), headers: {"Token": uniqueToken!});
        } else if (method == Method.put) {
          response =
              await http.put(Uri.parse(url!), body: bodyData, headers: {"Token": uniqueToken!});
        } else if (method == Method.delete) {
          response =
              await http.delete(Uri.parse(url!), body: bodyData, headers: {"Token": uniqueToken!});
        } else {
          MyToast().errorToast(toast: Validate.defineMethod);
        }

        if (response?.statusCode == 200) {
          debugPrint("<============= ${url} =============>\n ${response?.body}");

          //store response in local database
          if (storeDB == 1) {
            insertUpdateDB(
                database: database!,
                uri: url!,
                body: bodyData.toString(),
                response: response?.body,
                header: {"Token": uniqueToken!}.toString(),
                time: DateFormat("MM-dd-yyyy HH:mm").format(DateTime.now()).toString());
          }

          return json.decode("${response?.body}");
        } else if (response?.statusCode == 101 || response?.statusCode == 102) {
          // Show Error
          Get.offAll(() => LoginScreen());
          MyToast().errorToast(toast: Validate.somethingWrong);
          return null;
        } else if (response?.statusCode == 404) {
          //for if there is no data found or something went wrong
          MyToast().errorToast(toast: Validate.somethingWrong);
          return null;
        } else if (response?.statusCode == 500) {
          //for if there is Internal Server Error
          MyToast().errorToast(toast: Validate.inSReq);
          return null;
        } else {
          return json.decode("${response?.body}");
        }
      } on SocketException catch (e) {
        throw Exception(Validate.noInternet);
      } on FormatException catch (e) {
        throw Exception(Validate.badReq);
      } catch (exception) {
        return null;
      }
    } else {
      String? response;
      MyToast().errorToast(toast: Validate.noInternet);
      if (storeDB == 1) {
        //if internet is off than get response from local database
        await DatabaseHandler().rawData(database!, url!, bodyData.toString()).then((value) {
          List val = value;
          // debugPrint("<=============::: ${url} :::=============>\n ${val.first['response']}");

          if (val.isNotEmpty) {
            response = val.first['response'];
            return json.decode(val.first['response']);
          }
        });
      }
      return json.decode("$response");
    }
  }

/*Future<dynamic> multipartAPIProvider({required String? url}) async {
    final hasInternet = await checkInternets();
    if (hasInternet == true) {
      try {
        log(uniqueToken.toString());
        http.Response? response;

        if (response?.statusCode == 200) {
          debugPrint(
              "<============= ${url} =============>\n ${response?.body}");

          return json.decode("${response?.body}");
        } else if (response?.statusCode == 101 || response?.statusCode == 102) {
          // Show Error
          MyToast().errorToast(toast: Validate.somethingWrong);
          return null;
        } else if (response?.statusCode == 404) {
          //for if there is no data found or something went wrong
          MyToast().errorToast(toast: Validate.somethingWrong);
          return null;
        } else if (response?.statusCode == 500) {
          MyToast().errorToast(toast: Validate.inSReq);
          return null;
        } else {
          return json.decode("${response?.body}");
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
  }*/
}
