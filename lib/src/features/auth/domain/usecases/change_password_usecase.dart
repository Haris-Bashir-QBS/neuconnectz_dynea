import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/network/models/api_generic_response.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/change_password_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/change_password_response_model.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordUsecase
    extends
        UseCase<
          ApiResponse<ChangePasswordDataModel>,
          ChangePasswordRequestModel
        > {
  final AuthRepository authRepository;

  ChangePasswordUsecase(this.authRepository);

  @override
  Future<Either<Failure, ApiResponse<ChangePasswordDataModel>>> call(
    ChangePasswordRequestModel params,
  ) async {
    return await authRepository.changePassword(params);
  }
}


