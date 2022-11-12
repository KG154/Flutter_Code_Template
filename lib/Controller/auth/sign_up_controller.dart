import 'package:code_template/Controller/image_picker_controller.dart';
import 'package:code_template/Controller/video_player_controller.dart';
import 'package:code_template/View/Utils/loader.dart';
import 'package:code_template/module/model/auth/signup_model.dart';
import 'package:code_template/module/provider/auth/signup_provider.dart';
import 'package:code_template/services/internet_service.dart';
import 'package:code_template/view/screens/home/userlist_screen.dart';
import 'package:code_template/view/utils/strings.dart';
import 'package:code_template/view/utils/toast.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  ImagePickerController imagePickerController = Get.put(ImagePickerController());
  VideoCompressorGetX videoCompressorGetX = Get.put(VideoCompressorGetX());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();
  TextEditingController phoneAuthC = TextEditingController();
  TextEditingController countryCodeC = TextEditingController();

  final passHide = true.obs;
  final conPassHide = true.obs;
  final checkBox = false.obs;

  RxString abc = "".obs;

  bool submitted = false;

  Country? selectedCountry;

  SignUpModel? signUpModel;

  @override
  void onInit() {
    super.onInit();
  }

  //for show country code picker
  onPressedShowBottomSheet(BuildContext context) async {
    final country = await showCountryPickerSheet(
      cancelWidget: Container(),
      title: Container(),
      context,
    );
    if (country != null) {
      selectedCountry = country;
      countryCodeC.text = selectedCountry!.callingCode;
      print("countryCode :- ${selectedCountry!.callingCode}");
      update();
    }
  }

  //for hide and show password
  changeObscureP() {
    passHide.value = !passHide.value;
    update();
  }

  changeObscureCP() {
    conPassHide.value = !conPassHide.value;
    update();
  }

  signUpUser(
      {String? loginType,
      String? userName,
      String? userEmail,
      String? profileImage,
      String? socialId,
      String? phoneNum}) async {
    final hasInternet = await checkInternets();
    try {
      Loader.sw();
      String user_login_type = loginType ?? "normal_login";
      String name = userName ?? nameC.text.toString();
      String email = userEmail ?? emailC.text.toString();
      String password = passC.text.toString();
      String social_id = socialId ?? "";
      String phone = phoneNum ?? phoneAuthC.text.toString();
      String phone_country_code = countryCodeC.text.toString();
      String profile_image =
          profileImage ?? imagePickerController.pickedImageFile?.path.toString() ?? "";
      String bio_video = videoCompressorGetX.filePath.value.toString();
      String? bio_thumb = videoCompressorGetX.thumbnailFile?.path.toString() ?? null;

      signUpModel = await SignUpProvider().signUpUser(
        user_login_type: user_login_type,
        name: name,
        email: email,
        password: password,
        social_id: social_id,
        phone: phone,
        phone_country_code: phone_country_code,
        profile_image: profile_image,
        bio_video: bio_video,
        bio_thumb: bio_thumb,
      );

      if (signUpModel != null) {
        if (signUpModel!.responsecode == 1) {
          MyToast().succesToast(toast: signUpModel!.message.toString());
          if (signUpModel?.data?.userLoginType != "normal_login") {
            Get.off(() => UserListScreen());
          } else {
            Get.back();
          }

          update();
        } else {
          if (hasInternet == true) {
            MyToast().errorToast(toast: signUpModel?.message.toString());
          }
        }
      } else {
        if (hasInternet == true) {
          MyToast().errorToast(toast: Validate.somethingWrong);
        }
      }
      update();
      Loader.hd();
    } catch (error) {
      Loader.hd();
      print("error == ${error.toString()}");
      if (hasInternet == true) {
        MyToast().errorToast(toast: Validate.somethingWrong);
      }
    }
  }
}
