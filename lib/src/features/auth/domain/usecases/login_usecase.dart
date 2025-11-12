import 'dart:async';

import 'package:fpdart/fpdart.dart';

import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/login_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase extends UseCase<UserEntity, LoginRequestModel> {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(params) async {
    return await authRepository.login(params: params);
  }
}
