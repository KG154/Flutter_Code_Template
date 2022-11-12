import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/view/utils/colors.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  double? width;
  double? height;
  Color? buttonClr;
  BorderRadiusGeometry? borderRadius;
  final String title;
  double? fontSize;
  final Function onClick;

  MyButton({
    Key? key,
    this.width,
    this.height,
    this.buttonClr,
    this.borderRadius,
    required this.title,
    this.fontSize,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 13.w,
      decoration: BoxDecoration(
          color: buttonClr ?? Clr.buttonClr,
          borderRadius: borderRadius ?? BorderRadius.circular(10.w)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            onClick();
          },
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  letterSpacing: 0.2.w,
                  color: Clr.whiteColor,
                  fontSize: fontSize ?? 13.sp,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

class DialogButton extends StatelessWidget {
  double? width;
  final double? height;
  final ButtonStyle? style;
  final void Function()? onPressed;
  final String? text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? textColor;
  bool? bordered = false;
  final Color? buttonColor;
  final Color? borderColor;
  final double? radius;
  final Gradient? gradient;
  final TextStyle? textStyle;

  DialogButton(
      {Key? key,
      this.width,
      this.height,
      this.style,
      required this.onPressed,
      required this.text,
      this.fontWeight,
      this.fontSize,
      this.textColor,
      this.buttonColor,
      this.bordered,
      this.borderColor,
      this.gradient,
      this.radius,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      hoverColor: Colors.transparent,
      child: Container(
        width: width,
        height: height ?? 13.5.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(radius ?? 10000.w),
            gradient: bordered == true ? null : gradient,
            border: Border.all(
                color:
                    bordered == true ? Color(0xFF4F5051) : Colors.transparent,
                width: 1)),
        child: Text(
          text.toString(),
          textAlign: TextAlign.center,
          style: textStyle ??
              TextStyle(
                  fontWeight: fontWeight ?? FontWeight.w600,
                  fontSize: fontSize ?? 14.sp,
                  color: textColor ?? Colors.white),
        ),
      ),
    );
  }
}
