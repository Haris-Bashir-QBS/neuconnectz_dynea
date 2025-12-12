import 'dart:async';

import 'package:fpdart/fpdart.dart';

import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/two_fa_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/otp_verification_status.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase
    extends
        UseCase<
          ApiResponse<OtpVerificationStatus>,
          TwoFactorAuthenticationRequestModel
        > {
  final AuthRepository authRepository;

  VerifyOtpUseCase(this.authRepository);

  @override
  Future<Either<Failure, ApiResponse<OtpVerificationStatus>>> call(
    TwoFactorAuthenticationRequestModel params,
  ) async {
    return await authRepository.verifyOtp(params);
  }
}


