import 'package:fpdart/fpdart.dart';
import 'dart:async';

import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/reset_password_request_model.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUsecase
    extends UseCase<ApiResponse<bool>, ResetPasswordRequestModel> {
  final AuthRepository authRepository;

  ResetPasswordUsecase(this.authRepository);

  @override
  Future<Either<Failure, ApiResponse<bool>>> call(
    ResetPasswordRequestModel params,
  ) async {
    return await authRepository.resetPassword(params);
  }
}


