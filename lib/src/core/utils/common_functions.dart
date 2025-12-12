import 'package:flutter/material.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/enums/scan_type.dart';
import 'package:neuconnectz_dynea/src/core/utils/utils.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_toast.dart';

class CommonFunctions {
  CommonFunctions._();

  static Future<void> handleItrBackAction({
    required BuildContext context,
    required int currentStep,
    required VoidCallback resetStep,
    required VoidCallback onPop,
  }) async {
    if (currentStep != 0) {
      resetStep();
      return;
    } else {
      onPop();
    }
  }

  static Future<void> scanBarcodeOnType({
    required BuildContext context,
    required FieldScanType scanType,
    required void Function(String) onBarcodeScanned,
    required void Function(String) onBinCodeScanned,
  }) async {
    final res = await Utils.scanBarcode(context, title: AppTexts.scan);
    final value = res?.trim();

    if (value?.isEmpty != false || value == "-1") {
      return;
    }

    switch (scanType) {
      case FieldScanType.barcode:
        onBarcodeScanned(value!);
        break;
      case FieldScanType.binCode:
        onBinCodeScanned(value!);
        break;
    }
  }
}


