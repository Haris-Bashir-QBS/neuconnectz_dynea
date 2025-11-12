import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AppPinTheme {
  static PinTheme getTheme(BuildContext context, {double boxSize = 50}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return PinTheme(
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.circular(8),
      fieldHeight: boxSize,
      fieldWidth: boxSize,
      activeFillColor: Colors.white,
      // isDark ? AppPalette.lightGreyColor : AppPalette.lightGreyColor,
      inactiveFillColor: Colors.white,
      //    isDark ? AppPalette.lightGreyColor : AppPalette.lightGreyColor,
      selectedFillColor: Colors.white,
      //isDark ? AppPalette.lightGreyColor : AppPalette.lightGreyColor,
      activeColor: primaryColor,
      inactiveColor: isDark ? Colors.grey[600] : Colors.grey[400],
      selectedColor: primaryColor,
      errorBorderColor: Colors.red,
      borderWidth: 1.5,
      fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
