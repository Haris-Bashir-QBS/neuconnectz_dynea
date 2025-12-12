import 'package:neuconnectz_dynea/src/features/auth/data/models/response/user_model.dart';
import 'package:neuconnectz_dynea/src/features/auth/domain/entities/user_entity.dart';

extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      name: name,
      email: email,
      userId: userId,
      userType: userType,
      token: token,
      refreshToken: refreshToken,
      secretKey: secretKey,
      isTotp: isTotp,
    );
  }
}


