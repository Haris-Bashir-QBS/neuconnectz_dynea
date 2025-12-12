import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';

class ThemeColorDialog {
  static Future<void> show(
    BuildContext context, {
    required Color initialColor,
    required void Function(Color) onColorSelected,
  }) async {
    ColorPicker(
      color: initialColor,
      title: Text(
        AppTexts.selectTheme,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      width: 40,
      height: 40,
      spacing: 5,
      runSpacing: 10,
      enableShadesSelection: false,
      onColorChanged: (color) {
        debugPrint("Color is $color");
        onColorSelected(color);
      },
      pickersEnabled: const {
        ColorPickerType.both: false,
        ColorPickerType.custom: true,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.wheel: false,
        ColorPickerType.customSecondary: false,
      },
      borderRadius: 22,
      actionButtons: const ColorPickerActionButtons(
        okButton: true,
        closeButton: true,
        dialogActionButtons: true,
      ),
      customColorSwatchesAndNames: {
        const ColorSwatch(0xFF1B59F8, <int, Color>{
              500: Color(0xFF1B59F8),
              50: Color(0xFFBBDEFB),
              100: Color(0xFF90CAF9),
            }):
            'Blue Light',
        const ColorSwatch(0xFF880E4F, <int, Color>{
              500: Color(0xFF880E4F),
              50: Color(0xFFF8BBD0),
            }):
            'Custom Pink',
        const ColorSwatch(0xFF004D40, <int, Color>{
              500: Color(0xFF004D40),
              50: Color(0xFFB2DFDB),
            }):
            'Custom Teal',
      },
    ).showPickerDialog(
      context,
      constraints: BoxConstraints(
        maxHeight: 0.4.sh,
        minHeight: 0.4.sh,
        maxWidth: 1.sw,
        minWidth: 1.sw,
      ),
    );
  }
}


