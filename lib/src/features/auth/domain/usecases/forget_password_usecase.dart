import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/forget_password_request_model.dart';
import '../repositories/auth_repository.dart';

class ForgetPasswordUsecase
    extends UseCase<ApiResponse<bool>, ForgetPasswordRequestModel> {
  final AuthRepository authRepository;

  ForgetPasswordUsecase(this.authRepository);

  @override
  Future<Either<Failure, ApiResponse<bool>>> call(
    ForgetPasswordRequestModel params,
  ) async {
    return await authRepository.forgetPassword(params);
  }
}
