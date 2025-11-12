import 'package:fpdart/fpdart.dart';
import 'dart:async';

import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/verify_otp_request_model.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpForgetPasswordUsecase
    extends UseCase<ApiResponse<bool>, VerifyOtpRequestModel> {
  final AuthRepository authRepository;

  VerifyOtpForgetPasswordUsecase(this.authRepository);

  @override
  Future<Either<Failure, ApiResponse<bool>>> call(
    VerifyOtpRequestModel params,
  ) async {
    return await authRepository.verifyOtpForForgetPassword(params);
  }
}
