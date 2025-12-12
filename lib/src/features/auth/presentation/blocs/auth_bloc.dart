import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/verify_otp_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/change_password_response_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/get_secret_key_response_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/otp_verification_status.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/user_model_to_entity_mapper.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/services/app_preferences.dart';
import '../../data/models/response/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/index.dart';
import '../cubits/user_cubit.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final FetchSecretKeyUsecase _getSecretKeyUsecase;
  final Add2FAUseCase _add2FAUseCase;
  final Remove2FAUseCase _remove2FAUseCase;
  final VerifyOtpUseCase _verifyOptUseCase;
  final UserCubit _userCubit;
  final ChangePasswordUsecase _changePasswordUseCase;
  final ForgetPasswordUsecase _forgetPasswordUsecase;
  final VerifyOtpForgetPasswordUsecase _verifyOtpForgetPasswordUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;

  AuthenticationBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required UserCubit userCubit,
    required FetchSecretKeyUsecase getSecretKeyUsecase,
    required Add2FAUseCase add2FAUseCase,
    required Remove2FAUseCase remove2FAUseCase,
    required VerifyOtpUseCase verifyOptUseCase,
    required ChangePasswordUsecase changePasswordUseCase,
    required ForgetPasswordUsecase forgetPasswordUsecase,
    required VerifyOtpForgetPasswordUsecase verifyOtpForgetPasswordUsecase,
    required ResetPasswordUsecase resetPasswordUsecase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _userCubit = userCubit,
       _getSecretKeyUsecase = getSecretKeyUsecase,
       _add2FAUseCase = add2FAUseCase,
       _remove2FAUseCase = remove2FAUseCase,
       _verifyOptUseCase = verifyOptUseCase,
       _changePasswordUseCase = changePasswordUseCase,
       _forgetPasswordUsecase = forgetPasswordUsecase,
       _verifyOtpForgetPasswordUsecase = verifyOtpForgetPasswordUsecase,
       _resetPasswordUsecase = resetPasswordUsecase,
       super(AuthInitial()) {
    on<AuthLoginEvent>(_onAuthLogin);
    on<AuthLogoutEvent>(_onAuthLogout);
    on<Get2FASecretKeyEvent>(_onGetSecretKey);
    on<Add2FAEvent>(_onAdd2FA);
    on<Remove2FAEvent>(_onRemove2FA);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ChangePasswordEvent>(_changePassword);
    on<ForgetPasswordRequestedEvent>(_onForgetPasswordRequested);
    on<VerifyOtpForForgetPasswordEvent>(_onVerifyOtpForForgetPassword);
    on<ResetPasswordRequestedEvent>(_onResetPasswordRequested);
  }

  /// =============================== Verify OTP  ===============================

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthVerifyOtpLoading());

    final Either<Failure, ApiResponse<OtpVerificationStatus>> result =
        await _verifyOptUseCase(event.params);

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (_) => throw UnimplementedError());
      emit(AuthVerifyOtpFailure(failure.message));
      return;
    }

    final response = result.fold((_) => throw UnimplementedError(), (r) => r);

    if (response.data?.isVerified == true && event.user != null) {
      final userEntity = event.user!.toEntity();

      await AppPreferences().saveUser(UserModel.fromEntity(userEntity));
      _userCubit.setUser(userEntity);
      await AppPreferences().saveTokens(
        accessToken: event.user!.token!,
        refreshToken: event.user!.refreshToken!,
      );
    }

    emit(VerifyOtpFor2FASuccess(response: response));
  }

  FutureOr<void> _onAdd2FA(Add2FAEvent event, Emitter<AuthState> emit) async {
    emit(AuthAdd2FALoading());
    final Either<Failure, ApiResponse<bool>> result = await _add2FAUseCase(
      event.params,
    );
    result.fold(
      (Failure failure) {
        emit(AuthAdd2FAFailure(failure.message));
      },
      (ApiResponse<bool> response) {
        emit(AuthAdd2FASuccess(response: response));
      },
    );
  }

  FutureOr<void> _changePassword(
    ChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(ChangePasswordLoading());
    final Either<Failure, ApiResponse<ChangePasswordDataModel>> result =
        await _changePasswordUseCase(event.params);
    result.fold(
      (Failure failure) {
        emit(ChangePasswordFailure(failure.message));
      },
      (ApiResponse<ChangePasswordDataModel> response) {
        emit(ChangePasswordSuccess(response: response));
      },
    );
  }

  /// =============================== Remove 2FA ===============================

  FutureOr<void> _onRemove2FA(
    Remove2FAEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthRemove2FALoading());
    final Either<Failure, ApiResponse<bool>> result = await _remove2FAUseCase(
      event.params,
    );
    result.fold(
      (Failure failure) {
        emit(AuthRemove2FAFailure(failure.message));
      },
      (ApiResponse<bool> response) {
        emit(AuthRemove2FASuccess(response: response));
      },
    );
  }

  /// =============================== Get Secret Key ===============================

  FutureOr<void> _onGetSecretKey(
    Get2FASecretKeyEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthGetSecretKeyLoading());
    final Either<Failure, GetSecretKeyResponseModel> result =
        await _getSecretKeyUsecase(NoParams());
    result.fold(
      (Failure failure) {
        emit(AuthGetSecretKeyFailure(failure.message));
      },
      (GetSecretKeyResponseModel response) {
        emit(AuthGetSecretKeySuccess(response: response));
      },
    );
  }

  /// =============================== Login ===============================
  FutureOr<void> _onAuthLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final Either<Failure, UserEntity> result = await _loginUseCase(
      event.params,
    );
    await result.fold(
      (Failure failure) {
        emit(AuthFailure(failure.message));
      },
      (UserEntity user) async {
        if ((user.token ?? "").isEmpty || (user.refreshToken ?? "").isEmpty) {
          emit(AuthFailure(AppTexts.invalidToken));
          return;
        }
        if (user.isTotp != true) {
          AppPreferences().saveUser(UserModel.fromEntity(user));
          _userCubit.setUser(user);
          await AppPreferences().saveTokens(
            accessToken: user.token!,
            refreshToken: user.refreshToken!,
          );
        }
        emit(AuthSuccess(user: user));
      },
    );
  }

  /// =============================== Logout ===============================
  FutureOr<void> _onAuthLogout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final Either<Failure, bool> result = await _logoutUseCase(NoParams());
    result.fold(
      (Failure failure) {
        emit(AuthFailure(failure.message));
      },
      (bool success) {
        _userCubit.clearUser();
        emit(AuthLogout());
      },
    );
  }

  Future<void> _onForgetPasswordRequested(
    ForgetPasswordRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(ForgetPasswordLoading());
    final result = await _forgetPasswordUsecase(event.params);
    result.fold(
      (failure) => emit(ForgetPasswordFailure(failure.message)),
      (response) => emit(ForgetPasswordSuccess(response: response)),
    );
  }

  Future<void> _onVerifyOtpForForgetPassword(
    VerifyOtpForForgetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthVerifyOtpLoading());
    final result = await _verifyOtpForgetPasswordUsecase(
      VerifyOtpRequestModel(otp: event.otp, email: event.email),
    );
    result.fold(
      (failure) => emit(AuthVerifyOtpFailure(failure.message)),
      (response) => emit(VerifyOtpForForgetPasswordSuccess(response: response)),
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(ResetPasswordLoading());
    final result = await _resetPasswordUsecase(event.params);
    result.fold(
      (failure) => emit(ResetPasswordFailure(failure.message)),
      (response) => emit(ResetPasswordSuccess(response: response)),
    );
  }
}


