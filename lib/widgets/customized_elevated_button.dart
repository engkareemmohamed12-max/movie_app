import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cineluxe/utils/app_colors.dart';
import 'package:cineluxe/utils/app_sizes.dart';

class CustomizedElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final bool isOutlined;
  final bool isLoading;
  final double paddingWidth;
  final double paddingHeight;

  const CustomizedElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.isOutlined = false,
    this.isLoading = false,
    this.paddingWidth = 0.04,
    this.paddingHeight = 0.014,
  });

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          isOutlined
              ? Colors.transparent
              : (backgroundColor ?? AppColors.yellowColor),
        ),
        elevation: WidgetStateProperty.all(0),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: width * paddingWidth,
            vertical: height * paddingHeight,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: isOutlined
                ? const BorderSide(
              color: AppColors.yellowColor,
              width: 1.5,
            )
                : BorderSide.none,
          ),
        ),
      ),

      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? LoadingAnimationWidget.staggeredDotsWave(
            key: const ValueKey("loading"),
            color: AppColors.yellowColor,
            size: 20,
          )
              : DefaultTextStyle(
            key: const ValueKey("child"),
            style: const TextStyle(),
            child: child,
          ),
        ),
      ),
    );
  }
}
