import 'package:code_template/Controller/video_player_controller.dart';
import 'package:code_template/module/model/home/profile_detail_model.dart';
import 'package:code_template/module/provider/common_provider.dart';
import 'package:code_template/services/internet_service.dart';
import 'package:code_template/services/local_storage.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../view/utils/const.dart';
import '../../view/utils/loader.dart';
import '../../view/utils/strings.dart';
import '../../view/utils/toast.dart';

class ProfileDetailController extends GetxController {
  VideoCompressorGetX videoCompressorGetX = Get.put(VideoCompressorGetX());

  ProfileDetailModel? profileDetailModel;
  Database? database;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  profileUserDetail() async {
    final hasInternet = await checkInternets();
    var userId = box.read("user_id");
    try {
      Loader.sw();
      final url = "$baseUrl/get_user_detail";
      Map<String, dynamic> data = Map<String, dynamic>();
      data["user_id"] = userId.toString();

      //
      dynamic response = await AllProvider().apiProvider(
        url: url,
        bodyData: data,
        database: database,
        method: Method.post,
        storeDB: 1,
      );

      print(response);
      profileDetailModel = await ProfileDetailModel.fromJson(response);
      //

      if (profileDetailModel != null) {
        if (profileDetailModel?.responsecode == 1) {
          print("profile get succesfully");
          print("profile Name ${profileDetailModel?.data?.name.toString()}");
        } else {
          if (hasInternet == true) {
            MyToast()
                .succesToast(toast: profileDetailModel!.message.toString());
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

/*profileUserDetail() async {
    final hasInternet = await checkInternets();
    var userId = box.read("user_id");
    try {
      Loader.sw();

      Map<String, dynamic> data = Map<String, dynamic>();
      data["user_id"] = userId.toString();

      profileDetailModel =
          await ProfileProvider().profileDetailApi(data, database);
      if (profileDetailModel != null) {
        if (profileDetailModel?.responsecode == 1) {
          print("profile get succesfully");
          print("profile ${profileDetailModel?.data?.name.toString()}");
        } else {
          if (hasInternet == true) {
            MyToast()
                .succesToast(toast: profileDetailModel!.message.toString());
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
  }*/
}
