import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:code_template/View/Utils/colors.dart';
import 'package:code_template/View/Utils/const.dart';
import 'package:code_template/View/Utils/strings.dart';
import 'package:code_template/View/Utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../view/utils/dialog.dart';

class ImagePickerController extends GetxController {
  ImagePicker picker = ImagePicker();
  File? pickedImageFile;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> pickImage(BuildContext context, ImageSource imageSource) async {
    if (Platform.isIOS) {
    } else {
      //for get storage permission when user select image  ( only for Android )
      var status = await Permission.storage.request();
      if (status.isPermanentlyDenied) {
        //if permission denied than show go to app setting dialog
        return permissionDialog(
            context: navigatorKey.currentContext!,
            subTitle: Strings.permissionVideo,
            onPressed: () {
              AppSettings.openAppSettings();
              Get.back();
            },
            buttonText: Strings.setting,
            buttonColor: Clr.blackColor);
      }
    }

    //pick image form camera & gallery
    final pickedImage =
        await picker.pickImage(source: imageSource).catchError((onError) {
      // if permission not allow then go to app setting ( only for ios )
      if (Platform.isIOS) {
        if (onError.message.toString() ==
            "The user did not allow photo access.") {
          permissionDialog(
              context: navigatorKey.currentContext!,
              subTitle: Strings.permissionCamera,
              onPressed: () {
                AppSettings.openAppSettings();
                Get.back();
              },
              buttonText: Strings.setting,
              buttonColor: Clr.blackColor);
        }
      }
    });
    if (pickedImage != null) {
      File fileImage = File(pickedImage.path);
      // image selected than go to the crop image
      pickedImageFile = await _cropImage(fileImage);
    } else {
      MyToast().warningToast(toast: "You have canceled the photo selection.");
    }
    update();
  }

  //crop image
  Future<File?> _cropImage(File fileImage) async {
    CroppedFile? croppedFile1 = await ImageCropper().cropImage(
      sourcePath: fileImage.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Image Crop',
          toolbarColor: Clr.whiteColor,
          toolbarWidgetColor: Clr.blackColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'Image Crop',
        )
      ],
    );
    if (croppedFile1 != null) {
      // Crop image
      pickedImageFile = File(croppedFile1.path);
      update();
    }

    if (croppedFile1 != null) {
      File file = File(croppedFile1.path);
      int bytes = await file.length();
      final bytess = file.readAsBytesSync().lengthInBytes;
      final kb = bytess / 1024;
      final mb = kb / 1024;
      var i = (log(bytes) / log(1024)).floor();
      if (i >= 2) {
        //if image size 2 mb or above than compress size below 2 mb
        File? compressedImg = await this.compressImage(file, 90);
        if (compressedImg != null && compressedImg.lengthSync() > 0) {
          file = compressedImg;
        }
      }
      double kbCompress = (await file.readAsBytes()).lengthInBytes / 1024;
      double mbCompress = kbCompress / 1024;
      print("Old Size : $mb MB");
      print("Final Size : $mbCompress MB");
    }
    return pickedImageFile;
  }

  //compress image below 2 mb
  Future<File?> compressImage(File croppedFile, int quality) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = dir.absolute.path + "/temp.jpg";
    int newQuality = quality;

    File? result;
    double kbCompress = (await croppedFile.readAsBytes()).lengthInBytes / 1024;
    double mbCompress = kbCompress / 1024;

    // Compress image with -10 quality
    while (mbCompress > 2 && newQuality > 10) {
      newQuality -= 10;
      result = await FlutterImageCompress.compressAndGetFile(
          croppedFile.path, targetPath,
          quality: newQuality);

      if (result != null) {
        kbCompress = (await result.readAsBytes()).lengthInBytes / 1024;
        mbCompress = kbCompress / 1024;
      } else {
        return croppedFile;
      }
    }
    return result;
  }
}
