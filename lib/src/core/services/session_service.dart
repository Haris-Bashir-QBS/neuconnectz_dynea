import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_errors.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/core/services/app_preferences.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/user_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/domain/entities/user_entity.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/cubits/user_cubit.dart';

class SessionManager {
  SessionManager._();
  static String? get userId =>
      navigatorKey.currentContext?.read<UserCubit>().currentUser?.userId;
  static bool? get isTotp =>
      navigatorKey.currentContext?.read<UserCubit>().currentUser?.isTotp;

  static UserEntity? get currentUser =>
      navigatorKey.currentContext?.read<UserCubit>().currentUser;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> showSessionExpiredDialog() async {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    await _clearData();
    await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder:
          (context) => PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text(AppErrors.sessionExpired),
              content: Text(AppErrors.pleaseLoginAgain),
              actions: [
                TextButton(
                  onPressed: () {
                    context.goNamed(AppRoutes.login);
                    // logoutUser();
                  },
                  child: Text(AppTexts.backToLogin),
                ),
              ],
            ),
          ),
    );
  }

  static Future<void> logoutUser({required VoidCallback onSuccess}) async {
    await _clearData();
    onSuccess.call();
  }

  static Future<void> updateTotpStatus({
    required String secretKey,
    required bool isTotpEnabled,
  }) async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final userCubit = context.read<UserCubit>();
    final UserEntity? currentUser = userCubit.currentUser;

    if (currentUser == null) return;

    // Create updated user
    final updatedUser = currentUser.copyWith(
      secretKey: secretKey,
      isTotp: isTotpEnabled,
    );

    userCubit.setUser(updatedUser);
    await AppPreferences().saveUser(UserModel.fromEntity(updatedUser));
  }

  static Future<void> _clearData() async {
    await AppPreferences().clearAll();
  }
}
