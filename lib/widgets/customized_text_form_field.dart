import 'package:cineluxe/utils/app_colors.dart';
import 'package:cineluxe/utils/app_sizes.dart';
import 'package:cineluxe/utils/app_styles.dart';
import 'package:flutter/material.dart';

typedef OnChanged = void Function(String value);
typedef OnValidate = String? Function(String?);

class CustomizedTextFormField extends StatelessWidget {
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final OnChanged? onChanged;
  final TextEditingController? controller;
  final OnValidate? onValidate;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String hintText;
  const CustomizedTextFormField({
    super.key,
    this.keyboardType = TextInputType.text,
    required this.textInputAction,
    this.controller,
    this.onValidate,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    var height = context.height;
    return TextFormField(
      obscuringCharacter: '*',
      textInputAction: textInputAction,
      style: AppStyles.white16W400,
      autocorrect: true,
      keyboardType: keyboardType,
      onChanged: onChanged,
      controller: controller,
      validator: onValidate,
      cursorColor: AppColors.whiteColor,
      cursorErrorColor: Colors.red,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.textFormFieldBg,
        suffixIconColor: AppColors.whiteColor,
        prefixIconColor: AppColors.whiteColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: AppStyles.white16W400,
        contentPadding: EdgeInsets.symmetric(
          horizontal: width * 0.01,
          vertical: height * 0.02,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
