import 'package:code_template/module/model/home/user_list_model.dart';
import 'package:code_template/module/provider/common_provider.dart';
import 'package:code_template/services/internet_service.dart';
import 'package:code_template/view/utils/loader.dart';
import 'package:code_template/view/utils/strings.dart';
import 'package:code_template/view/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../services/sqflite_database.dart';
import '../../view/utils/const.dart';

class PaginationController extends GetxController {
  ScrollController userListSc = ScrollController();
  RxList<UserListData> userList = RxList<UserListData>();
  var page = 1.obs;
  var pageLoader = false.obs;
  var callRunning = false.obs;

  // UserListModel? userListModel;
  Database? database;
  RxString userId = "".obs;

  @override
  void onInit() {
    DatabaseHandler().CreateDataBase().then(
      (value) {
        database = value;
        userListSc.addListener(() {
          if (userListSc.position.pixels ==
              userListSc.position.maxScrollExtent) {
            userListData();
          }
        });
        userListData();
        update();
      },
    );

    /// check internet when app open &
    /// data on  - get data from api &
    /// data off - sqflite db
    internetOnOff(data: () {
      DatabaseHandler().CreateDataBase().then(
        (value) {
          database = value;
          userListSc.addListener(() {
            if (userListSc.position.pixels ==
                userListSc.position.maxScrollExtent) {
              userListData();
            }
          });
          userListData();
          update();
        },
      );
    });
    super.onInit();
  }

  Future<void> userListData() async {
    final hasInternet = await checkInternets();
    if (callRunning.isFalse) {
      callRunning.value = true;
      update();
      if (page.value != 1) {
        pageLoader.value = true;
        update();
      } else {
        Loader.sw();
        update();
      }

      try {
        final url = "$baseUrl/user_list";
        Map<String, dynamic> data = Map<String, dynamic>();
        data["page_no"] = page.value.toString();

        //
        dynamic response = await AllProvider().apiProvider(
          url: url,
          bodyData: data,
          database: database,
          method: Method.post,
          storeDB: 1,
        );
        UserListModel? userListModel;
        if (response != null)
          userListModel = await UserListModel.fromJson(response);
        update();
        //

        ///page add
        page.value++;
        Loader.hd();
        callRunning.value = false;
        pageLoader.value = false;
        if (userListModel != null) {
          if (userListModel.status == true) {
            if (userListModel.data != null) {
              for (int i = 0; i < userListModel.data!.length; i++) {
                print("${userListModel.data![i].email}");
                userList.add(userListModel.data![i]);
                update();
              }
            } else {
              MyToast().errorToast(toast: "Data not found.");
            }
            update();
          } else {
            if (hasInternet == true) {
              MyToast()
                  .errorToast(toast: "${userListModel.message.toString()}");
            }
            if (userListModel.responsecode == 101) {
              // sessionExpire();
            }
            update();
          }
        } else {
          if (hasInternet == true) {
            MyToast().errorToast(toast: Validate.somethingWrong);
          }
        }
      } finally {
        pageLoader.value = false;
        Loader.hd();
        update();
      }
      update();
    }
  }

/*Future<void> userListData() async {
    final hasInternet = await checkInternets();
    if (callRunning.isFalse) {
      callRunning.value = true;
      update();
      if (page.value != 1) {
        pageLoader.value = true;
        update();
      } else {
        Loader.sw();
      }

      try {
        Map<String, dynamic> data = Map<String, dynamic>();
        data["page_no"] = page.value.toString();
        // data["page_no"] = "513";
        // userListModel = await UserListProvider().userListApi(data,database!);
        userListModel = await UserListProvider().userListApi(data, database);

        ///page add
        page.value++;
        Loader.hd();
        callRunning.value = false;
        pageLoader.value = false;
        if (userListModel != null) {
          if (userListModel?.status == true) {
            if (userListModel?.data != null) {
              for (int i = 0; i < userListModel!.data!.length; i++) {
                print("${userListModel!.data![i].email}");
                userList.add(userListModel!.data![i]);
              }
            } else {
              update();
              MyToast().errorToast(toast: "Data not found.");
            }
            update();
          } else {
            if (hasInternet == true) {
              MyToast()
                  .errorToast(toast: "${userListModel?.message.toString()}");
            }
            if (userListModel?.responsecode == 101) {
              // sessionExpire();
            }
            update();
          }
        } else {
          if (hasInternet == true) {
            MyToast().errorToast(toast: Validate.somethingWrong);
          }
        }
      } finally {
        pageLoader.value = false;
        Loader.hd();
        update();
      }
      update();
    }
  }*/
}
