import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/change_password_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/forget_password_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/login_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/reset_password_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/two_fa_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/verify_otp_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/change_password_response_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/get_secret_key_response_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/otp_verification_status.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> login({required LoginRequestModel params});
  Future<UserModel> signUp({required SignupRequestModel params});
  Future<GetSecretKeyResponseModel> getSecretKey();
  Future<bool> signOut();
  Future<ApiResponse<bool>> add2FA(TwoFactorAuthenticationRequestModel params);
  Future<ApiResponse<bool>> remove2FA(
    TwoFactorAuthenticationRequestModel params,
  );
  Future<ApiResponse<OtpVerificationStatus>> verifyOtp(
    TwoFactorAuthenticationRequestModel params,
  );
  Future<ApiResponse<ChangePasswordDataModel>> changePassword(
    ChangePasswordRequestModel params,
  );
  Future<ApiResponse<bool>> forgetPassword(ForgetPasswordRequestModel params);
  Future<ApiResponse<bool>> verifyOtpForForgetPassword(
    VerifyOtpRequestModel params,
  );
  Future<ApiResponse<bool>> resetPassword(ResetPasswordRequestModel params);
}


