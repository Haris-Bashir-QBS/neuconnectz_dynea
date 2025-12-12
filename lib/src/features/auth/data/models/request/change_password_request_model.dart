class ChangePasswordRequestModel {
  final String currentPassword;
  final String newPassword;
  final String email;

  ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'currentPassword': currentPassword,
    'newPassword': newPassword,
    'email': email,
  };
}


