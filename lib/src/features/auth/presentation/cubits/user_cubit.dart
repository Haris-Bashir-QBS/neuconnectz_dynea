import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/features/auth/domain/entities/user_entity.dart';

class UserCubit extends Cubit<UserEntity?> {
  UserCubit() : super(null);

  void setUser(UserEntity user) => emit(user);

  UserEntity? get currentUser => state;

  void clearUser() => emit(null);
}
