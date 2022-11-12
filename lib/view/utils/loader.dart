import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/View/Utils/const.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Loader {
  static sw() {
    return navigatorKey.currentContext!.loaderOverlay.show(widget: MyLoader());
  }

  static hd() {
    return navigatorKey.currentContext!.loaderOverlay.hide();
  }
}

class MyLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(45.w),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
}
