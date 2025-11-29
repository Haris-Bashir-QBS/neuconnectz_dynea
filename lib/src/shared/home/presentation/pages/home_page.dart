import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
import 'package:neuconnectz_dynea/src/core/services/connectivity_service.dart';
import 'package:neuconnectz_dynea/src/core/services/session_service.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

import '../../../../core/router/app_routes.dart';
import '../../../selection/params/document_selection_params.dart';

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
          const PhysicalStockCheckSection(),
        ],
      ),
    );
  }
}

class HomeWelcomeCard extends StatelessWidget {
  const HomeWelcomeCard({
    super.key,
    required this.userName,
    required this.userInitial,
    required this.isConnected,
  });

  final String userName;
  final String userInitial;
  final bool? isConnected;

  @override
  Widget build(BuildContext context) {
    final connectionStatus = isConnected;
    final isOnline = connectionStatus ?? false;
    final statusText =
        connectionStatus == null
            ? AppTexts.checkingConnection
            : isOnline
            ? AppTexts.connected
            : AppTexts.disconnected;
    final statusColor =
        connectionStatus == null
            ? AppPalette.yellowColor
            : isOnline
            ? AppPalette.lightGreenColor
            : Colors.redAccent;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppPalette.lightGreyColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: CustomText(
              text: userInitial,
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppPalette.darkGreyColor,
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: AppTexts.welcome,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.darkGreyColor,
                ),
                2.verticalSpace,
                CustomText(
                  text: userName,
                  fontSize: 16.sp,
                  color: AppPalette.greyColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          6.horizontalSpace,
          CustomText(text: statusText, fontSize: 12.sp, color: statusColor),
        ],
      ),
    );
  }
}

class PutawaySection extends StatelessWidget {
  const PutawaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: AppTexts.putAway,
      actions: [
        HomeActionCardData(
          title: AppTexts.goodReceiptNote,
          iconBackgroundColor: AppPalette.d4Color,
          iconColor: AppPalette.lightGreenColor,
          onTap: () {
            context.pushNamed(
              AppRoutes.documentSelection,
              extra: DocumentSelectionConfigs.grn(),
            );
          },
        ),
        HomeActionCardData(
          title: AppTexts.inboundDelivery,
          iconBackgroundColor: AppPalette.d3Color,
          iconColor: AppPalette.yellowColor,
          iconPath: AppAssets.pendingIcon,
        ),
      ],
    );
  }
}

class PickingSection extends StatelessWidget {
  const PickingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: AppTexts.picking,
      actions: [
        HomeActionCardData(
          title: AppTexts.reservation,
          iconBackgroundColor: AppPalette.d5Color,
          iconColor: AppPalette.primaryColor,
          onTap: () {
            context.pushNamed(
              AppRoutes.documentSelection,
              extra: DocumentSelectionConfigs.reservation(),
            );
          },
        ),
        HomeActionCardData(
          title: AppTexts.outboundDeliverySto,
          iconBackgroundColor: AppPalette.d8Color,
          iconColor: Color(0xFF8E5BF7),
          iconPath: AppAssets.pendingIcon,
          onTap: () {
            context.pushNamed(
              AppRoutes.documentSelection,
              extra: DocumentSelectionConfigs.outboundDeliverySto(),
            );
          },
        ),
        HomeActionCardData(
          title: AppTexts.outboundDeliverySales,
          iconBackgroundColor: AppPalette.d9Color,
          iconColor: Color(0xFFFF8A65),
          iconPath: AppAssets.grnAddTwoIcon,
          spanFullWidth: true,
        ),
      ],
    );
  }
}

class PhysicalStockCheckSection extends StatelessWidget {
  const PhysicalStockCheckSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: AppTexts.physicalStockCheck,
      actions: [
        HomeActionCardData(
          title: AppTexts.checkStock,
          iconBackgroundColor: AppPalette.d2Color,
          iconColor: Color(0xFF5C6BC0),
          iconPath: AppAssets.stockCheckIcon,
          spanFullWidth: true,
          onTap: () {
            context.pushNamed(
              AppRoutes.documentSelection,
              extra: DocumentSelectionConfigs.stockCheck(),
            );
          },
        ),
      ],
    );
  }
}

class HomeSection extends StatelessWidget {
  const HomeSection({super.key, required this.title, required this.actions});

  final String title;
  final List<HomeActionCardData> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppPalette.darkBlueColor,
          ),
          12.verticalSpace,
          LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 12.w;
              final halfWidth = (constraints.maxWidth - spacing) / 2;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children:
                    actions.map((action) {
                      final itemWidth =
                          action.spanFullWidth
                              ? constraints.maxWidth
                              : halfWidth;
                      return SizedBox(
                        width: itemWidth,
                        child: HomeActionCard(data: action),
                      );
                    }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HomeActionCardData {
  final String title;
  final String iconPath;
  final bool spanFullWidth;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;

  const HomeActionCardData({
    required this.title,
    this.iconPath = AppAssets.purchaseOrderIcon,
    this.spanFullWidth = false,
    this.onTap,
    this.backgroundColor,
    this.iconBackgroundColor,
    this.iconColor,
  });
}

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({super.key, required this.data});

  final HomeActionCardData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: data.backgroundColor ?? AppPalette.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16.r),
            // border: Border.all(color: AppPalette.lightGreyColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: data.iconBackgroundColor ?? AppPalette.primaryColor,
                  // borderRadius: BorderRadius.circular(16.r),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Image.asset(
                    data.iconPath,
                    width: 20.w,
                    height: 20.w,
                    // color: data.iconColor,
                    color: Colors.white,
                  ),
                ),
              ),
              10.verticalSpace,
              CustomText(
                text: data.title,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
