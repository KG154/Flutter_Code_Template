import 'package:app_settings/app_settings.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../view/utils/colors.dart';
import '../view/utils/const.dart';
import '../view/utils/dialog.dart';
import '../view/utils/global_variables.dart';
import '../view/utils/strings.dart';

class CurrLocation {
  ///for get currentLocation
  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return permissionDialog(
          context: navigatorKey.currentContext!,
          subTitle: "Location permissions are permanently denied",
          onPressed: () {
            AppSettings.openAppSettings();
            Get.back();
          },
          buttonText: Strings.setting,
          buttonColor: Clr.blackColor);
      // return Future.error('Location permissions are permanently denied');
    }

    if (serviceEnabled) {
      currentLatLong = await Geolocator.getCurrentPosition();
      print("------->${currentLatLong?.latitude}");
      print("------->${currentLatLong?.longitude}");

      List<Placemark> placemarks =
          await placemarkFromCoordinates(currentLatLong!.latitude, currentLatLong!.longitude);
      Placemark place = placemarks[0];

      cityCSC = place.locality ?? "";
      stateCSC = place.administrativeArea ?? "";
      countryCSC = place.country ?? "";
      print("//////$cityCSC#$stateCSC#$countryCSC/////");
    }
  }
}
