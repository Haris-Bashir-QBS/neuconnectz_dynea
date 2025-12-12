import 'dart:convert';
import 'dart:developer';

import 'package:neuconnectz_dynea/src/core/constants/app_errors.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_base.dart';
import 'package:neuconnectz_dynea/src/core/network/config/api_endpoints.dart';
import 'package:neuconnectz_dynea/src/core/network/config/error_handler.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/data_sources/remote/auth_remote_datasource.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/change_password_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/forget_password_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/login_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/reset_password_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/two_fa_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/verify_otp_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/change_password_response_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/get_secret_key_response_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/login_response_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/otp_verification_status.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/user_model.dart';

import '../../../../../core/utils/utils.dart';


class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  final DioClient _client;
  AuthRemoteDataSourceImplementation({required DioClient client})
      : _client = client;

  @override
  Future<UserModel> login({required LoginRequestModel params}) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.login.value,
        data: params.toJson(),
      );
      log("Response: ${response.data}");
      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data).user!;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<bool> signOut() async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(endpoint: ApiEndpoints.logout.value);
      log("Response: ${response.data}");
      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<UserModel> signUp({required SignupRequestModel params}) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.signup.value,
        data: params.toJson(),
      );

      log("Response: ${response.data}");
      final decodedJson = jsonDecode(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(decodedJson);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: decodedJson['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<GetSecretKeyResponseModel> getSecretKey() async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await _client.get(
        endpoint: ApiEndpoints.get2FASecretKey.value,
        customBaseUrl: ApiBase.lockKeysBaseUrl,
      );
      log("Response: ${response.data}");
      if (response.statusCode == 200) {
        return GetSecretKeyResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<ApiResponse<bool>> add2FA(
      TwoFactorAuthenticationRequestModel params,
      ) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.addOrUpdate2FA.value,
        data: {
          'userId': params.userId,
          'secretKey': params.secretKey,
          'isTotp': params.isTotp,
        },
      );
      log("Response: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<bool>.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<ApiResponse<bool>> remove2FA(
      TwoFactorAuthenticationRequestModel params,
      ) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.remove2FA.value,
        data: {'userId': params.userId},
      );
      log("Response: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<bool>.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<ApiResponse<OtpVerificationStatus>> verifyOtp(
      TwoFactorAuthenticationRequestModel params,
      ) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.verifyOtp.value,
        customBaseUrl: ApiBase.lockKeysBaseUrl,
        customHeaders: {"DeviceId": params.deviceId},
        data: {
          'totpCode': params.totp,
          'secetKey': params.secretKey,
          'timeLimitInSec': params.timeLimitInSec,
          'numOfDigits': params.numOfDigits,
        },
      );
      log("Response: ${response.data}");
      if (response.statusCode == 200) {
        return ApiResponse<OtpVerificationStatus>.fromJson(
          response.data,
          fromJsonT:
              (json) =>
              OtpVerificationStatus.fromJson(json as Map<String, dynamic>),
        );
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<ApiResponse<ChangePasswordDataModel>> changePassword(
      ChangePasswordRequestModel params,
      ) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.changePassword.value,
        data: params.toJson(),
      );
      log("Response: ${response.data}");
      if (response.statusCode == 200) {
        return ApiResponse<ChangePasswordDataModel>.fromJson(
          response.data,
          fromJsonT:
              (json) => ChangePasswordDataModel.fromJson(
            json as Map<String, dynamic>,
          ),
        );
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<ApiResponse<bool>> forgetPassword(
      ForgetPasswordRequestModel params,
      ) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.forgetPassword.value,
        data: params.toJson(),
      );
      log("Response: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<bool>.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<ApiResponse<bool>> verifyOtpForForgetPassword(
      VerifyOtpRequestModel params,
      ) async {
    return ApiErrorHandler.executeGuarded(() async {
      String? deviceId = await Utils.getDeviceId();
      final response = await _client.post(
        endpoint: ApiEndpoints.verifyOtpForForgetPassword.value,
        customHeaders: {"DeviceId": deviceId},
        data: params.toJson(),
      );
      log("Response: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<bool>.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<ApiResponse<bool>> resetPassword(
      ResetPasswordRequestModel params,
      ) async {
    return ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.resetPassword.value,
        data: params.toJson(),
      );
      log("Response: ${response.data}");
      if (response.statusCode == 200) {
        return ApiResponse<bool>.fromJson(response.data);
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }
}

