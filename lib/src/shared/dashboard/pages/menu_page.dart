import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/core/services/session_service.dart';
import 'package:neuconnectz_dynea/src/core/utils/app_static_data.dart';
import 'package:neuconnectz_dynea/src/features/auth/domain/entities/user_entity.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/cubits/user_cubit.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/status_dialog.dart';
import '../widgets/expandable_list_tile.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  UserEntity? user;

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        24.verticalSpace,
        //ManualAppVersionWidget(versionLabel: "Version 5"),
        // _sectionHeading(AppTexts.profile),
        // 10.verticalSpace,
        //  _userTile(),
        //  16.verticalSpace,
        _sectionHeading(AppTexts.modules),
        10.verticalSpace,
        ...AppStaticData.moduleItems.map((module) => _moduleTile(module)),
        4.verticalSpace,
        _sectionHeading(AppTexts.settingsAndConfiguration),
        10.verticalSpace,
        _settingsTile(),
        32.verticalSpace,
        _logoutButton(),
        150.verticalSpace,
      ],
    );
  }

  Widget _sectionHeading(String title) {
    return CustomText(
      text: title,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppPalette.darkGreyColor,
    );
  }

  Widget _userTile() {
    return ExpandableListTile(
      key: GlobalKey(),
      title: user?.name ?? "",
      items: const [],
      trailingIcon: null,
      showTrailing: false,
      //trailingIcon: Icon(Icons.edit, color: AppPalette.darkGreyColor, size: 20),
      shouldNavigateDirectly: true,
      onDirectTap: () {},
      leading: CircleAvatar(
        backgroundColor: AppPalette.scaffoldBackgroundColor,
        child: Image.asset(
          AppAssets.userPlaceHolder,
          width: 30.w,
          height: 30.w,
        ),
      ),
      // CustomProfileImageWidget.smallAvatar(
      //   imagePath: '',
      //   placeHolderImage: AppAssets.userPlaceHolder,
      // ),
    );
  }

  Widget _moduleTile(ModuleItem module) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: ExpandableListTile(
        title: module.title,
        shouldNavigateDirectly: module.onTap != null,
        items: module.subItems,
        leading: _circleIcon(module.iconPath),
        onDirectTap: () {
          if (module.onTap != null) {
            module.onTap!(context);
          }
        },
        onItemTap:
            module.onItemTap != null
                ? (item) => module.onItemTap!(context, item)
                : null,
        onSubItemTap: (subItem) {
          for (var subModule in module.subItems) {
            if (subModule.subSubItems.any(
              (subSubItem) => subSubItem.title == subItem,
            )) {
              subModule.onSubItemTap?.call(context, subItem);
              break;
            }
          }
        },
      ),
    );
  }

  Widget _settingsTile() {
    return ExpandableListTile(
      title: AppTexts.settings,
      showTrailing: false,
      shouldNavigateDirectly: true,
      trailingIcon: null,
      onDirectTap: () => context.pushNamed(AppRoutes.settings),
      leading: _circleIcon(AppAssets.menuSettingsIcon),
    );
  }

  Widget _logoutButton() {
    return CustomButton(
      text: AppTexts.logout,
      textColor: AppPalette.darkGreyColor,
      color: AppPalette.lightGreyColor,
      icon: Icons.logout_outlined,
      iconColor: AppPalette.darkGreyColor,
      onPressed: () {
        _logoutDialog();
      },
    );
  }

  Future<void> _logoutDialog() async {
    await AnimatedStatusDialog.show(
      context: context,
      isSuccess: false,
      title: AppTexts.areYouSure,
      message: AppTexts.doYouWantToLogout,
      secondaryButtonText: AppTexts.no,
      primaryButtonText: AppTexts.yes,
      onPrimaryTap: () {
        SessionManager.logoutUser(
          onSuccess: () {
            context.goNamed(AppRoutes.login);
          },
        );
      },
    );
  }

  Widget _circleIcon(String icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.lightGreyColor,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(11),
      child: Image.asset(icon, width: 24.w, height: 24.w),
    );
  }
}
