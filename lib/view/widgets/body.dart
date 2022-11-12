import 'package:code_template/View/Utils/colors.dart';
import 'package:flutter/material.dart';

class MySafeArea extends StatelessWidget {
  Widget child;

  MySafeArea({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Clr.whiteColor,
      ),
      child: child,
    );
  }
}
