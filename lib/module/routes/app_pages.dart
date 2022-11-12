import 'package:code_template/Module/binding/main_binding.dart';
import 'package:code_template/View/Screens/auth/login_screen.dart';
import 'package:code_template/View/Screens/auth/reset_password_screen.dart';
import 'package:code_template/View/Screens/auth/splash_screen.dart';
import 'package:code_template/view/screens/home/change_password_screen.dart';
import 'package:code_template/view/screens/home/image_view_screen.dart';
import 'package:code_template/view/screens/home/profile_screen.dart';
import 'package:code_template/view/screens/home/setting_screen.dart';
import 'package:code_template/view/screens/home/userlist_screen.dart';
import 'package:get/get.dart';

import '../../view/screens/auth/sign_up_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.Splash;

  static final routes = [
    GetPage(
      name: Routes.Splash,
      page: () => SplashScreen(),
      binding: MainBinding(),
      children: [
        GetPage(name: Routes.Login, page: () => LoginScreen()),
        GetPage(name: Routes.SignUp, page: () => SignUpScreen()),
        GetPage(name: Routes.Reset, page: () => ResetPassScreen()),
        GetPage(name: Routes.ChangePass, page: () => ChangePassScreen()),
        GetPage(name: Routes.ImageView, page: () => ImageViewScreen()),
        GetPage(name: Routes.SettingScreen, page: () => SettingScreen()),
        GetPage(name: Routes.Profile, page: () => ProfileScreen()),
        GetPage(name: Routes.UserList, page: () => UserListScreen()),
      ],
    ),
  ];
}
