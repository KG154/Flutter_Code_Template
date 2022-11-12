import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/View/Utils/colors.dart';
import 'package:flutter/material.dart';

showCustomBottomSheet(BuildContext context, {required Widget child}) {
  showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.w), topRight: Radius.circular(5.w))),
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setSta) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 1.w),
              Container(
                height: 1.w,
                width: 8.w,
                decoration: BoxDecoration(
                  color: Clr.dividerClr2,
                  borderRadius: BorderRadius.circular(100.w),
                ),
              ),
              child,
            ],
          ),
        );
      });
    },
  );
}
