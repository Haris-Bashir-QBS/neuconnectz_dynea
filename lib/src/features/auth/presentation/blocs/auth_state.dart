import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/change_password_response_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/get_secret_key_response_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/otp_verification_status.dart';
import 'package:neuconnectz_dynea/src/features/auth/domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;

  AuthSuccess({required this.user});
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

class AuthLogout extends AuthState {}

/// =============================== 2FA  ===============================
final class AuthGetSecretKeyLoading extends AuthState {
  AuthGetSecretKeyLoading();
}

final class AuthGetSecretKeyFailure extends AuthState {
  final String message;
  AuthGetSecretKeyFailure(this.message);
}

final class AuthGetSecretKeySuccess extends AuthState {
  final GetSecretKeyResponseModel response;

  AuthGetSecretKeySuccess({required this.response});
}

final class AuthAdd2FALoading extends AuthState {
  AuthAdd2FALoading();
}

final class AuthAdd2FASuccess extends AuthState {
  final ApiResponse<bool> response;

  AuthAdd2FASuccess({required this.response});
}

final class AuthAdd2FAFailure extends AuthState {
  final String message;
  AuthAdd2FAFailure(this.message);
}

final class AuthRemove2FALoading extends AuthState {
  AuthRemove2FALoading();
}

final class AuthRemove2FASuccess extends AuthState {
  final ApiResponse<bool> response;

  AuthRemove2FASuccess({required this.response});
}

final class AuthRemove2FAFailure extends AuthState {
  final String message;
  AuthRemove2FAFailure(this.message);
}

final class AuthVerifyOtpLoading extends AuthState {
  AuthVerifyOtpLoading();
}

final class VerifyOtpFor2FASuccess extends AuthState {
  final ApiResponse<OtpVerificationStatus> response;

  VerifyOtpFor2FASuccess({required this.response});
}

final class VerifyOtpForForgetPasswordSuccess extends AuthState {
  final ApiResponse<bool> response;

  VerifyOtpForForgetPasswordSuccess({required this.response});
}

final class AuthVerifyOtpFailure extends AuthState {
  final String message;
  AuthVerifyOtpFailure(this.message);
}

// Change Password States
class ChangePasswordLoading extends AuthState {}

class ChangePasswordSuccess extends AuthState {
  final ApiResponse<ChangePasswordDataModel> response;

  ChangePasswordSuccess({required this.response});
}

class ChangePasswordFailure extends AuthState {
  final String message;

  ChangePasswordFailure(this.message);
}

// Forget Password States
class ForgetPasswordLoading extends AuthState {}

class ForgetPasswordSuccess extends AuthState {
  final ApiResponse<bool> response;

  ForgetPasswordSuccess({required this.response});
}

class ForgetPasswordFailure extends AuthState {
  final String message;

  ForgetPasswordFailure(this.message);
}

// Reset Password States
class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {
  final ApiResponse<bool> response;

  ResetPasswordSuccess({required this.response});
}

class ResetPasswordFailure extends AuthState {
  final String message;

  ResetPasswordFailure(this.message);
}


