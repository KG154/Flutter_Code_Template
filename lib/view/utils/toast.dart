import 'package:code_template/Module/frameWork/Responsive_UI/Sizer.dart';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'colors.dart';

class MyToast {
  succesToast({Color? color, required String? toast}) {
    final Widget widget = Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Clr.successToast,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        toast ?? "Success",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );

    final ToastFuture toastFuture = showToastWidget(
      widget,
      duration: Duration(seconds: 2),
      position: ToastPosition.bottom,
      onDismiss: () {
        debugPrint('Toast has been dismissed.');
      },
    );
  }

  errorToast( {Color? color, required String? toast}) {
    final Widget widget = Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Clr.redColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        toast ?? "Error",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );

    final ToastFuture toastFuture = showToastWidget(
      widget,
      duration: Duration(seconds: 2),
      position: ToastPosition.bottom,
      onDismiss: () {
        debugPrint('Toast has been dismissed.');
      },
    );
  }

  warningToast( {Color? color, required String toast}) {
    final Widget widget = Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Clr.baseColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        toast,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );

    final ToastFuture toastFuture = showToastWidget(
      widget,
      duration: Duration(seconds: 2),
      position: ToastPosition.top,
      onDismiss: () {
        debugPrint('Toast has been dismissed.');
      },
    );
  }
}
