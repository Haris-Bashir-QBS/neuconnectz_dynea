import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/two_fa_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/domain/repositories/auth_repository.dart';

class Add2FAUseCase
    extends UseCase<ApiResponse<bool>, TwoFactorAuthenticationRequestModel> {
  final AuthRepository authRepository;

  Add2FAUseCase(this.authRepository);

  @override
  Future<Either<Failure, ApiResponse<bool>>> call(
    TwoFactorAuthenticationRequestModel params,
  ) async {
    return await authRepository.add2FA(params);
  }
}


