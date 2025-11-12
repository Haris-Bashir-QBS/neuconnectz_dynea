import 'package:flutter/material.dart';

import '../../../core/constants/app_palette.dart';

class ManualAppVersionWidget extends StatelessWidget {
  final String versionLabel;

  const ManualAppVersionWidget({super.key, required this.versionLabel});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppPalette.darkBlueColor.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          versionLabel,
          style: const TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
