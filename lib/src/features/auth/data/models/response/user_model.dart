import 'package:neuconnectz_dynea/src/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.name,
    super.email,
    super.userId,
    super.userType,
    super.token,
    super.refreshToken,
    super.secretKey,
    super.isTotp,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'] as String?,
    email: json['email'] as String?,
    userId: json['userId'] as String?,
    userType: json['userType'] as String?,
    token: json['token'] as String?,
    refreshToken: json['refreshToken'] as String?,
    secretKey: json['secretKey'] as String?,
    isTotp: json['isTotp'] as bool?,
  );
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      name: entity.name,
      email: entity.email,
      userId: entity.userId,
      userType: entity.userType,
      token: entity.token,
      refreshToken: entity.refreshToken,
      secretKey: entity.secretKey,
      isTotp: entity.isTotp,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'userId': userId,
    'userType': userType,
    'token': token,
    'refreshToken': refreshToken,
    'secretKey': secretKey,
    'isTotp': isTotp,
  };
}


