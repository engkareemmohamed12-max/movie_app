import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_sizes.dart';

class ChooseLocale extends StatelessWidget {
  final VoidCallback onTap1; //english tap
  final VoidCallback onTap2; //arabic tap
  const ChooseLocale({super.key, required this.onTap1, required this.onTap2});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return Column(
      children: [
        SizedBox(height: height * 0.04),
        Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: AppColors.yellowColor),
            ),
            child: Row(
              spacing: width * 0.04,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onTap1,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.locale.languageCode == 'en'
                            ? AppColors.yellowColor
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(child: Image.asset(AppAssets.americanFlag)),
                  ),
                ),
                InkWell(
                  onTap: onTap2,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.locale.languageCode == 'ar'
                            ? AppColors.yellowColor
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(child: Image.asset(AppAssets.egyptianFlag)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
