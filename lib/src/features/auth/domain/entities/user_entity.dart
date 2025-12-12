class UserEntity {
  final String? name;
  final String? email;
  final String? userId;
  final String? userType;
  final String? token;
  final String? refreshToken;
  final String? secretKey;
  final bool? isTotp;

  const UserEntity({
    this.name,
    this.email,
    this.userId,
    this.userType,
    this.token,
    this.secretKey,
    this.isTotp,
    this.refreshToken,
  });

  UserEntity copyWith({
    String? name,
    String? email,
    String? userId,
    String? userType,
    String? token,
    String? refreshToken,
    String? secretKey,
    bool? isTotp,
  }) {
    return UserEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      userId: userId ?? this.userId,
      userType: userType ?? this.userType,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      secretKey: secretKey ?? this.secretKey,
      isTotp: isTotp ?? this.isTotp,
    );
  }
}


