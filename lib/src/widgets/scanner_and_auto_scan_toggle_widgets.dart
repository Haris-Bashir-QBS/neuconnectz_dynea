import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_toggle_tile.dart';

import '../core/constants/app_texts.dart';

class ScannerAndAutoScanToggleWidget extends StatelessWidget {
  final bool isScannerConnected;
  final bool isAutoScan;
  final ValueChanged<bool> onScannerConnectedChanged;
  final ValueChanged<bool> onAutoScanChanged;

  const ScannerAndAutoScanToggleWidget({
    super.key,
    required this.isScannerConnected,
    required this.isAutoScan,
    required this.onScannerConnectedChanged,
    required this.onAutoScanChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomToggleTile(
            label: AppTexts.scanner,
            value: isScannerConnected,
            onChanged: onScannerConnectedChanged,
          ),
        ),
        15.horizontalSpace,
        Expanded(
          child: CustomToggleTile(
            label: AppTexts.autoScan,
            value: isAutoScan,
            onChanged: onAutoScanChanged,
          ),
        ),
      ],
    );
  }
}


