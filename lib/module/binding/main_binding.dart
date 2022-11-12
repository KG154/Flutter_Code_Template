import 'package:code_template/Controller/auth/login_controller.dart';
import 'package:code_template/Controller/auth/reset_password_controller.dart';
import 'package:code_template/Controller/auth/sign_up_controller.dart';
import 'package:code_template/Controller/auth/splash_controller.dart';
import 'package:code_template/Controller/home/change_password_controller.dart';
import 'package:code_template/Controller/home/logout_controller.dart';
import 'package:code_template/Controller/home/pagination_controller.dart';
import 'package:code_template/Controller/home/profile_controller.dart';
import 'package:code_template/Controller/image_picker_controller.dart';
import 'package:code_template/Controller/video_player_controller.dart';
import 'package:get/get.dart';

import '../../Controller/home/setting_screen_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => ResetPassController());
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => SplashController());

    Get.lazyPut(() => ImagePickerController());
    Get.lazyPut(() => VideoCompressorGetX());

    Get.lazyPut(() => ChangePassController());
    Get.lazyPut(() => LogOutController());
    Get.lazyPut(() => PaginationController());
    Get.lazyPut(() => ProfileDetailController());
    Get.lazyPut(() => SettingScreenController());
  }
}
