import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/response/get_secret_key_response_model.dart';
import '../repositories/auth_repository.dart';

class FetchSecretKeyUsecase
    extends UseCase<GetSecretKeyResponseModel, NoParams> {
  final AuthRepository authRepository;

  FetchSecretKeyUsecase(this.authRepository);

  @override
  Future<Either<Failure, GetSecretKeyResponseModel>> call(
    NoParams params,
  ) async {
    return await authRepository.getSecretKey();
  }
}


