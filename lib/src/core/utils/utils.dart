import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/core/models/dashboard_component_model.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static const _authRoutes = [
    '/splash',
    '/login',
    '/signup',
    '/verify_otp',
    '/forgot_password',
    '/reset_password',
    '/change_password',
  ];

  static bool isAuthRoute(String location) {
    return _authRoutes.any(
      (path) => location == path || location.startsWith(path),
    );
  }

  static Future<String?> scanBarcode(
    BuildContext context, {
    String? title,
    ScanType? scanType,
  }) async {
    return await SimpleBarcodeScanner.scanBarcode(
      context,
      barcodeAppBar: BarcodeAppBar(
        centerTitle: false,
        appBarTitle: title,
        enableBackButton: true,
        backButtonIcon: Icon(Icons.arrow_back_ios, color: context.primaryColor),
      ),
      isShowFlashIcon: true,
      delayMillis: 500,
      cameraFace: CameraFace.back,
      scanType: scanType ?? ScanType.barcode,
      scanFormat: ScanFormat.ALL_FORMATS,
    );
  }

  static String convertUtcToLocalString(String? utcString) {
    if (utcString == null || utcString.isEmpty) {
      return '';
    }

    try {
      DateTime utcDateTime = DateTime.parse(utcString);
      DateTime localDateTime = utcDateTime.toLocal();

      return DateFormat('dd/MM/yy').format(localDateTime);
    } catch (e) {
      return '';
    }
  }

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<String?> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor;
      } else {
        return null; // Unsupported platform
      }
    } catch (e) {
      return "Error fetching device id";
    }
  }

  /// Save dashboard component order to SharedPreferences
  static Future<void> saveDashboardComponentOrder(List<String> order) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('dashboard_component_order', order);
  }

  /// Load dashboard component order from SharedPreferences
  static Future<List<String>?> loadDashboardComponentOrder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('dashboard_component_order');
  }

  /// Widget for remove component button (for HomePage edit mode)
  static Widget removeComponentWidget({
    required DashboardComponent component,
    required VoidCallback onRemove,
  }) {
    return Positioned(
      top: 8.h,
      right: 14.w,
      child: GestureDetector(
        onTap: onRemove,
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.red.withAlpha(204),
            shape: BoxShape.circle,
          ),
          child: CustomText(text: '-', fontSize: 22.sp, color: Colors.white),
        ),
      ),
    );
  }
}


