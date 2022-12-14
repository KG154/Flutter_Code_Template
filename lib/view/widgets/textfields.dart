import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/View/Utils/colors.dart';
import 'package:code_template/View/Utils/strings.dart';
import 'package:code_template/View/Utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  EdgeInsetsGeometry? contentPadding;
  EdgeInsetsGeometry? padding;
  TextEditingController controller;
  bool? readOnly;
  String hintText;
  String validate;
  bool? obscureText;
  TextInputAction? textInputAction;
  TextInputType keyboardType;
  Widget? prefixIcon;
  Widget? suffixIcon;
  bool? fill;
  Color? fillColor;
  String textFieldType;
  TextStyle? hintTextStyle;
  TextStyle? inputTextStyle;
  int? extraSetup;
  Function()? fun;
  Function(String)? onChanged;
  Function(String)? onFieldSubmitted;
  void Function()? onTap;
  int? maxLines;
  String? error;
  int? maxLength;
  bool? isDense;
  bool? isCollapsed;
  InputBorder? border;
  InputBorder? focusBorder;
  InputBorder? errorBorder;
  BoxConstraints? prefixIconConstraints;
  BoxConstraints? suffixIconConstraints;
  String? Function(String?)? validator;

  MyTextField(
      {Key? key,
      this.readOnly,
      required this.controller,
      required this.hintText,
      required this.validate,
      this.obscureText,
      required this.keyboardType,
      this.textInputAction,
      this.prefixIcon,
      this.suffixIcon,
      this.extraSetup,
      this.fill,
      this.fillColor,
      required this.textFieldType,
      this.hintTextStyle,
      this.inputTextStyle,
      this.fun,
      this.onChanged,
      this.onFieldSubmitted,
      this.maxLines,
      this.error,
      this.onTap,
      this.contentPadding,
      this.padding,
      this.maxLength,
      this.isDense,
      this.border,
      this.isCollapsed,
      this.focusBorder,
      this.prefixIconConstraints,
      this.suffixIconConstraints,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(top: 3.w, left: 1.w, right: 1.w),
      child: TextFormField(
        controller: controller,
        onTap: onTap,
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        maxLines: maxLines ?? 1,
        onChanged: onChanged,
        cursorColor: Clr.blackColor,
        cursorHeight: 5.w,
        textInputAction: textInputAction ?? TextInputAction.next,
        inputFormatters: inputFormattersFun(),
        textAlign: TextAlign.left,
        readOnly: readOnly ?? false,
        style: TS.textFieldStyle,
        maxLength: maxLength,
        validator: validator,
        decoration: InputDecoration(
          isCollapsed: isCollapsed ?? false,
          errorText: error,
          fillColor: fillColor,
          filled: true,
          isDense: isDense ?? true,
          counterText: '',
          contentPadding: contentPadding,
          hintText: hintText,
          hintStyle: TS.textFieldHintStyle,
          border: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.w),
                borderSide: BorderSide(width: 1),
              ),
          enabledBorder: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.w),
                borderSide: BorderSide(width: 1),
              ),
          focusedBorder: focusBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.w),
                borderSide: BorderSide(width: 1),
              ),
          errorBorder: errorBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.w),
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          prefixIconConstraints: prefixIconConstraints,
          suffixIconConstraints: suffixIconConstraints,
        ),
      ),
    );
  }

  inputFormattersFun() {
    switch (textFieldType) {
      case Validate.nameTxt:
        return [
          LengthLimitingTextInputFormatter(35),
          NoLeadingSpaceFormatter(),
          FilteringTextInputFormatter.allow(
              RegExp("[a-z A-Z ??-?? ??-?? 0-9 .,-]")),
        ];
      case Validate.emailTxt:
        return [
          NoLeadingSpaceFormatter(),
          LowerCaseTextFormatter(),
          FilteringTextInputFormatter.deny(RegExp("[ ]")),
          FilteringTextInputFormatter.allow(RegExp("[a-z??-??0-9.,-_@]")),
          LengthLimitingTextInputFormatter(50),
        ];
      case Validate.passTxt:
        return [
          LengthLimitingTextInputFormatter(20),
          FilteringTextInputFormatter.deny(RegExp('[ ]')),
          FilteringTextInputFormatter.allow(
              RegExp("[a-zA-Z??-????-??0-9-@\$%&#*]")),
        ];

      case Validate.numberTxt:
        return [
          NoLeadingSpaceFormatter(),
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        ];
      default:
        return [
          NoLeadingSpaceFormatter(),
        ];
    }
  }
}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toLowerCase(), selection: newValue.selection);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
