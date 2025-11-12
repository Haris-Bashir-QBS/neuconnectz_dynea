import 'package:flutter/material.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_fonts.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';

class FontStyleDialog extends StatefulWidget {
  final String initialFont;
  final void Function(String) onFontSelected;

  const FontStyleDialog({
    super.key,
    required this.initialFont,
    required this.onFontSelected,
  });

  @override
  State<FontStyleDialog> createState() => _FontStyleDialogState();

  /// 🔥 Static method to show the dialog
  static Future<void> show(
    BuildContext context, {
    required String initialFont,
    required void Function(String) onFontSelected,
  }) {
    return showDialog(
      context: context,
      builder:
          (_) => FontStyleDialog(
            initialFont: initialFont,
            onFontSelected: onFontSelected,
          ),
    );
  }
}

class _FontStyleDialogState extends State<FontStyleDialog> {
  late String selectedFont;

  @override
  void initState() {
    super.initState();
    selectedFont = widget.initialFont;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppTexts.selectFontStyle),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children:
              AppFonts.fontFamilies.map((font) {
                return RadioListTile<String>(
                  title: Text(font, style: TextStyle(fontFamily: font)),
                  value: font,
                  groupValue: selectedFont,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedFont = value);
                    }
                  },
                );
              }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppTexts.cancel),
        ),
        TextButton(
          onPressed: () {
            widget.onFontSelected(selectedFont);
            Navigator.pop(context);
          },
          child: Text(AppTexts.save),
        ),
      ],
    );
  }
}
