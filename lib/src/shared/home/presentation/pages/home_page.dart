import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/extensions/string_extensions.dart';
import 'package:neuconnectz_dynea/src/core/services/connectivity_service.dart';
import 'package:neuconnectz_dynea/src/core/services/session_service.dart';

import '../widgets/home_welcome_card.dart';
import '../widgets/putaway_section.dart';
import '../widgets/picking_section.dart';
import '../widgets/bin_transfer_section.dart';
import '../widgets/physical_stock_check_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? _isConnected;
  StreamSubscription<(ConnectivityResult, bool)>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initConnectivityListener();
  }

  Future<void> _initConnectivityListener() async {
    final initialStatus = await ConnectivityService.instance.isConnected;
    if (mounted) {
      setState(() => _isConnected = initialStatus);
    }
    _connectivitySubscription = ConnectivityService
        .instance
        .connectionStatusStream
        .listen((event) {
          final connected = event.$1 != ConnectivityResult.none;
          if (mounted) {
            setState(() => _isConnected = connected);
          }
        });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  String get _userName =>
      SessionManager.currentUser?.name ?? AppTexts.welcomeBack;
  String get _userInitial {
    final name = SessionManager.currentUser?.name ?? AppTexts.welcomeBack;
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    return trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,
          HomeWelcomeCard(
            userName: _userName.capitalize,
            userInitial: _userInitial,
            isConnected: _isConnected,
          ),
          24.verticalSpace,
          const PutawaySection(),
          16.verticalSpace,
          const PickingSection(),
          16.verticalSpace,
          const BinTransferSection(),
          16.verticalSpace,
          const PhysicalStockCheckSection(),
        ],
      ),
    );
  }
}
