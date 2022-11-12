import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/View/Utils/colors.dart';
import 'package:flutter/cupertino.dart';

class TS {
  static TextStyle appBar = TextStyle(
      color: Clr.blackColor, fontWeight: FontWeight.w600, fontSize: 16.sp);

  static TextStyle bodyText1 = TextStyle(
      color: Clr.blackColor, fontSize: 11.sp, fontWeight: FontWeight.w500);
  static TextStyle bodyText1baseC =
      TextStyle(color: Clr.baseColor, fontSize: 11.sp);
  static TextStyle titleText1 = TextStyle(
      color: Clr.blackColor, fontWeight: FontWeight.bold, fontSize: 25.sp);
  static TextStyle textFieldHintStyle = TextStyle(color: Clr.greyColor);
  static TextStyle textFieldStyle = TextStyle(color: Clr.blackColor);
  static TextStyle textFieldErrorStyle = TextStyle(color: Clr.redColor);

  static bodyText1ColorB(
    Color clr,
  ) {
    return TextStyle(color: clr, fontSize: 11.sp, fontWeight: FontWeight.w500);
  }
}
