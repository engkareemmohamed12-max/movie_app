import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AppDialogs {
  static void showMessageDialog({
    required BuildContext context,
    required String message,
    required String text,
    String buttonText = "OK",
    VoidCallback? onPressed,
  }) {
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: size.width * 0.8,
            padding: EdgeInsets.all(size.width * 0.05),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.yellowColor.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.yellowColor,
                  size: size.width * 0.15,
                ),

                SizedBox(height: size.height * 0.02),

                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: size.height * 0.015),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: size.width * 0.035,
                  ),
                ),

                SizedBox(height: size.height * 0.025),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellowColor,
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // always close dialog
                      if (onPressed != null) {
                        onPressed();
                      }
                    },
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                        color: AppColors.bgColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}