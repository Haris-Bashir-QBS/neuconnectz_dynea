import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_errors.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/core/services/http_inspector_service.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_circular_progress_indicator.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_toast.dart';
import 'package:neuconnectz_dynea/src/widgets/modal_progress_hud.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:neuconnectz_dynea/src/core/services/session_service.dart';
import 'package:neuconnectz_dynea/src/core/theme/cubits/theme_cubit.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/two_fa_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/get_secret_key_response_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/blocs/auth_event.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/blocs/auth_state.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/widgets/manual_app_version_text.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/widgets/select_font_dialog.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/widgets/select_theme_dialog.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/widgets/two_fa_toggle_widget.dart';

import '../../../core/constants/app_palette.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/router/app_routes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeCubit _themeCubit;
  GetSecretKeyResponseModel? _secretKeyResponse;
  bool isEnabled = false;
  String _appVersion = '';
  // bool showChuckerNotification = ChuckerFlutter.showNotification;

  @override
  void initState() {
    _themeCubit = context.read<ThemeCubit>();

    debugPrint("User is ${SessionManager.currentUser}");
    debugPrint("User isToTp is ${SessionManager.currentUser?.isTotp}");

    isEnabled = SessionManager.isTotp ?? false;
    if (!isEnabled) {
      _fetchSecretKeyEvent();
    }
    _getAppVersion();

    super.initState();
  }

  Future<void> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
      });
    } catch (e) {
      debugPrint("Error fetching app version: $e");
      setState(() {
        _appVersion = 'Unknown Version';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeCubit = context.watch<ThemeCubit>();

    return Scaffold(
      appBar: CustomAppBar(
        title: AppTexts.settings,
        actions: [
          ManualAppVersionWidget(versionLabel: 'Version $_appVersion'),
          5.horizontalSpace,
        ],
      ),
      body: BlocConsumer<AuthenticationBloc, AuthState>(
        listener: _listener,
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall:
                state is AuthAdd2FALoading || state is AuthRemove2FALoading,
            opacity: 0,
            progressIndicator:
                (state is AuthAdd2FALoading || state is AuthRemove2FALoading)
                    ? CustomCircularProgressIndicator(
                      color: AppPalette.darkBlueColor,
                    )
                    : SizedBox(),

            child: RefreshIndicator(
              onRefresh: () async {
                _fetchSecretKeyEvent();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    spacing: 10.h,
                    children: [
                      _changeTheme(context),
                      _changeFontStyle(context),
                      _changePassword(context),
                      _checkNetworkLogs(context),
                      //_chuckerNotificationToggle(),
                      _twoFactorAuthenticationWidget(state),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _listener(context, state) {
    if (state is AuthGetSecretKeyFailure) {
      CustomToast.error(context, state.message);
    } else if (state is AuthGetSecretKeySuccess) {
      _secretKeyResponse = state.response;
    }
    if (state is AuthAdd2FASuccess) {
      CustomToast.success(context, state.response.message);
      SessionManager.updateTotpStatus(
        secretKey: _secretKeyResponse?.data ?? "",
        isTotpEnabled: true,
      );
      isEnabled = true;
    } else if (state is AuthAdd2FAFailure) {
      CustomToast.error(context, state.message);
    }
    if (state is AuthRemove2FASuccess) {
      CustomToast.success(context, state.response.message);
      SessionManager.updateTotpStatus(secretKey: "", isTotpEnabled: true);
      isEnabled = false;
      _fetchSecretKeyEvent();
    } else if (state is AuthRemove2FAFailure) {
      CustomToast.error(context, state.message);
    }
  }

  Widget _twoFactorAuthenticationWidget(AuthState state) {
    return TwoFactorAuthenticationWidget(
      is2FAEnabled: isEnabled,
      loading: state is AuthGetSecretKeyLoading,
      secretKey:
          isEnabled
              ? SessionManager.currentUser?.secretKey
              : _secretKeyResponse?.data ?? '',
      onCopyKey: copyKeyToClipBoard,
      onToggle2FA: (value) {
        debugPrint("Value is $value");
        if (value == true) {
          _add2FAEvent();
        } else {
          _remove2FAEvent();
        }
      },
      onTapRegenerate: () {
        _fetchSecretKeyEvent();
      },
    );
  }

  Widget _changeTheme(BuildContext context) {
    return CustomButton(
      onPressed: () => _showThemeDialog(context),
      radius: 5,
      text: AppTexts.changeTheme,
    );
  }

  Widget _checkNetworkLogs(BuildContext context) {
    return CustomButton(
      radius: 5,
      text: AppTexts.checkNetworkLogs,
      onPressed: () {
        HttpInspectorService().alice.showInspector();
      },
    );
  }

  Widget _changeFontStyle(BuildContext context) {
    return CustomButton(
      onPressed: () {
        //     _showFontStyleDialog(context);
        // context.pushNamed(AppRoutes.productionOrderStockManagement);
      },
      radius: 5,
      text: AppTexts.changeFont,
    );
  }

  Widget _changePassword(BuildContext context) {
    return CustomButton(
      onPressed: () {
        context.pushNamed(AppRoutes.changePassword);
      },
      radius: 5,
      text: AppTexts.changePassword,
    );
  }

  /// ================== Functions ==================

  void _showThemeDialog(BuildContext context) {
    ThemeColorDialog.show(
      context,
      initialColor: context.primaryColor,
      onColorSelected: _themeCubit.changeTheme,
    );
  }

  void _showFontStyleDialog(BuildContext context) {
    FontStyleDialog.show(
      context,
      initialFont: _themeCubit.fontFamily,
      onFontSelected: _themeCubit.changeFontFamily,
    );
  }

  /// ================== Events ==================

  void _fetchSecretKeyEvent() {
    context.read<AuthenticationBloc>().add(
      Get2FASecretKeyEvent(params: NoParams()),
    );
  }

  void _add2FAEvent() {
    if (_secretKeyResponse?.data != null) {
      context.read<AuthenticationBloc>().add(
        Add2FAEvent(
          params: TwoFactorAuthenticationRequestModel(
            userId: SessionManager.userId ?? '',
            secretKey: _secretKeyResponse?.data ?? '',
            isTotp: true,
          ),
        ),
      );
    } else {
      CustomToast.error(context, AppErrors.noSecretKeyFound);
    }
  }

  void _remove2FAEvent() {
    context.read<AuthenticationBloc>().add(
      Remove2FAEvent(
        params: TwoFactorAuthenticationRequestModel(
          userId: SessionManager.userId ?? '',
        ),
      ),
    );
  }

  void copyKeyToClipBoard() {
    Clipboard.setData(ClipboardData(text: _secretKeyResponse?.data ?? ''));
    CustomToast.success(context, AppTexts.copiedToClipboard);
  }

  // Widget _chuckerNotificationToggle() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: context.primaryColor,
  //       borderRadius: BorderRadius.circular(5),
  //     ),
  //     child: Transform.scale(
  //       scale: 0.9,
  //       child: SwitchListTile(
  //         title: CustomText(
  //           text: "Show Network Logs Notification",
  //           fontWeight: FontWeight.w600,
  //           color: Colors.white,
  //         ),
  //         value: showChuckerNotification,
  //         onChanged: (value) {
  //           setState(() {
  //             showChuckerNotification = value;
  //             //ChuckerFlutter.showNotification = value;
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    super.dispose();
  }
}
