import 'package:fpdart/fpdart.dart';
import 'dart:async';

import 'package:neuconnectz_dynea/src/core/errors/api_exceptions.dart';
import 'package:neuconnectz_dynea/src/core/use_cases/use_case.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase extends UseCase<UserEntity, SignupRequestModel> {
  final AuthRepository authRepository;

  SignupUseCase(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(params) async {
    return await authRepository.signUp(params: params);
  }
}


