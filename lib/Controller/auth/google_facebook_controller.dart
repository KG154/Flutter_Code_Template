import 'dart:developer';

import 'package:code_template/Controller/auth/sign_up_controller.dart';
import 'package:code_template/view/utils/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FGAuthControler extends GetxController {
  final auth = FirebaseAuth.instance;

  RxString providerId = "".obs;

  googleAuth() async {
    try {
      print("1");
      Loader.sw();
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();
      // fetch the auth details from the request made earlier
      print("2");
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      // Create a new credential for signing in with google
      print("3");
      Loader.hd();
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      print("4");
      Loader.sw();
      final user = await auth.signInWithCredential(credential);
      Loader.hd();
      if (user.user != null) {
        // signup data from google
        SignUpController().signUpUser(
          loginType: "google_login",
          profileImage: user.user?.photoURL,
          userEmail: user.user?.email,
          userName: user.user?.displayName ?? "",
          phoneNum: user.user?.phoneNumber ?? "",
          socialId: user.user?.uid,
        );

        print("====2");
        providerId.value = auth.currentUser!.providerData.first.providerId;

        print("====3");
      }
    } catch (e) {
      Loader.hd();
      print("ee == ${e}");
    }
  }

  //Facebook Login
  facebookAuth() async {
    print("pre");
    Loader.sw();
    final LoginResult result = await FacebookAuth.instance.login();
    Loader.hd();
    if (result.status == LoginStatus.success) {
      print("2");
      Loader.sw();
      final credential = FacebookAuthProvider.credential(result.accessToken!.token);
      final data = await FacebookAuth.instance.getUserData(fields: "name,email,picture.width(200)");
      Loader.hd();
      Loader.sw();
      final user = await auth.signInWithCredential(credential);
      print("3");
      Loader.hd();

      if (user.user != null) {
        print("4");
        log(data.toString());

        // signup data from Facebook
        SignUpController().signUpUser(
          loginType: "facebook_login",
          profileImage: data["picture"]["data"]["url"],
          userEmail: data["email"],
          userName: data["name"] ?? "",
          phoneNum: user.user?.phoneNumber ?? "",
          socialId: user.user?.uid,
        );

        print("5");
        providerId.value = auth.currentUser!.providerData.first.providerId;
      }
    } else if (result.status == LoginStatus.cancelled) {
      print('Cancel facebook login');
    } else if (result.status == LoginStatus.failed) {
      print('Failed facebook login');
    } else {
      print('${result.message.toString()}');
    }
  }

  signOut() async {
    if (providerId.value == "facebook.com") {
      log("Facebook Sign Out");
      await auth.signOut();
      await FacebookAuth.i.logOut();
    } else {
      log("Google Sign Out");
      await auth.signOut();
      await GoogleSignIn().signOut();
    }
  }
}
