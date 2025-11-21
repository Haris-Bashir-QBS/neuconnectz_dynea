// import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/observers/navigator_observer.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/core/services/session_service.dart';
import 'package:neuconnectz_dynea/src/core/utils/utils.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/params/verify_code_params.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/pages/change_password.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/pages/forget_password_page.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/pages/login_page.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/pages/reset_password.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/pages/splash_page.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/pages/warehouse_and_plant_selection_page.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/pages/dashboard_page.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/pages/grn_items_page.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/pages/settings_page.dart';
import 'package:neuconnectz_dynea/src/widgets/connectivity_overlay.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/${AppRoutes.splash}',
  navigatorKey: SessionManager.navigatorKey,
  observers: [
    //ChuckerFlutter.navigatorObserver,
    UnFocusOnNavigateObserver(),
  ],
  routes: [
    /// ====================== Auth Routes ======================
    ...authRoutes,
    ...putAwayRoutes,

    /// ====================== Core Routes ======================
    ShellRoute(
      builder: (context, GoRouterState state, child) {
        if (Utils.isAuthRoute(state.matchedLocation)) {
          return child;
        }
        return ConnectivityOverlay(child: child);
      },
      routes: [_dashboard()],
    ),
  ],
);

List<GoRoute> authRoutes = [
  _splash(),
  _login(),
  _verifyOtp(),
  _forgotPassword(),
  _resetPassword(),
  _changePassword(),
  _settings(),
];

GoRoute _settings() {
  return GoRoute(
    path: '/${AppRoutes.settings}',
    name: AppRoutes.settings,
    builder: (context, state) => SettingsPage(),
  );
}

GoRoute _dashboard() {
  return GoRoute(
    path: '/${AppRoutes.dashboard}',
    name: AppRoutes.dashboard,
    builder: (context, state) => DashboardPage(),
  );
}

GoRoute _login() {
  return GoRoute(
    path: '/${AppRoutes.login}',
    name: AppRoutes.login,
    builder: (context, state) => LoginPage(),
  );
}

GoRoute _splash() {
  return GoRoute(
    path: '/${AppRoutes.splash}',
    name: AppRoutes.splash,
    builder: (context, state) => SplashPage(),
  );
}

GoRoute _changePassword() {
  return GoRoute(
    path: '/${AppRoutes.changePassword}',
    name: AppRoutes.changePassword,
    builder: (context, state) => ChangePasswordPage(),
  );
}

GoRoute _resetPassword() {
  return GoRoute(
    path: '/${AppRoutes.resetPassword}',
    name: AppRoutes.resetPassword,
    builder:
        (context, state) => ResetPasswordPage(email: state.extra as String?),
  );
}

GoRoute _forgotPassword() {
  return GoRoute(
    path: '/${AppRoutes.forgotPassword}',
    name: AppRoutes.forgotPassword,
    builder: (context, state) => ForgetPasswordPage(),
  );
}

GoRoute _verifyOtp() {
  return GoRoute(
    path: '/${AppRoutes.verifyOtp}',
    name: AppRoutes.verifyOtp,
    builder: (context, state) {
      final params = state.extra as VerifyCodeParams;
      return VerifyOtpPage(
        email: params.email ?? '',
        verificationType: params.type,
        user: params.user,
      );
    },
  );
}

GoRoute _putAwayFromGr() {
  return GoRoute(
    path: '/${AppRoutes.warehouseAndPlantSelection}',
    name: AppRoutes.warehouseAndPlantSelection,
    builder: (context, state) => WarehouseAndPlantSelectionPage(),
  );
}

GoRoute _grnItems() {
  return GoRoute(
    path: '/${AppRoutes.grnItems}',
    name: AppRoutes.grnItems,
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>? ?? {};
      final grnItem = args['grnItem'] as GrnEntity?;
      return GrnItemsPage(
        grn: grnItem!,
        plant: args['plant'] as String? ?? '',
        location: args['location'] as String? ?? '',
        warehouseCode: args['warehouseCode'] as String? ?? '',
      );
    },
  );
}

List<GoRoute> putAwayRoutes = [_putAwayFromGr(), _grnItems()];
