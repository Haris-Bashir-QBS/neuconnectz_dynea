class ResetPasswordRequestModel {
  final String email;
  final String password;

  ResetPasswordRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}


