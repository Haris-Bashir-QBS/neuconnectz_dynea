import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import '../core/constants/app_palette.dart' show AppPalette;
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double? height;
  final VoidCallback onPressed;
  final bool? isBorder;
  final Color? textColor, iconColor, borderColor;
  final bool isLoading;
  final Color? color;
  final double? fontSize;
  final double? radius;
  final bool? isKeyboardDismissOnClick;
  final Gradient? gradient;
  final IconData? icon;
  final Widget? iconWidget;
  final IconData? trailingIcon;
  final Widget? trailingIconWidget;

  const CustomButton({
    super.key,
    required this.text,
    this.height,
    this.iconColor,
    required this.onPressed,
    this.isBorder = false,
    this.borderColor,
    this.radius,
    this.fontSize,
    this.isLoading = false,
    this.color,
    this.gradient,
    this.isKeyboardDismissOnClick = true,
    this.icon,
    this.iconWidget,
    this.trailingIcon,
    this.trailingIconWidget,
    this.textColor,
  });

  /// Named constructor for a white background with primary color border and text
  const CustomButton.bordered({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.icon,
    this.iconWidget,
    this.trailingIcon,
    this.trailingIconWidget,
    this.isLoading = false,
    this.radius,
    this.iconColor,
    this.isKeyboardDismissOnClick = true,
    this.fontSize,
  }) : isBorder = true,
       borderColor = null,
       color = Colors.white,
       textColor = null,
       gradient = null;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor =
        textColor ??
        (color == Colors.white ? context.primaryColor : Colors.white);
    final effectiveBorderColor =
        borderColor ?? (isBorder! ? context.primaryColor : Colors.transparent);

    return SizedBox(
      width: 1.sw,
      height: height ?? 50.h,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 8),
          border:
              isBorder!
                  ? Border.all(color: effectiveBorderColor, width: 1.5)
                  : null,
          color:
              isLoading ? AppPalette.hintColor : color ?? context.primaryColor,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius ?? 8),
            splashColor: AppPalette.primaryColor.withAlpha(50),
            splashFactory: InkRipple.splashFactory,
            onTap: () {
              if (isKeyboardDismissOnClick!) {
                context.unfocusFocusScope();
              }
              if (!isLoading) {
                onPressed();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  Transform.scale(
                    scale: 0.7,
                    child: const CircularProgressIndicator(color: Colors.white),
                  )
                else ...[
                  if (icon != null || iconWidget != null) ...[
                    iconWidget ??
                        Icon(
                          icon,
                          color: iconColor ?? effectiveTextColor,
                          size: 26.sp,
                        ),
                    10.horizontalSpace,
                  ],
                  _titleWidget(effectiveTextColor),
                  if (trailingIcon != null || trailingIconWidget != null) ...[
                    10.horizontalSpace,
                    trailingIconWidget ??
                        Icon(
                          trailingIcon,
                          color: iconColor ?? effectiveTextColor,
                          size: 26.sp,
                        ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleWidget(Color effectiveTextColor) {
    return Align(
      alignment: Alignment.center,
      child:
          isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : CustomText(
                text: text,
                fontSize: fontSize ?? 16.sp,
                fontWeight: FontWeight.w500,
                color: effectiveTextColor,
                textAlign: TextAlign.center,
              ),
    );
  }
}


