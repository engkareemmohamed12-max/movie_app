import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_sizes.dart';
import '../utils/app_styles.dart';

class ReusableContainer extends StatelessWidget {
  final Widget icon;
  final String text;
  const ReusableContainer({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return  Container(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: width * 0.06,
        vertical: height * 0.007,
      ),
      decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadiusGeometry.circular(16)
      ),
      child: Row(
        spacing: width * 0.03,
        children: [
          icon,
          Text(text,style: AppStyles.grey20W700.copyWith(color: AppColors.whiteColor,fontSize: 24)),
        ],
      ),
    );
  }
}
