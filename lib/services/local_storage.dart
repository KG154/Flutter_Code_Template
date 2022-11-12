import 'package:get_storage/get_storage.dart';

class Preference {
  // static const String uniqueToken = "uniqueToken";
  static const String deviceToken = "";
}

final box = GetStorage();

setToken({String? deviceToken}) {
  // box.write(Preference.uniqueToken, uniqueToken);
  box.write(Preference.deviceToken, deviceToken);
}
