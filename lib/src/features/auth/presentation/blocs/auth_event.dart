import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/change_password_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/forget_password_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/login_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/reset_password_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/two_fa_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/user_model.dart';

abstract class AuthEvent {}

/// ============================= Auth =============================
final class AuthLoginEvent extends AuthEvent {
  final LoginRequestModel params;

  AuthLoginEvent({required this.params});
}

final class AuthLogoutEvent extends AuthEvent {}

final class AuthSignupEvent extends AuthEvent {
  final SignupRequestModel params;

  AuthSignupEvent({required this.params});
}

final class ChangePasswordEvent extends AuthEvent {
  final ChangePasswordRequestModel params;

  ChangePasswordEvent({required this.params});
}

/// ============================= 2FA =============================

final class Get2FASecretKeyEvent extends AuthEvent {
  final NoParams params;

  Get2FASecretKeyEvent({required this.params});
}

final class Add2FAEvent extends AuthEvent {
  final TwoFactorAuthenticationRequestModel params;

  Add2FAEvent({required this.params});
}

final class Remove2FAEvent extends AuthEvent {
  final TwoFactorAuthenticationRequestModel params;

  Remove2FAEvent({required this.params});
}

/// Otp

final class VerifyOtpEvent extends AuthEvent {
  final TwoFactorAuthenticationRequestModel params;
  final UserModel? user;

  VerifyOtpEvent({this.user, required this.params});
}

// Forget Password Events
class ForgetPasswordRequestedEvent extends AuthEvent {
  final ForgetPasswordRequestModel params;

  ForgetPasswordRequestedEvent(this.params);
}

class VerifyOtpForForgetPasswordEvent extends AuthEvent {
  final String otp;
  final String email;

  VerifyOtpForForgetPasswordEvent({required this.otp, required this.email});
}

class ResetPasswordRequestedEvent extends AuthEvent {
  final ResetPasswordRequestModel params;

  ResetPasswordRequestedEvent(this.params);
}


